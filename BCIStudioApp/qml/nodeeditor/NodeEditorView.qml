import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects
import QtQuick.Dialogs

Rectangle {
    id: nodeEditorView
    anchors.fill: parent
    color: appTheme.backgroundPrimary

    // Properties
    property var currentNodeGraph: nodeGraphManager ? nodeGraphManager.currentGraph : null
    property var selectedNode: null
    property var selectedNodes: []
    property bool isDraggingNode: false
    property var draggingNodeData: null
    property bool isExecuting: false
    property real executionProgress: 0.0
    property bool leftSidebarCollapsed: false
    property bool rightSidebarCollapsed: false
    property bool isCreatingNode: false
    property string draggingNodeType: ""
    property var nodePreview: null
    property point dropPosition: Qt.point(0, 0)

    // External dependencies
    property var nodeGraphManager: null
    property var nodeRegistry: null
    property var pipelineValidator: null

    // Theme Manager
    property var appTheme: {
        "backgroundPrimary": "#FFFFFF",
        "backgroundSecondary": "#F8F9FA",
        "backgroundTertiary": "#E9ECEF",
        "backgroundCard": "#FFFFFF",
        "primary": "#4361EE",
        "secondary": "#3A0CA3",
        "accent": "#7209B7",
        "success": "#4CC9F0",
        "warning": "#F72585",
        "error": "#EF476F",
        "info": "#4895EF",
        "textPrimary": "#212529",
        "textSecondary": "#6C757D",
        "textTertiary": "#ADB5BD",
        "textDisabled": "#CED4DA",
        "border": "#DEE2E6"
    }

    // سیگنال‌های اصلی
    signal nodeCreated(var nodeData)
    signal nodeDeleted(string nodeId)
    signal connectionCreated(var connectionData)
    signal connectionDeleted(string connectionId)
    signal graphModified()
    signal nodeSelectionChanged(var nodes)
    signal executionInitiated()
    signal executionCompleted()
    signal pipelineValidationRequested()
    signal pipelineAnalysisRequested()
    signal pipelineOptimizationRequested()
    signal pipelineExportRequested()

    // Background with subtle pattern
    Rectangle {
        anchors.fill: parent
        color: appTheme.backgroundPrimary

        Canvas {
            id: backgroundCanvas
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.05)
                ctx.lineWidth = 1

                // Draw subtle grid pattern
                var gridSize = 20
                var offsetX = (nodeCanvas ? nodeCanvas.viewOffset.x % gridSize : 0)
                var offsetY = (nodeCanvas ? nodeCanvas.viewOffset.y % gridSize : 0)

                for (var x = offsetX; x < width; x += gridSize) {
                    ctx.beginPath()
                    ctx.moveTo(x, 0)
                    ctx.lineTo(x, height)
                    ctx.stroke()
                }
                for (var y = offsetY; y < height; y += gridSize) {
                    ctx.beginPath()
                    ctx.moveTo(0, y)
                    ctx.lineTo(width, y)
                    ctx.stroke()
                }
            }
        }
    }

    // Global Mouse Area for Drag Handling
    MouseArea {
        id: globalMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        hoverEnabled: true
        propagateComposedEvents: true

        onPositionChanged: (mouse) => {
            if (nodeEditorView.isDraggingNode) {
                nodeEditorView.handleDragMove(mouse.x, mouse.y);
            }
        }

        onReleased: (mouse) => {
            if (nodeEditorView.isDraggingNode) {
                // ذخیره موقعیت دقیق دراپ
                nodeEditorView.dropPosition = Qt.point(mouse.x, mouse.y);
                // Check if drop is on canvas
                var canvasPos = nodeCanvas.mapFromItem(nodeEditorView, mouse.x, mouse.y);
                if (canvasPos.x >= 0 && canvasPos.x <= nodeCanvas.width &&
                    canvasPos.y >= 0 && canvasPos.y <= nodeCanvas.height) {
                    nodeEditorView.handleDrop(mouse.x, mouse.y);
                } else {
                    console.log("❌ Drop cancelled - outside canvas");
                    nodeEditorView.cleanupDrag();
                }
            }
        }
    }

    // Main Layout
    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left Sidebar - Node Toolbox
        NodeToolbox {
            id: nodeToolbox
            Layout.preferredWidth: leftSidebarCollapsed ? 60 : 320
            Layout.minimumWidth: leftSidebarCollapsed ? 60 : 280
            Layout.maximumWidth: 400
            Layout.fillHeight: true
            theme: appTheme
            z: 10

            onNodeDragStarted: (nodeType, mouse) => {
                console.log("🔄 Node drag started from toolbox:", nodeType);
                var globalPos = nodeToolbox.mapToItem(nodeEditorView, mouse.x, mouse.y);
                nodeEditorView.startNodeDrag(nodeType, globalPos);
            }

            onCategorySelected: (category) => {
                console.log("Category selected:", category)
            }

            states: [
                State {
                    name: "collapsed"
                    when: leftSidebarCollapsed
                    PropertyChanges { target: nodeToolbox; opacity: 0.7 }
                }
            ]

            Behavior on Layout.preferredWidth {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }
        }

        // Main Content Area
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Top Toolbar
            NodeEditorToolbar {
                id: editorToolbar
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                theme: appTheme

                nodeGraph: nodeEditorView.currentNodeGraph
                selectedNodes: nodeEditorView.selectedNodes
                isExecuting: nodeEditorView.isExecuting
                executionProgress: nodeEditorView.executionProgress
                leftSidebarCollapsed: nodeEditorView.leftSidebarCollapsed
                rightSidebarCollapsed: nodeEditorView.rightSidebarCollapsed

                onNewGraph: nodeEditorView.createNewGraph()
                onLoadGraph: fileDialog.open()
                onSaveGraph: nodeEditorView.saveGraph()
                onZoomIn: nodeCanvas.zoomIn()
                onZoomOut: nodeCanvas.zoomOut()
                onZoomReset: nodeCanvas.zoomReset()
                onFitToView: nodeCanvas.fitToView()
                onLayoutGraph: nodeCanvas.autoLayout()
                onClearGraph: nodeEditorView.clearGraph()
                onRunGraph: nodeEditorView.executeGraph()
                onStopGraph: nodeEditorView.stopExecution()
                onValidateGraph: nodeEditorView.pipelineValidationRequested()
                onToggleLeftSidebar: nodeEditorView.leftSidebarCollapsed = !nodeEditorView.leftSidebarCollapsed
                onToggleRightSidebar: nodeEditorView.rightSidebarCollapsed = !nodeEditorView.rightSidebarCollapsed
            }

            // Node Canvas Container
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"
                clip: true

                // Node Canvas
                NodeCanvas {
                    id: nodeCanvas
                    anchors.fill: parent
                    theme: appTheme
                    z: 1

                    nodeGraph: nodeEditorView.currentNodeGraph
                    selectedNode: nodeEditorView.selectedNode
                    selectedNodes: nodeEditorView.selectedNodes

                    onNodeSelected: (node) => {
                        nodeEditorView.selectedNode = node
                        nodeEditorView.selectedNodes = [node]
                        nodeEditorView.nodeSelectionChanged([node])
                    }

                    onNodesSelected: (nodes) => {
                        nodeEditorView.selectedNodes = nodes
                        nodeEditorView.selectedNode = nodes.length === 1 ? nodes[0] : null
                        nodeEditorView.nodeSelectionChanged(nodes)
                    }

                    onNodeDeselected: {
                        nodeEditorView.selectedNode = null
                        nodeEditorView.selectedNodes = []
                        nodeEditorView.nodeSelectionChanged([])
                    }

                    onNodeMoved: (nodeId, position) => {
                        if (nodeGraphManager && nodeGraphManager.updateNodePosition) {
                            nodeGraphManager.updateNodePosition(nodeId, position)
                            nodeEditorView.graphModified()
                        }
                    }

                    onNodeDoubleClicked: (node) => {
                        nodeEditorView.editNodeProperties(node)
                    }

                    onConnectionCreated: (connectionData) => {
                        if (nodeGraphManager && nodeGraphManager.createConnection) {
                            nodeGraphManager.createConnection(connectionData)
                            nodeEditorView.connectionCreated(connectionData)
                            nodeEditorView.graphModified()
                        }
                    }

                    onConnectionDeleted: (connectionId) => {
                        if (nodeGraphManager && nodeGraphManager.removeConnection) {
                            nodeGraphManager.removeConnection(connectionId)
                            nodeEditorView.connectionDeleted(connectionId)
                            nodeEditorView.graphModified()
                        }
                    }

                    onNodesDeleted: (nodeIds) => {
                        nodeEditorView.deleteNodes(nodeIds)
                    }

                    onCanvasRightClicked: (mouseX, mouseY) => {
                        var graphPos = nodeCanvas.calculateScreenToGraphPosition(mouseX, mouseY);
                        canvasContextMenu.clickPos = graphPos;
                        canvasContextMenu.open(mouseX, mouseY);
                    }

                    onCanvasDoubleClicked: (mouseX, mouseY) => {
                        var graphPos = nodeCanvas.calculateScreenToGraphPosition(mouseX, mouseY);
                        console.log("Canvas double clicked at:", graphPos);
                    }

                    onViewChanged: {
                        backgroundCanvas.requestPaint()
                    }
                }

                // Drop Area for new nodes - بهبود یافته
                DropArea {
                    id: canvasDropArea
                    anchors.fill: parent
                    keys: ["node/new"]
                    enabled: true
                    z: 2

                    onEntered: (drag) => {
                        console.log("📍 Drag entered canvas area");
                        if (drag.keys.indexOf("node/new") !== -1) {
                            drag.accept();
                        }
                    }

                    onDropped: (drop) => {
                        console.log("🎯 Drop occurred at:", drop.x, drop.y);
                        if (drop.keys.indexOf("node/new") !== -1) {
                            var nodeType = drop.getDataAsString("node/type");
                            if (nodeType) {
                                // استفاده از موقعیت دقیق دراپ
                                var graphPos = nodeCanvas.calculateScreenToGraphPosition(drop.x, drop.y);
                                console.log("📐 Creating node at exact drop position:", graphPos.x, graphPos.y);
                                nodeEditorView.createNodeAtPosition(nodeType, graphPos);
                            }
                        }
                    }
                }

                // Canvas Mouse Area for Drag Tracking
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    hoverEnabled: true
                    z: 3
                    propagateComposedEvents: true

                    onPositionChanged: (mouse) => {
                        if (nodeEditorView.isDraggingNode) {
                            nodeEditorView.handleDragMove(mouse.x, mouse.y);
                            mouse.accepted = true;
                        }
                    }

                    onReleased: (mouse) => {
                        if (nodeEditorView.isDraggingNode) {
                            nodeEditorView.dropPosition = Qt.point(mouse.x, mouse.y);
                            nodeEditorView.handleDrop(mouse.x, mouse.y);
                            mouse.accepted = true;
                        }
                    }
                }

                // Drop Indicator - نشانگر موقعیت دراپ
                Rectangle {
                    id: dropIndicator
                    width: 8
                    height: 8
                    radius: 4
                    color: appTheme.primary
                    visible: nodeEditorView.isDraggingNode
                    z: 1000

                    x: nodeEditorView.dropPosition.x - width/2
                    y: nodeEditorView.dropPosition.y - height/2
                }
            }
        }

        // Right Sidebar - Properties and Info
        Rectangle {
            id: rightSidebarContainer
            Layout.preferredWidth: rightSidebarCollapsed ? 0 : 380
            Layout.minimumWidth: rightSidebarCollapsed ? 0 : 320
            Layout.maximumWidth: 500
            Layout.fillHeight: true
            color: "transparent"
            z: 5

            // محتوای سایدبار راست...
        }
    }

    // Context Menus
    NodeContextMenu {
        id: nodeContextMenu
        node: nodeEditorView.selectedNode
        theme: appTheme

        onDeleteNode: nodeEditorView.deleteNode(node.nodeId)
        onCloneNode: nodeEditorView.cloneNode(node.nodeId)
        onEditProperties: nodeEditorView.editNodeProperties(node)
        onCopyNode: nodeEditorView.copySelectedNodes()
        onCutNode: nodeEditorView.cutSelectedNodes()
        onDisableNode: nodeEditorView.disableNode(node.nodeId)
        onEnableNode: nodeEditorView.enableNode(node.nodeId)
    }

    CanvasContextMenu {
        id: canvasContextMenu
        canvas: nodeCanvas
        nodeRegistry: nodeRegistry
        theme: appTheme

        onPasteNodes: nodeEditorView.pasteNodes()
        onSelectAll: nodeCanvas.selectAllNodes()
        onDeselectAll: nodeCanvas.deselectAllNodes()
        onCreateNode: (nodeType) => {
            var centerPos = Qt.point(nodeCanvas.width / 2, nodeCanvas.height / 2);
            var graphPos = nodeCanvas.calculateScreenToGraphPosition(centerPos.x, centerPos.y);
            nodeEditorView.createNodeAtPosition(nodeType, graphPos);
        }
        onImportGraph: fileDialog.open()
        onExportGraph: saveDialog.open()
        onLayoutGraph: nodeCanvas.autoLayout()
        onClearGraph: nodeEditorView.clearGraph()
    }

    // Dialogs
    FileDialog {
        id: fileDialog
        title: "Open BCI Pipeline"
        nameFilters: ["BCI Pipeline Files (*.bpi)", "JSON Files (*.json)", "All Files (*)"]
        onAccepted: nodeEditorView.loadGraph(fileDialog.selectedFile)
    }

    FileDialog {
        id: saveDialog
        title: "Save BCI Pipeline"
        nameFilters: ["BCI Pipeline Files (*.bpi)", "JSON Files (*.json)", "All Files (*)"]
        fileMode: FileDialog.SaveFile
        onAccepted: nodeEditorView.saveGraph(saveDialog.selectedFile)
    }

    // کامپوننت پیش‌نمایش نود - بهبود یافته
    Component {
        id: nodePreviewComponent

        Rectangle {
            id: nodePreview
            property string nodeType: ""
            width: 120
            height: 60
            color: Qt.rgba(0.2, 0.4, 0.8, 0.7)
            radius: 8
            border.color: "white"
            border.width: 2
            z: 1000

            // دنبال کردن دقیق ماوس
            x: nodeEditorView.dropPosition.x - width / 2
            y: nodeEditorView.dropPosition.y - height / 2

            Row {
                anchors.centerIn: parent
                spacing: 8

                Text {
                    text: nodeEditorView.getNodeIcon(nodeType)
                    font.pixelSize: 16
                    color: "white"
                }

                Text {
                    text: nodeEditorView.getNodeName(nodeType)
                    color: "white"
                    font.family: "Segoe UI"
                    font.pixelSize: 11
                    font.bold: true
                }
            }
        }
    }

    // توابع Drag & Drop بهبود یافته
    function startNodeDrag(nodeType, mousePos) {
        console.log("🚀 Starting node drag:", nodeType, "at:", mousePos.x, mousePos.y);

        nodeEditorView.isDraggingNode = true;
        nodeEditorView.draggingNodeType = nodeType;
        nodeEditorView.dropPosition = Qt.point(mousePos.x, mousePos.y);

        // ایجاد پیش‌نمایش
        nodeEditorView.nodePreview = nodePreviewComponent.createObject(nodeCanvas, {
            nodeType: nodeType
        });

        console.log("✅ Preview created at exact mouse position");
    }

    function handleDragMove(mouseX, mouseY) {
        if (nodeEditorView.isDraggingNode) {
            // آپدیت موقعیت دقیق
            nodeEditorView.dropPosition = Qt.point(mouseX, mouseY);

            if (nodeEditorView.nodePreview) {
                nodeEditorView.nodePreview.x = mouseX - nodeEditorView.nodePreview.width / 2;
                nodeEditorView.nodePreview.y = mouseY - nodeEditorView.nodePreview.height / 2;
            }
        }
    }

    function handleDrop(mouseX, mouseY) {
        if (nodeEditorView.isDraggingNode && nodeEditorView.draggingNodeType) {
            // استفاده از موقعیت دقیق ماوس
            var canvasPos = nodeCanvas.mapFromItem(nodeEditorView, mouseX, mouseY);
            var graphPos = nodeCanvas.calculateScreenToGraphPosition(canvasPos.x, canvasPos.y);

            console.log("🎯 Final exact drop position:", graphPos.x, graphPos.y);
            nodeEditorView.createNodeAtPosition(nodeEditorView.draggingNodeType, graphPos);
        }
        nodeEditorView.cleanupDrag();
    }

    function createNodeAtPosition(nodeType, position) {
        console.log("🔧 Creating node:", nodeType, "at exact position:", position.x, position.y);

        // اعتبارسنجی موقعیت
        if (!position || isNaN(position.x) || isNaN(position.y)) {
            console.error("❌ Invalid position, using drop position");
            position = nodeCanvas.calculateScreenToGraphPosition(nodeEditorView.dropPosition.x, nodeEditorView.dropPosition.y);
        }

        if (nodeGraphManager && nodeGraphManager.createNode) {
            var node = nodeGraphManager.createNode(nodeType, position);
            if (node) {
                nodeCreated(node);
                selectedNode = node;
                selectedNodes = [node];
                graphModified();
                console.log("✅ Node created successfully at exact position");
                return node;
            }
        }

        // Fallback با پورت‌های کامل
        var nodeData = {
            nodeId: "node_" + Math.random().toString(36).substr(2, 9),
            type: nodeType,
            name: getNodeName(nodeType),
            position: position,
            category: getNodeCategory(nodeType),
            icon: getNodeIcon(nodeType),
            parameters: getDefaultParameters(nodeType),
            ports: getDefaultPorts(nodeType),
            enabled: true,
            status: "idle"
        };

        nodeCreated(nodeData);
        selectedNode = nodeData;
        selectedNodes = [nodeData];
        graphModified();
        console.log("📝 Created fallback node with ports");
        return nodeData;
    }

    function cleanupDrag() {
        nodeEditorView.isDraggingNode = false;
        nodeEditorView.draggingNodeType = "";
        nodeEditorView.dropPosition = Qt.point(0, 0);
        if (nodeEditorView.nodePreview) {
            nodeEditorView.nodePreview.destroy();
            nodeEditorView.nodePreview = null;
        }
        console.log("🧹 Drag cleaned up");
    }

    // توابع کمکی با پورت‌های کامل
    function getNodeName(nodeType) {
        var names = {
            "eeg_input": "EEG Input",
            "file_reader": "File Reader",
            "signal_generator": "Signal Generator",
            "bandpass_filter": "Bandpass Filter",
            "notch_filter": "Notch Filter",
            "artifact_removal": "Artifact Removal",
            "psd_features": "PSD Features",
            "csp_features": "CSP Features",
            "p300_speller": "P300 Speller",
            "ssvep_detector": "SSVEP Detector",
            "motor_imagery": "Motor Imagery"
        }
        return names[nodeType] || nodeType;
    }

    function getNodeCategory(nodeType) {
        var categories = {
            "eeg_input": "Data Acquisition",
            "file_reader": "Data Acquisition",
            "signal_generator": "Data Acquisition",
            "bandpass_filter": "Preprocessing",
            "notch_filter": "Preprocessing",
            "artifact_removal": "Preprocessing",
            "psd_features": "Feature Extraction",
            "csp_features": "Feature Extraction",
            "p300_speller": "BCI Paradigms",
            "ssvep_detector": "BCI Paradigms",
            "motor_imagery": "BCI Paradigms"
        }
        return categories[nodeType] || "Utilities";
    }

    function getNodeIcon(nodeType) {
        var icons = {
            "eeg_input": "🧠",
            "file_reader": "📁",
            "signal_generator": "📡",
            "bandpass_filter": "📈",
            "notch_filter": "🔇",
            "artifact_removal": "✨",
            "psd_features": "📊",
            "csp_features": "🧩",
            "p300_speller": "🔤",
            "ssvep_detector": "📊",
            "motor_imagery": "💪"
        }
        return icons[nodeType] || "⚙️";
    }

    function getDefaultParameters(nodeType) {
        var parameters = {
            "bandpass_filter": {
                "low_cut": {value: 1.0, type: "number", min: 0.1, max: 50.0, step: 0.1},
                "high_cut": {value: 30.0, type: "number", min: 1.0, max: 100.0, step: 0.1},
                "order": {value: 4, type: "number", min: 1, max: 10, step: 1}
            },
            "p300_speller": {
                "stimulation_duration": {value: 100, type: "number", min: 50, max: 500, step: 10},
                "isi": {value: 75, type: "number", min: 25, max: 200, step: 5},
                "matrix_size": {value: "6x6", type: "options", options: ["4x4", "5x5", "6x6", "8x8"]}
            }
        }
        return parameters[nodeType] || {};
    }

    function getDefaultPorts(nodeType) {
        var ports = {
            "eeg_input": [
                {portId: "eeg_output", name: "EEG Output", direction: "output", dataType: "EEGSignal", connected: false}
            ],
            "file_reader": [
                {portId: "data_output", name: "Data Output", direction: "output", dataType: "EEGSignal", connected: false}
            ],
            "signal_generator": [
                {portId: "signal_output", name: "Signal Output", direction: "output", dataType: "EEGSignal", connected: false}
            ],
            "bandpass_filter": [
                {portId: "signal_input", name: "Signal Input", direction: "input", dataType: "EEGSignal", connected: false},
                {portId: "filtered_output", name: "Filtered Output", direction: "output", dataType: "EEGSignal", connected: false}
            ],
            "notch_filter": [
                {portId: "signal_input", name: "Signal Input", direction: "input", dataType: "EEGSignal", connected: false},
                {portId: "filtered_output", name: "Filtered Output", direction: "output", dataType: "EEGSignal", connected: false}
            ],
            "artifact_removal": [
                {portId: "signal_input", name: "Signal Input", direction: "input", dataType: "EEGSignal", connected: false},
                {portId: "clean_output", name: "Clean Output", direction: "output", dataType: "EEGSignal", connected: false}
            ],
            "psd_features": [
                {portId: "signal_input", name: "Signal Input", direction: "input", dataType: "EEGSignal", connected: false},
                {portId: "features_output", name: "Features Output", direction: "output", dataType: "FeatureVector", connected: false}
            ],
            "csp_features": [
                {portId: "signal_input", name: "Signal Input", direction: "input", dataType: "EEGSignal", connected: false},
                {portId: "features_output", name: "Features Output", direction: "output", dataType: "FeatureVector", connected: false}
            ],
            "p300_speller": [
                {portId: "eeg_input", name: "EEG Input", direction: "input", dataType: "EEGSignal", connected: false},
                {portId: "classification", name: "Classification", direction: "output", dataType: "ClassificationResult", connected: false}
            ],
            "ssvep_detector": [
                {portId: "eeg_input", name: "EEG Input", direction: "input", dataType: "EEGSignal", connected: false},
                {portId: "detection", name: "Detection", direction: "output", dataType: "ClassificationResult", connected: false}
            ],
            "motor_imagery": [
                {portId: "eeg_input", name: "EEG Input", direction: "input", dataType: "EEGSignal", connected: false},
                {portId: "classification", name: "Classification", direction: "output", dataType: "ClassificationResult", connected: false}
            ]
        }
        return ports[nodeType] || [];
    }

    // بقیه توابع مدیریت...
    function deleteNode(nodeId) {
        if (nodeGraphManager && nodeGraphManager.removeNode) {
            nodeGraphManager.removeNode(nodeId)
        }
        nodeEditorView.nodeDeleted(nodeId)
        if (nodeEditorView.selectedNode && nodeEditorView.selectedNode.nodeId === nodeId) {
            nodeEditorView.selectedNode = null
            nodeEditorView.selectedNodes = []
        }
        nodeEditorView.graphModified()
    }

    function deleteNodes(nodeIds) {
        nodeIds.forEach(function(nodeId) {
            if (nodeGraphManager && nodeGraphManager.removeNode) {
                nodeGraphManager.removeNode(nodeId)
            }
            nodeEditorView.nodeDeleted(nodeId)
        })
        if (nodeEditorView.selectedNode && nodeIds.includes(nodeEditorView.selectedNode.nodeId)) {
            nodeEditorView.selectedNode = null
            nodeEditorView.selectedNodes = []
        }
        nodeEditorView.graphModified()
    }

    function deleteSelectedNodes() {
        if (nodeEditorView.selectedNodes.length > 0) {
            nodeEditorView.deleteNodes(nodeEditorView.selectedNodes.map(node => node.nodeId))
        }
    }

    function cloneNode(nodeId) {
        var originalNode = nodeGraphManager ? nodeGraphManager.getNode(nodeId) : null
        if (originalNode) {
            var newPos = Qt.point(originalNode.position.x + 50, originalNode.position.y + 50)
            var clonedNode = nodeGraphManager ? nodeGraphManager.cloneNode(nodeId, newPos) : null
            if (clonedNode) {
                nodeEditorView.nodeCreated(clonedNode)
                nodeEditorView.selectedNode = clonedNode
                nodeEditorView.selectedNodes = [clonedNode]
                nodeEditorView.graphModified()
            }
        }
    }

    function editNodeProperties(node) {
        propertiesTabBar.currentIndex = 0
    }

    function createNewGraph() {
        if (nodeGraphManager && nodeGraphManager.createNewGraph) {
            nodeGraphManager.createNewGraph()
        }
        nodeEditorView.selectedNode = null
        nodeEditorView.selectedNodes = []
        nodeEditorView.graphModified()
    }

    function clearGraph() {
        if (nodeGraphManager && nodeGraphManager.clearGraph) {
            nodeGraphManager.clearGraph()
        }
        nodeEditorView.selectedNode = null
        nodeEditorView.selectedNodes = []
        nodeEditorView.graphModified()
    }

    function executeGraph() {
        if (nodeEditorView.validatePipeline()) {
            nodeEditorView.isExecuting = true
            nodeEditorView.executionProgress = 0.0
            nodeEditorView.executionInitiated()

            // شبیه‌سازی اجرای پایپ‌لاین
            var progress = 0
            var progressTimer = Qt.createQmlObject(`
                import QtQuick 2.15
                Timer {
                    interval: 100
                    running: true
                    repeat: true
                    onTriggered: {
                        progress += 0.01
                        nodeEditorView.executionProgress = progress
                        if (progress >= 1.0) {
                            stop()
                            nodeEditorView.isExecuting = false
                            nodeEditorView.executionCompleted()
                        }
                    }
                }
            `, nodeEditorView)
        }
    }

    function stopExecution() {
        nodeEditorView.isExecuting = false
        nodeEditorView.executionCompleted()
    }

    function validatePipeline() {
        if (!nodeEditorView.currentNodeGraph ||
            (nodeEditorView.currentNodeGraph.nodes && nodeEditorView.currentNodeGraph.nodes.length === 0)) {
            errorDialog.showError("Pipeline is empty. Add some nodes to create a BCI pipeline.")
            return false
        }

        var hasConnections = nodeEditorView.currentNodeGraph.connections &&
                           nodeEditorView.currentNodeGraph.connections.length > 0
        if (!hasConnections) {
            errorDialog.showError("Pipeline has no connections. Connect nodes to create a valid pipeline.")
            return false
        }

        return true
    }

    function saveGraph(filePath) {
        if (nodeGraphManager && nodeGraphManager.saveToFile) {
            var success = nodeGraphManager.saveToFile(filePath)
            if (success) {
                console.log("Graph saved successfully:", filePath)
            } else {
                errorDialog.showError("Failed to save graph to: " + filePath)
            }
        } else {
            errorDialog.showError("Save functionality not implemented")
        }
    }

    function loadGraph(filePath) {
        if (nodeGraphManager && nodeGraphManager.loadFromFile) {
            var success = nodeGraphManager.loadFromFile(filePath)
            if (success) {
                nodeEditorView.selectedNode = null
                nodeEditorView.selectedNodes = []
                console.log("Graph loaded successfully:", filePath)
            } else {
                errorDialog.showError("Failed to load graph from: " + filePath)
            }
        } else {
            errorDialog.showError("Load functionality not implemented")
        }
    }

    // Clipboard management
    function copySelectedNodes() {
        if (nodeEditorView.selectedNodes.length > 0) {
            console.log("Copying", nodeEditorView.selectedNodes.length, "nodes")
        }
    }

    function cutSelectedNodes() {
        if (nodeEditorView.selectedNodes.length > 0) {
            nodeEditorView.copySelectedNodes()
            nodeEditorView.deleteSelectedNodes()
        }
    }

    function pasteNodes() {
        console.log("Pasting nodes")
    }

    function disableNode(nodeId) {
        if (nodeGraphManager && nodeGraphManager.setNodeEnabled) {
            nodeGraphManager.setNodeEnabled(nodeId, false)
            nodeEditorView.graphModified()
        }
    }

    function enableNode(nodeId) {
        if (nodeGraphManager && nodeGraphManager.setNodeEnabled) {
            nodeGraphManager.setNodeEnabled(nodeId, true)
            nodeEditorView.graphModified()
        }
    }

    // Status bar
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 28
        color: appTheme.backgroundSecondary
        border.color: appTheme.border
        border.width: 1
        z: 10

        RowLayout {
            anchors.fill: parent
            anchors.margins: 6

            Text {
                text: "Nodes: " + (currentNodeGraph && currentNodeGraph.nodes ? currentNodeGraph.nodes.length : 0) +
                      " | Connections: " + (currentNodeGraph && currentNodeGraph.connections ? currentNodeGraph.connections.length : 0) +
                      " | Selected: " + selectedNodes.length
                color: appTheme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 11
                Layout.fillWidth: true
            }

            Text {
                text: {
                    if (isExecuting) return "⚡ Executing..."
                    if (currentNodeGraph && currentNodeGraph.nodes && currentNodeGraph.nodes.length > 0) return "✅ Ready"
                    return "🟡 No Pipeline"
                }
                color: isExecuting ? appTheme.warning :
                       (currentNodeGraph && currentNodeGraph.nodes && currentNodeGraph.nodes.length > 0) ? appTheme.success : appTheme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 11
                font.bold: true
            }
        }
    }

    // مدیریت رویدادهای کیبورد
    Shortcut {
        sequence: "Ctrl+N"
        onActivated: nodeEditorView.createNewGraph()
    }

    Shortcut {
        sequence: "Ctrl+O"
        onActivated: fileDialog.open()
    }

    Shortcut {
        sequence: "Ctrl+S"
        onActivated: nodeEditorView.saveGraph()
    }

    Shortcut {
        sequence: "Delete"
        onActivated: nodeEditorView.deleteSelectedNodes()
    }

    Shortcut {
        sequence: "Ctrl+C"
        onActivated: nodeEditorView.copySelectedNodes()
    }

    Shortcut {
        sequence: "Ctrl+V"
        onActivated: nodeEditorView.pasteNodes()
    }

    Shortcut {
        sequence: "Ctrl+A"
        onActivated: nodeCanvas.selectAllNodes()
    }

    Shortcut {
        sequence: "Ctrl+D"
        onActivated: {
            if (nodeEditorView.selectedNode) {
                nodeEditorView.cloneNode(nodeEditorView.selectedNode.nodeId)
            }
        }
    }

    Shortcut {
        sequence: "F5"
        onActivated: nodeEditorView.executeGraph()
    }

    Shortcut {
        sequence: "Escape"
        onActivated: {
            if (nodeEditorView.isDraggingNode) {
                nodeEditorView.cleanupDrag()
            } else {
                nodeEditorView.stopExecution()
            }
        }
    }

    // Initialization
    Component.onCompleted: {
        console.log("🧠 Node Editor initialized with exact drop positioning");
        console.log("📊 NodeGraphManager available:", nodeGraphManager !== null);
        console.log("📚 NodeRegistry available:", nodeRegistry !== null);
        console.log("✅ PipelineValidator available:", pipelineValidator !== null);

        // Initialize node registry
        if (nodeRegistry && nodeRegistry.loadBCINodeLibrary) {
            nodeRegistry.loadBCINodeLibrary();
        }

        // Load default graph or create new one
        if (!nodeEditorView.currentNodeGraph) {
            nodeEditorView.createNewGraph();
        }
    }
}
