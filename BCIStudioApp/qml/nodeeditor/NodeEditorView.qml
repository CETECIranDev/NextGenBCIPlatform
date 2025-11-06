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
    property var currentNodeGraph: nodeGraphManager.currentGraph
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

            onNodeDragStarted: (nodeType, mouse) => {
                nodeEditorView.startNodeCreation(nodeType, mouse)
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

            // Node Canvas Area
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                // Drop Area for new nodes
                DropArea {
                    id: canvasDropArea
                    anchors.fill: parent
                    keys: ["node/new"]

                    onDropped: (drop) => {
                        if (drop.keys.indexOf("node/new") !== -1) {
                            var canvasPos = nodeCanvas.mapFromItem(null, drop.x, drop.y)
                            var graphPos = nodeCanvas.screenToGraphPosition(canvasPos.x, canvasPos.y)
                            nodeEditorView.finishNodeCreation(graphPos)
                        }
                    }

                    onPositionChanged: (drag) => {
                        if (nodeEditorView.isCreatingNode && nodeEditorView.nodePreview) {
                            var canvasPos = nodeCanvas.mapFromItem(null, drag.x, drag.y)
                            nodeEditorView.nodePreview.x = canvasPos.x - nodeEditorView.nodePreview.width / 2
                            nodeEditorView.nodePreview.y = canvasPos.y - nodeEditorView.nodePreview.height / 2
                        }
                    }

                    onEntered: {
                        if (nodeEditorView.isCreatingNode) {
                            nodeEditorView.nodePreview.opacity = 0.8
                        }
                    }

                    onExited: {
                        if (nodeEditorView.isCreatingNode) {
                            nodeEditorView.nodePreview.opacity = 0.4
                        }
                    }
                }

                NodeCanvas {
                    id: nodeCanvas
                    anchors.fill: parent
                    theme: appTheme

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
                        canvasContextMenu.clickPos = nodeCanvas.screenToGraphPosition(mouseX, mouseY)
                        canvasContextMenu.open(mouseX, mouseY)
                    }

                    onCanvasDoubleClicked: (mouseX, mouseY) => {
                        var graphPos = nodeCanvas.screenToGraphPosition(mouseX, mouseY)
                        console.log("Canvas double clicked at:", graphPos)
                        // می‌توانید ایجاد نود سریع را اینجا اضافه کنید
                    }

                    onViewChanged: {
                        backgroundCanvas.requestPaint()
                    }
                }

                // Node Preview during drag
                Loader {
                    id: nodePreviewLoader
                    active: nodeEditorView.isCreatingNode
                }

                // Execution Overlay
                Rectangle {
                    id: executionOverlay
                    anchors.fill: parent
                    color: "#80000000"
                    visible: nodeEditorView.isExecuting
                    z: 1000

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 20

                        BusyIndicator {
                            id: executionSpinner
                            running: nodeEditorView.isExecuting
                            width: 60
                            height: 60
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Executing BCI Pipeline..."
                            color: "white"
                            font.family: "Segoe UI"
                            font.pixelSize: 16
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }

                        ProgressBar {
                            id: progressBar
                            width: 300
                            value: nodeEditorView.executionProgress
                            Layout.alignment: Qt.AlignHCenter

                            background: Rectangle {
                                color: "#e0e0e0"
                                radius: 3
                            }

                            contentItem: Rectangle {
                                color: appTheme.primary
                                radius: 3
                            }
                        }

                        Button {
                            text: "Stop Execution"
                            Layout.alignment: Qt.AlignHCenter
                            onClicked: nodeEditorView.stopExecution()

                            background: Rectangle {
                                color: appTheme.error
                                radius: 6
                            }

                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.family: "Segoe UI"
                                font.pixelSize: 12
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
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

            TabBar {
                id: propertiesTabBar
                width: parent.width
                height: 50
                background: Rectangle {
                    color: appTheme.backgroundSecondary
                }

                TabButton {
                    text: "⚙️ Properties"
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    background: Rectangle {
                        color: parent.checked ? appTheme.primary : "transparent"
                        radius: 6
                    }
                    contentItem: Text {
                        text: parent.text
                        color: parent.checked ? "white" : appTheme.textPrimary
                        font: parent.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                TabButton {
                    text: "💡 Node Info"
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    background: Rectangle {
                        color: parent.checked ? appTheme.primary : "transparent"
                        radius: 6
                    }
                    contentItem: Text {
                        text: parent.text
                        color: parent.checked ? "white" : appTheme.textPrimary
                        font: parent.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                TabButton {
                    text: "📊 Pipeline"
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    background: Rectangle {
                        color: parent.checked ? appTheme.primary : "transparent"
                        radius: 6
                    }
                    contentItem: Text {
                        text: parent.text
                        color: parent.checked ? "white" : appTheme.textPrimary
                        font: parent.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            StackLayout {
                anchors.top: propertiesTabBar.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                currentIndex: propertiesTabBar.currentIndex

                // پنل Properties
                NodePropertiesPanel {
                    id: propertiesPanel
                    selectedNode: nodeEditorView.selectedNode
                    nodeGraph: nodeEditorView.currentNodeGraph
                    theme: appTheme

                    onPropertyChanged: (nodeId, propertyName, value) => {
                        if (nodeGraphManager && nodeGraphManager.updateNodeProperty) {
                            nodeGraphManager.updateNodeProperty(nodeId, propertyName, value)
                            nodeEditorView.graphModified()
                        }
                    }

                    onNodeDeleted: (nodeId) => {
                        nodeEditorView.deleteNode(nodeId)
                    }

                    onNodeDuplicated: (nodeId) => {
                        nodeEditorView.cloneNode(nodeId)
                    }

                    onNodeDisabled: (nodeId) => {
                        nodeEditorView.disableNode(nodeId)
                    }

                    onNodeEnabled: (nodeId) => {
                        nodeEditorView.enableNode(nodeId)
                    }
                }

                // پنل اطلاعات نود
                Rectangle {
                    color: appTheme.backgroundSecondary

                    ScrollView {
                        anchors.fill: parent
                        clip: true

                        ColumnLayout {
                            width: parent.width
                            spacing: 16
                            anchors.margins: 16

                            Text {
                                text: "Node Information"
                                color: appTheme.textPrimary
                                font.family: "Segoe UI Semibold"
                                font.pixelSize: 18
                                Layout.alignment: Qt.AlignHCenter
                                Layout.topMargin: 20
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 1
                                color: appTheme.border
                            }

                            ColumnLayout {
                                spacing: 12
                                Layout.fillWidth: true

                                InfoItem {
                                    label: "Node Type"
                                    value: nodeEditorView.selectedNode ? nodeEditorView.selectedNode.type : "N/A"
                                    icon: "🔧"
                                }

                                InfoItem {
                                    label: "Category"
                                    value: nodeEditorView.selectedNode ? nodeEditorView.selectedNode.category : "N/A"
                                    icon: "📁"
                                }

                                InfoItem {
                                    label: "Node ID"
                                    value: nodeEditorView.selectedNode ? nodeEditorView.selectedNode.nodeId : "N/A"
                                    icon: "🆔"
                                }

                                InfoItem {
                                    label: "Status"
                                    value: nodeEditorView.selectedNode ?
                                          (nodeEditorView.selectedNode.enabled === false ? "Disabled" : "Enabled") : "N/A"
                                    color: nodeEditorView.selectedNode && nodeEditorView.selectedNode.enabled === false ?
                                          appTheme.error : appTheme.success
                                    icon: nodeEditorView.selectedNode && nodeEditorView.selectedNode.enabled === false ?
                                          "❌" : "✅"
                                }

                                Text {
                                    text: "Documentation"
                                    color: appTheme.textPrimary
                                    font.family: "Segoe UI Semibold"
                                    font.pixelSize: 14
                                    Layout.topMargin: 10
                                }

                                Text {
                                    text: nodeEditorView.selectedNode ?
                                         (nodeEditorView.selectedNode.documentation || "No documentation available.") :
                                         "Select a node to view documentation."
                                    color: appTheme.textSecondary
                                    font.family: "Segoe UI"
                                    font.pixelSize: 12
                                    wrapMode: Text.WordWrap
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }
                }

                // پنل اطلاعات پایپ‌لاین
                Rectangle {
                    color: appTheme.backgroundSecondary

                    PipelineInfoPanel {
                        anchors.fill: parent
                        nodeGraph: nodeEditorView.currentNodeGraph
                        theme: appTheme
                        isValid: pipelineValidator ? pipelineValidator.isValid : false
                        isExecutable: pipelineValidator ? pipelineValidator.isExecutable : false
                        pipelineStatus: nodeEditorView.isExecuting ? "Executing" : "Ready"
                        executionTime: 0

                        onPipelineValidationRequested: nodeEditorView.pipelineValidationRequested()
                        onPipelineAnalysisRequested: nodeEditorView.pipelineAnalysisRequested()
                        onPipelineOptimizationRequested: nodeEditorView.pipelineOptimizationRequested()
                        onPipelineExportRequested: nodeEditorView.pipelineExportRequested()
                    }
                }
            }

            // Collapse/Expand Button for Right Sidebar
            Rectangle {
                width: 20
                height: 60
                color: appTheme.primary
                radius: 4
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: -10
                z: 1

                Text {
                    text: rightSidebarCollapsed ? "◀" : "▶"
                    color: "white"
                    font.pixelSize: 12
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        nodeEditorView.rightSidebarCollapsed = !nodeEditorView.rightSidebarCollapsed
                    }
                }
            }

            Behavior on Layout.preferredWidth {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }
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
            nodeEditorView.createNodeAt(nodeType, canvasContextMenu.clickPos)
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

    // Custom Message Dialog
    Popup {
        id: errorDialog
        width: 400
        height: 200
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        anchors.centerIn: Overlay.overlay

        background: Rectangle {
            color: appTheme.backgroundCard
            radius: 12
            border.color: appTheme.error
            border.width: 2
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            RowLayout {
                spacing: 12
                Layout.fillWidth: true

                Rectangle {
                    width: 40
                    height: 40
                    radius: 20
                    color: appTheme.error

                    Text {
                        text: "❌"
                        font.pixelSize: 20
                        anchors.centerIn: parent
                    }
                }

                Text {
                    text: "Pipeline Error"
                    color: appTheme.textPrimary
                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    Layout.fillWidth: true
                }
            }

            Text {
                id: errorMessage
                text: "An error occurred"
                color: appTheme.textSecondary
                font.family: "Segoe UI"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Button {
                text: "OK"
                Layout.alignment: Qt.AlignRight
                onClicked: errorDialog.close()

                background: Rectangle {
                    color: appTheme.primary
                    radius: 6
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        function showError(message) {
            errorMessage.text = message
            open()
        }
    }

    // کامپوننت‌های کمکی
    component InfoItem: RowLayout {
        property string label: ""
        property string value: ""
        property string icon: ""
        property color color: appTheme.textPrimary

        spacing: 10
        Layout.fillWidth: true

        Text {
            text: parent.icon
            font.pixelSize: 14
            color: parent.color
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true

            Text {
                text: parent.parent.label
                color: appTheme.textSecondary
                font.family: "Segoe UI"
                font.pixelSize: 11
            }

            Text {
                text: parent.parent.value
                color: parent.parent.color
                font.family: "Segoe UI"
                font.pixelSize: 12
                font.bold: true
                elide: Text.ElideRight
            }
        }
    }

    // Functions
    function startNodeCreation(nodeType, mouse) {
        nodeEditorView.isCreatingNode = true
        nodeEditorView.draggingNodeType = nodeType

        // ایجاد پیش‌نمایش نود
        nodeEditorView.nodePreview = nodePreviewComponent.createObject(nodeCanvas, {
            nodeType: nodeType,
            x: mouse.x - 60,
            y: mouse.y - 30
        })
    }

    function finishNodeCreation(position) {
        if (nodeEditorView.isCreatingNode && nodeEditorView.draggingNodeType) {
            var node = nodeEditorView.createNodeAt(nodeEditorView.draggingNodeType, position)
            if (node) {
                nodeEditorView.nodeCreated(node)
                nodeEditorView.selectedNode = node
                nodeEditorView.selectedNodes = [node]
                nodeEditorView.graphModified()
            }
        }
        nodeEditorView.cleanupNodeCreation()
    }

    function cleanupNodeCreation() {
        nodeEditorView.isCreatingNode = false
        nodeEditorView.draggingNodeType = ""
        if (nodeEditorView.nodePreview) {
            nodeEditorView.nodePreview.destroy()
            nodeEditorView.nodePreview = null
        }
    }

    function createNodeAt(nodeType, position) {
        if (nodeGraphManager && nodeGraphManager.createNode) {
            var node = nodeGraphManager.createNode(nodeType, position)
            if (node) {
                nodeEditorView.nodeCreated(node)
                nodeEditorView.selectedNode = node
                nodeEditorView.selectedNodes = [node]
                nodeEditorView.graphModified()
                return node
            }
        } else {
            // Fallback برای زمانی که nodeGraphManager موجود نیست
            var nodeData = {
                nodeId: "node_" + Math.random().toString(36).substr(2, 9),
                type: nodeType,
                name: getNodeName(nodeType),
                position: position,
                category: getNodeCategory(nodeType),
                icon: getNodeIcon(nodeType),
                parameters: getDefaultParameters(nodeType),
                ports: getDefaultPorts(nodeType)
            }
            return nodeData
        }
        return null
    }

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
        return names[nodeType] || nodeType
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
        return categories[nodeType] || "Utilities"
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
        return icons[nodeType] || "⚙️"
    }

    function getDefaultParameters(nodeType) {
        // پارامترهای پیش‌فرض برای انواع نودها
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
        return parameters[nodeType] || {}
    }

    function getDefaultPorts(nodeType) {
        // پورت‌های پیش‌فرض برای انواع نودها
        var ports = {
            "eeg_input": [
                {name: "eeg_output", direction: "output", dataType: "EEGSignal"}
            ],
            "bandpass_filter": [
                {name: "signal_input", direction: "input", dataType: "EEGSignal"},
                {name: "filtered_output", direction: "output", dataType: "EEGSignal"}
            ],
            "p300_speller": [
                {name: "eeg_input", direction: "input", dataType: "EEGSignal"},
                {name: "classification", direction: "output", dataType: "ClassificationResult"}
            ]
        }
        return ports[nodeType] || []
    }

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

        // بررسی اتصالات پایپ‌لاین
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
            // پیاده‌سازی کپی نودها
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
        // پیاده‌سازی پیست نودها
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

    // کامپوننت پیش‌نمایش نود
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

            Row {
                anchors.centerIn: parent
                spacing: 8

                Text {
                    text: getNodeIcon(nodeType)
                    font.pixelSize: 16
                    color: "white"
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: getNodeName(nodeType)
                    color: "white"
                    font.family: "Segoe UI"
                    font.pixelSize: 11
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            function getNodeIcon(type) {
                return nodeEditorView.getNodeIcon(type)
            }

            function getNodeName(type) {
                return nodeEditorView.getNodeName(type)
            }
        }
    }

    // Initialization
    Component.onCompleted: {
        console.log("Node Editor initialized")

        // Initialize node registry
        if (nodeRegistry && nodeRegistry.loadBCINodeLibrary) {
            nodeRegistry.loadBCINodeLibrary()
        }

        // Load default graph or create new one
        if (!nodeEditorView.currentNodeGraph) {
            nodeEditorView.createNewGraph()
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
        onActivated: nodeEditorView.stopExecution()
    }
}
