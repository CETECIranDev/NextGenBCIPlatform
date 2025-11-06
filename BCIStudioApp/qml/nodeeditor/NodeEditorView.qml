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
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.strokeStyle = Qt.rgba(1, 1, 1, 0.02)
                ctx.lineWidth = 1

                // Draw subtle grid pattern
                for (var x = 0; x < width; x += 20) {
                    ctx.beginPath()
                    ctx.moveTo(x, 0)
                    ctx.lineTo(x, height)
                    ctx.stroke()
                }
                for (var y = 0; y < height; y += 20) {
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

            onNodeDragStarted: (nodeType, mouse) => {
                nodeEditorView.startNodeDrag(nodeType, mouse)
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

                NodeCanvas {
                    id: nodeCanvas
                    anchors.fill: parent

                    nodeGraph: nodeEditorView.currentNodeGraph
                    selectedNode: nodeEditorView.selectedNode
                    selectedNodes: nodeEditorView.selectedNodes
                    isDraggingNode: nodeEditorView.isDraggingNode
                    draggingNodeData: nodeEditorView.draggingNodeData

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
                        nodeGraphManager.updateNodePosition(nodeId, position)
                        nodeEditorView.graphModified()
                    }

                    onNodeDoubleClicked: (node) => {
                        nodeEditorView.editNodeProperties(node)
                    }

                    onConnectionCreated: (connectionData) => {
                        nodeGraphManager.createConnection(connectionData)
                        nodeEditorView.connectionCreated(connectionData)
                        nodeEditorView.graphModified()
                    }

                    onConnectionDeleted: (connectionId) => {
                        nodeGraphManager.removeConnection(connectionId)
                        nodeEditorView.connectionDeleted(connectionId)
                        nodeEditorView.graphModified()
                    }

                    onNodesDeleted: (nodeIds) => {
                        nodeEditorView.deleteNodes(nodeIds)
                    }

                    onCanvasRightClicked: (mouseX, mouseY) => {
                        canvasContextMenu.open(mouseX, mouseY)
                    }

                    onCanvasDoubleClicked: (mouseX, mouseY) => {
                        console.log("Canvas double clicked at:", mouseX, mouseY)
                    }
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

                // Drop Area for new nodes
                DropArea {
                    anchors.fill: parent
                    keys: ["node/new"]

                    onDropped: (drop) => {
                        if (drop.keys.indexOf("node/new") !== -1) {
                            var canvasPos = nodeCanvas.getMousePosition()
                            nodeEditorView.finishNodeDrag(canvasPos)
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
                }
                TabButton {
                    text: "💡 Node Info"
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    background: Rectangle {
                        color: parent.checked ? appTheme.primary : "transparent"
                        radius: 6
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

                    onPropertyChanged: (nodeId, propertyName, value) => {
                        nodeGraphManager.updateNodeProperty(nodeId, propertyName, value)
                        nodeEditorView.graphModified()
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

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        Text {
                            text: "Node Information Panel"
                            color: appTheme.textPrimary
                            font.family: "Segoe UI Semibold"
                            font.pixelSize: 16
                            Layout.alignment: Qt.AlignHCenter
                            Layout.topMargin: 20
                        }

                        Text {
                            text: "Detailed node information and documentation will appear here"
                            color: appTheme.textTertiary
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                    }
                }

                // پنل اطلاعات پایپ‌لاین
                Rectangle {
                    color: appTheme.backgroundSecondary

                    PipelineInfoPanel {
                        anchors.fill: parent
                        nodeGraph: nodeEditorView.currentNodeGraph
                        isValid: pipelineValidator ? pipelineValidator.isValid : false
                        isExecutable: pipelineValidator ? pipelineValidator.isExecutable : false
                        pipelineStatus: "Ready"
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

        onPasteNodes: nodeEditorView.pasteNodes()
        onSelectAll: nodeCanvas.selectAllNodes()
        onDeselectAll: nodeCanvas.deselectAllNodes()
        onCreateNode: (nodeType) => {
            nodeEditorView.createNodeAt(nodeType, canvasContextMenu.clickPos)
        }
        onImportGraph: fileDialog.open()
        onExportGraph: saveDialog.open()
    }

    // Dialogs
    FileDialog {
        id: fileDialog
        title: "Open BCI Pipeline"
        nameFilters: ["BCI Pipeline Files (*.bpi)", "JSON Files (*.json)", "All Files (*)"]
        onAccepted: nodeEditorView.loadGraph(fileDialog.fileUrl)
    }

    FileDialog {
        id: saveDialog
        title: "Save BCI Pipeline"
        nameFilters: ["BCI Pipeline Files (*.bpi)", "JSON Files (*.json)", "All Files (*)"]
        //selectExisting: false
        onAccepted: nodeEditorView.saveGraph(saveDialog.fileUrl)
    }

    // Custom Message Dialog
    Popup {
        id: errorDialog
        width: 400
        height: 200
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

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

    // Functions
    function startNodeDrag(nodeType, mouse) {
        nodeEditorView.isDraggingNode = true
        nodeEditorView.draggingNodeData = {
            type: nodeType,
            startX: mouse.x,
            startY: mouse.y
        }
    }

    function finishNodeDrag(position) {
        if (nodeEditorView.isDraggingNode && nodeEditorView.draggingNodeData) {
            var node = nodeGraphManager.createNode(
                nodeEditorView.draggingNodeData.type,
                position
            )
            if (node) {
                nodeEditorView.nodeCreated(node)
                nodeEditorView.selectedNode = node
                nodeEditorView.selectedNodes = [node]
                nodeEditorView.graphModified()
            }
        }
        nodeEditorView.isDraggingNode = false
        nodeEditorView.draggingNodeData = null
    }

    function createNodeAt(nodeType, position) {
        var node = nodeGraphManager.createNode(nodeType, position)
        if (node) {
            nodeEditorView.nodeCreated(node)
            nodeEditorView.selectedNode = node
            nodeEditorView.selectedNodes = [node]
            nodeEditorView.graphModified()
            return node
        }
        return null
    }

    function deleteNode(nodeId) {
        nodeGraphManager.removeNode(nodeId)
        nodeEditorView.nodeDeleted(nodeId)
        if (nodeEditorView.selectedNode && nodeEditorView.selectedNode.nodeId === nodeId) {
            nodeEditorView.selectedNode = null
            nodeEditorView.selectedNodes = []
        }
        nodeEditorView.graphModified()
    }

    function deleteNodes(nodeIds) {
        nodeIds.forEach(function(nodeId) {
            nodeGraphManager.removeNode(nodeId)
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
        var originalNode = nodeGraphManager.getNode(nodeId)
        if (originalNode) {
            var newPos = Qt.point(originalNode.position.x + 50, originalNode.position.y + 50)
            var clonedNode = nodeGraphManager.cloneNode(nodeId, newPos)
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
        nodeGraphManager.createNewGraph()
        nodeEditorView.selectedNode = null
        nodeEditorView.selectedNodes = []
        nodeEditorView.graphModified()
    }

    function clearGraph() {
        nodeGraphManager.clearGraph()
        nodeEditorView.selectedNode = null
        nodeEditorView.selectedNodes = []
        nodeEditorView.graphModified()
    }

    function executeGraph() {
        if (nodeEditorView.validatePipeline()) {
            nodeEditorView.isExecuting = true
            nodeEditorView.executionProgress = 0.0
            nodeEditorView.executionInitiated()

            // Simulate execution progress
            var progress = 0
            var progressTimer = Qt.createQmlObject('import QtQuick 2.15; Timer { interval: 100; running: true; repeat: true }', nodeEditorView)
            progressTimer.triggered.connect(function() {
                progress += 0.01
                nodeEditorView.executionProgress = progress
                if (progress >= 1.0) {
                    progressTimer.stop()
                    nodeEditorView.isExecuting = false
                    nodeEditorView.executionCompleted()
                }
            })
        }
    }

    function stopExecution() {
        nodeEditorView.isExecuting = false
        nodeEditorView.executionCompleted()
    }

    function validatePipeline() {
        if (!nodeEditorView.currentNodeGraph || nodeEditorView.currentNodeGraph.nodes.length === 0) {
            errorDialog.showError("Pipeline is empty")
            return false
        }
        return true
    }

    function saveGraph(filePath) {
        if (nodeGraphManager && nodeGraphManager.saveToFile) {
            nodeGraphManager.saveToFile(filePath)
        } else {
            errorDialog.showError("Save functionality not implemented")
        }
    }

    function loadGraph(filePath) {
        if (nodeGraphManager && nodeGraphManager.loadFromFile) {
            nodeGraphManager.loadFromFile(filePath)
            nodeEditorView.selectedNode = null
            nodeEditorView.selectedNodes = []
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
        height: 24
        color: appTheme.backgroundSecondary

        RowLayout {
            anchors.fill: parent
            anchors.margins: 4

            Text {
                text: "Nodes: " + (currentNodeGraph ? currentNodeGraph.nodes.length : 0) +
                      " | Connections: " + (currentNodeGraph ? currentNodeGraph.connections.length : 0) +
                      " | Selected: " + selectedNodes.length
                color: appTheme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 11
                Layout.fillWidth: true
            }

            Text {
                text: isExecuting ? "Executing..." : "Ready"
                color: isExecuting ? appTheme.warning : appTheme.success
                font.family: "Segoe UI"
                font.pixelSize: 11
                font.bold: true
            }
        }
    }
}
