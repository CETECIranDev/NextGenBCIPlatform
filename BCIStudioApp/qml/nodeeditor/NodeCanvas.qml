import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: nodeCanvas
    color: theme.backgroundPrimary
    clip: true

    property var nodeGraph: null
    property var selectedNode: null
    property var selectedNodes: []
    property bool isDraggingNode: false
    property var draggingNodeData: null

    property real zoomLevel: 1.0
    property point viewOffset: Qt.point(0, 0)
    property real minZoom: 0.1
    property real maxZoom: 3.0

    property var tempConnection: null
    property bool isCreatingConnection: false

    property var theme: ({
        "backgroundPrimary": "#FFFFFF",
        "backgroundSecondary": "#F8F9FA",
        "backgroundTertiary": "#E9ECEF",
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
        "border": "#DEE2E6"
    })

    // سیگنال‌ها
    signal nodeSelected(var node)
    signal nodesSelected(var nodes)
    signal nodeDeselected()
    signal nodeMoved(string nodeId, point position)
    signal nodeDoubleClicked(var node)
    signal connectionCreated(var connectionData)
    signal connectionDeleted(string connectionId)
    signal nodesDeleted(var nodeIds)
    signal canvasRightClicked(real mouseX, real mouseY)
    signal canvasDoubleClicked(real mouseX, real mouseY)
    signal viewChanged()
    signal screenToGraphPositionCalculated(real screenX, real screenY, point graphPos)

    // شبکه زمینه
    Canvas {
        id: gridCanvas
        anchors.fill: parent
        z: 0

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            // تنظیمات شبکه
            var gridSize = 20 * nodeCanvas.zoomLevel
            var majorGridSize = 100 * nodeCanvas.zoomLevel

            var startX = -nodeCanvas.viewOffset.x % gridSize
            var startY = -nodeCanvas.viewOffset.y % gridSize

            // خطوط اصلی (تیره‌تر)
            ctx.strokeStyle = theme.border
            ctx.lineWidth = 1
            ctx.globalAlpha = 0.4

            for (var x = startX; x < width; x += majorGridSize) {
                ctx.beginPath()
                ctx.moveTo(x, 0)
                ctx.lineTo(x, height)
                ctx.stroke()
            }

            for (var y = startY; y < height; y += majorGridSize) {
                ctx.beginPath()
                ctx.moveTo(0, y)
                ctx.lineTo(width, y)
                ctx.stroke()
            }

            // خطوط فرعی (روشن‌تر)
            ctx.globalAlpha = 0.2

            for (var x2 = startX; x2 < width; x2 += gridSize) {
                if (x2 % majorGridSize !== 0) {
                    ctx.beginPath()
                    ctx.moveTo(x2, 0)
                    ctx.lineTo(x2, height)
                    ctx.stroke()
                }
            }

            for (var y2 = startY; y2 < height; y2 += gridSize) {
                if (y2 % majorGridSize !== 0) {
                    ctx.beginPath()
                    ctx.moveTo(0, y2)
                    ctx.lineTo(width, y2)
                    ctx.stroke()
                }
            }
        }
    }

    // لایه اتصالات
    Canvas {
        id: connectionLayer
        anchors.fill: parent
        z: 1

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            // رسم تمام اتصالات موجود
            if (nodeGraph && nodeGraph.connections) {
                for (var i = 0; i < nodeGraph.connections.length; i++) {
                    var connection = nodeGraph.connections[i]
                    drawConnection(ctx, connection)
                }
            }

            // رسم اتصال موقت
            if (tempConnection && tempConnection.active) {
                drawTempConnection(ctx)
            }

            // رسم selection rectangle
            if (selectionRect.visible) {
                drawSelectionRect(ctx)
            }
        }

        function drawConnection(ctx, connection) {
            var sourceNode = getNodeById(connection.sourceNodeId)
            var targetNode = getNodeById(connection.targetNodeId)

            if (!sourceNode || !targetNode) return

            var sourcePos = getPortPosition(sourceNode, connection.sourcePortId, true)
            var targetPos = getPortPosition(targetNode, connection.targetPortId, false)

            if (!sourcePos || !targetPos) return

            var isSelected = selectedNodes.some(function(node) {
                return node.nodeId === connection.sourceNodeId || node.nodeId === connection.targetNodeId
            })

            drawBezierCurve(ctx, sourcePos, targetPos,
                          isSelected ? theme.accent : theme.primary,
                          isSelected ? 3 : 2,
                          false)
        }

        function drawTempConnection(ctx) {
            var sourcePos = getPortPosition(tempConnection.sourceNode, tempConnection.sourcePortId, true)
            if (!sourcePos) return

            var endPos = Qt.point(tempConnection.mouseX, tempConnection.mouseY)
            drawBezierCurve(ctx, sourcePos, endPos, theme.accent, 2, true)
        }

        function drawSelectionRect(ctx) {
            ctx.strokeStyle = theme.primary
            ctx.lineWidth = 1
            ctx.setLineDash([5, 5])
            ctx.strokeRect(selectionRect.x, selectionRect.y,
                          selectionRect.width, selectionRect.height)
            ctx.setLineDash([])

            ctx.fillStyle = Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)
            ctx.fillRect(selectionRect.x, selectionRect.y,
                        selectionRect.width, selectionRect.height)
        }

        function drawBezierCurve(ctx, start, end, color, lineWidth, isDashed) {
            ctx.strokeStyle = color
            ctx.lineWidth = lineWidth
            ctx.globalAlpha = isDashed ? 0.6 : 1.0

            if (isDashed) {
                ctx.setLineDash([5, 5])
            } else {
                ctx.setLineDash([])
            }

            // محاسبه نقاط کنترل برای منحنی بزیه
            var curveOffset = Math.min(Math.abs(end.x - start.x) * 0.5, 100 * zoomLevel)
            var cp1 = Qt.point(start.x + curveOffset, start.y)
            var cp2 = Qt.point(end.x - curveOffset, end.y)

            ctx.beginPath()
            ctx.moveTo(start.x, start.y)
            ctx.bezierCurveTo(cp1.x, cp1.y, cp2.x, cp2.y, end.x, end.y)
            ctx.stroke()

            // بازگردانی تنظیمات
            ctx.setLineDash([])
            ctx.globalAlpha = 1.0
        }

        function getPortPosition(node, portId, isOutput) {
            // پیدا کردن آیتم نود مربوطه
            for (var i = 0; i < nodeRepeater.count; i++) {
                var nodeItem = nodeRepeater.itemAt(i)
                if (nodeItem && nodeItem.nodeModel && nodeItem.nodeModel.nodeId === node.nodeId) {
                    return nodeItem.getPortPosition(portId, isOutput)
                }
            }
            return null
        }
    }

    // نمایش نودها
    Repeater {
        id: nodeRepeater
        model: nodeGraph ? nodeGraph.nodes : []

        delegate: NodeItem {
            id: nodeDelegate
            nodeModel: modelData
            x: (modelData.position.x + nodeCanvas.viewOffset.x) * nodeCanvas.zoomLevel
            y: (modelData.position.y + nodeCanvas.viewOffset.y) * nodeCanvas.zoomLevel
            scale: nodeCanvas.zoomLevel
            transformOrigin: Item.TopLeft
            z: modelData.zIndex || 0
            theme: nodeCanvas.theme

            isSelected: nodeCanvas.selectedNodes.some(function(selectedNode) {
                return selectedNode && selectedNode.nodeId === modelData.nodeId
            })

            onSelected: (multiple) => {
                if (!multiple) {
                    nodeCanvas.selectedNodes = [modelData]
                    nodeCanvas.selectedNode = modelData
                    nodeCanvas.nodeSelected(modelData)
                } else {
                    var newSelection = nodeCanvas.selectedNodes.slice()
                    if (!newSelection.some(function(node) { return node.nodeId === modelData.nodeId })) {
                        newSelection.push(modelData)
                        nodeCanvas.selectedNodes = newSelection
                        nodeCanvas.nodesSelected(newSelection)
                    }
                }
            }

            onDeselected: () => {
                var newSelection = nodeCanvas.selectedNodes.filter(function(node) {
                    return node.nodeId !== modelData.nodeId
                })
                nodeCanvas.selectedNodes = newSelection
                nodeCanvas.selectedNode = newSelection.length === 1 ? newSelection[0] : null

                if (newSelection.length === 0) {
                    nodeCanvas.nodeDeselected()
                } else {
                    nodeCanvas.nodesSelected(newSelection)
                }
            }

            onMoved: (newPos) => {
                var canvasPos = Qt.point(
                    (newPos.x - nodeCanvas.viewOffset.x) / nodeCanvas.zoomLevel,
                    (newPos.y - nodeCanvas.viewOffset.y) / nodeCanvas.zoomLevel
                )
                nodeCanvas.nodeMoved(modelData.nodeId, canvasPos)
            }

            onConnectionStarted: (port, mouse) => {
                nodeCanvas.tempConnection = {
                    sourceNode: modelData,
                    sourcePortId: port.portId,
                    mouseX: mouse.x,
                    mouseY: mouse.y,
                    active: true
                }
                nodeCanvas.isCreatingConnection = true
                connectionLayer.requestPaint()
            }

            onConnectionFinished: (port) => {
                if (nodeCanvas.tempConnection && nodeCanvas.tempConnection.active &&
                    nodeCanvas.tempConnection.sourceNode.nodeId !== modelData.nodeId) {

                    var connectionData = {
                        sourceNodeId: nodeCanvas.tempConnection.sourceNode.nodeId,
                        sourcePortId: nodeCanvas.tempConnection.sourcePortId,
                        targetNodeId: modelData.nodeId,
                        targetPortId: port.portId
                    }

                    nodeCanvas.connectionCreated(connectionData)
                }

                nodeCanvas.tempConnection = null
                nodeCanvas.isCreatingConnection = false
                connectionLayer.requestPaint()
            }

            onDoubleClicked: nodeCanvas.nodeDoubleClicked(modelData)

            onContextMenuRequested: (mouse) => {
                nodeCanvas.selectedNodes = [modelData]
                nodeCanvas.selectedNode = modelData
                nodeContextMenu.node = modelData
                nodeContextMenu.open(mouse)
            }
        }
    }

    // Selection rectangle
    Rectangle {
        id: selectionRect
        visible: false
        color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)
        border.color: theme.primary
        border.width: 1
        z: 2
    }

    // Drop area برای نودهای جدید
    DropArea {
        id: nodeDropArea
        anchors.fill: parent
        keys: ["node/new"]

        onDropped: (drop) => {
            if (drop.keys.indexOf("node/new") !== -1) {
                var canvasPos = calculateScreenToGraphPosition(drop.x, drop.y)
                nodeEditorView.finishNodeCreation(canvasPos)
            }
        }

        onPositionChanged: (drag) => {
            if (nodeCanvas.tempConnection && nodeCanvas.tempConnection.active) {
                nodeCanvas.tempConnection.mouseX = drag.x
                nodeCanvas.tempConnection.mouseY = drag.y
                connectionLayer.requestPaint()
            }
        }
    }

    // کنترل‌های ماوس
    MouseArea {
        id: canvasMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        hoverEnabled: true

        property point lastMousePos
        property bool isPanning: false
        property point selectionStart
        property bool isSelecting: false

        onPressed: (mouse) => {
            lastMousePos = Qt.point(mouse.x, mouse.y)
            forceActiveFocus()

            if (mouse.button === Qt.RightButton) {
                isPanning = true
                cursorShape = Qt.ClosedHandCursor
            } else if (mouse.button === Qt.MiddleButton) {
                nodeCanvas.canvasRightClicked(mouse.x, mouse.y)
            } else if (mouse.button === Qt.LeftButton) {
                if (!nodeCanvas.isCreatingConnection) {
                    // شروع selection
                    selectionStart = Qt.point(mouse.x, mouse.y)
                    selectionRect.x = mouse.x
                    selectionRect.y = mouse.y
                    selectionRect.width = 0
                    selectionRect.height = 0
                    selectionRect.visible = true
                    isSelecting = true
                }
            }
        }

        onPositionChanged: (mouse) => {
            if (pressedButtons & Qt.RightButton && isPanning) {
                // Pan کردن کانواس
                var delta = Qt.point(mouse.x - lastMousePos.x, mouse.y - lastMousePos.y)
                nodeCanvas.viewOffset.x += delta.x / nodeCanvas.zoomLevel
                nodeCanvas.viewOffset.y += delta.y / nodeCanvas.zoomLevel
                lastMousePos = Qt.point(mouse.x, mouse.y)
                gridCanvas.requestPaint()
                connectionLayer.requestPaint()
                nodeCanvas.viewChanged()
            } else if (pressedButtons & Qt.LeftButton && isSelecting) {
                // به روز رسانی selection rectangle
                selectionRect.width = mouse.x - selectionStart.x
                selectionRect.height = mouse.y - selectionStart.y

                // اطمینان از مثبت بودن ابعاد
                if (selectionRect.width < 0) {
                    selectionRect.x = mouse.x
                    selectionRect.width = -selectionRect.width
                }
                if (selectionRect.height < 0) {
                    selectionRect.y = mouse.y
                    selectionRect.height = -selectionRect.height
                }

                connectionLayer.requestPaint()
            } else if (nodeCanvas.tempConnection && nodeCanvas.tempConnection.active) {
                // به روز رسانی اتصال موقت
                nodeCanvas.tempConnection.mouseX = mouse.x
                nodeCanvas.tempConnection.mouseY = mouse.y
                connectionLayer.requestPaint()
            }
        }

        onReleased: (mouse) => {
            isPanning = false
            cursorShape = Qt.ArrowCursor

            if (isSelecting) {
                selectNodesInRect(selectionRect)
                selectionRect.visible = false
                isSelecting = false
                connectionLayer.requestPaint()
            }
        }

        onWheel: (wheel) => {
            var zoomFactor = wheel.angleDelta.y > 0 ? 1.1 : 0.9
            var oldZoom = nodeCanvas.zoomLevel
            nodeCanvas.zoomLevel = Math.min(Math.max(nodeCanvas.zoomLevel * zoomFactor, minZoom), maxZoom)

            // zoom towards mouse position
            var mousePos = Qt.point(wheel.x, wheel.y)
            var worldPos = calculateScreenToGraphPosition(mousePos.x, mousePos.y)

            nodeCanvas.viewOffset.x = mousePos.x - worldPos.x * nodeCanvas.zoomLevel
            nodeCanvas.viewOffset.y = mousePos.y - worldPos.y * nodeCanvas.zoomLevel

            gridCanvas.requestPaint()
            connectionLayer.requestPaint()
            nodeCanvas.viewChanged()
        }

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                // اگر روی فضای خالی کلیک شده
                if (!isNodeItem(mouse.target)) {
                    nodeCanvas.selectedNodes = []
                    nodeCanvas.selectedNode = null
                    nodeCanvas.nodeDeselected()
                }
            } else if (mouse.button === Qt.RightButton) {
                if (!isNodeItem(mouse.target)) {
                    nodeCanvas.canvasRightClicked(mouse.x, mouse.y)
                }
            }
        }

        onDoubleClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton && !isNodeItem(mouse.target)) {
                nodeCanvas.canvasDoubleClicked(mouse.x, mouse.y)
            }
        }

        function isNodeItem(item) {
            while (item && item !== nodeCanvas) {
                if (item.hasOwnProperty("isNodeItem")) {
                    return true
                }
                item = item.parent
            }
            return false
        }
    }

    // منوی زمینه برای نودها
    NodeContextMenu {
        id: nodeContextMenu
        theme: nodeCanvas.theme

        onDeleteNode: {
            if (node) {
                nodeCanvas.nodesDeleted([node.nodeId])
            }
        }
        onCloneNode: {
            if (node) {
                nodeEditorView.cloneNode(node.nodeId)
            }
        }
    }

    // توابع عمومی
    function selectNodesInRect(rect) {
        var selected = []
        for (var i = 0; i < nodeRepeater.count; i++) {
            var nodeItem = nodeRepeater.itemAt(i)
            if (nodeItem && isNodeInRect(nodeItem, rect)) {
                selected.push(nodeItem.nodeModel)
            }
        }
        nodeCanvas.selectedNodes = selected
        if (selected.length === 1) {
            nodeCanvas.selectedNode = selected[0]
            nodeCanvas.nodeSelected(selected[0])
        } else if (selected.length > 1) {
            nodeCanvas.selectedNode = null
            nodeCanvas.nodesSelected(selected)
        }
    }

    function isNodeInRect(nodeItem, rect) {
        var nodeCenter = Qt.point(
            nodeItem.x + nodeItem.width / 2,
            nodeItem.y + nodeItem.height / 2
        )
        return rect.contains(nodeCenter)
    }

    function selectAllNodes() {
        var allNodes = []
        for (var i = 0; i < nodeRepeater.count; i++) {
            var nodeItem = nodeRepeater.itemAt(i)
            if (nodeItem && nodeItem.nodeModel) {
                allNodes.push(nodeItem.nodeModel)
            }
        }
        nodeCanvas.selectedNodes = allNodes
        nodeCanvas.nodesSelected(allNodes)
    }

    function deselectAllNodes() {
        nodeCanvas.selectedNodes = []
        nodeCanvas.selectedNode = null
        nodeCanvas.nodeDeselected()
    }

    function getMousePosition() {
        return calculateScreenToGraphPosition(canvasMouseArea.mouseX, canvasMouseArea.mouseY)
    }

    function calculateScreenToGraphPosition(screenX, screenY) {
        var graphPos = Qt.point(
            (screenX - nodeCanvas.viewOffset.x) / nodeCanvas.zoomLevel,
            (screenY - nodeCanvas.viewOffset.y) / nodeCanvas.zoomLevel
        )
        screenToGraphPositionCalculated(screenX, screenY, graphPos)
        return graphPos
    }

    function zoomIn() {
        var oldZoom = nodeCanvas.zoomLevel
        nodeCanvas.zoomLevel = Math.min(nodeCanvas.zoomLevel * 1.2, maxZoom)
        adjustViewOffsetAfterZoom(oldZoom)
    }

    function zoomOut() {
        var oldZoom = nodeCanvas.zoomLevel
        nodeCanvas.zoomLevel = Math.max(nodeCanvas.zoomLevel * 0.8, minZoom)
        adjustViewOffsetAfterZoom(oldZoom)
    }

    function zoomReset() {
        var oldZoom = nodeCanvas.zoomLevel
        nodeCanvas.zoomLevel = 1.0
        nodeCanvas.viewOffset = Qt.point(0, 0)
        connectionLayer.requestPaint()
        gridCanvas.requestPaint()
        nodeCanvas.viewChanged()
    }

    function fitToView() {
        if (nodeRepeater.count === 0) return

        var minX = Infinity, minY = Infinity, maxX = -Infinity, maxY = -Infinity

        for (var i = 0; i < nodeRepeater.count; i++) {
            var nodeItem = nodeRepeater.itemAt(i)
            if (nodeItem) {
                minX = Math.min(minX, nodeItem.x)
                minY = Math.min(minY, nodeItem.y)
                maxX = Math.max(maxX, nodeItem.x + nodeItem.width)
                maxY = Math.max(maxY, nodeItem.y + nodeItem.height)
            }
        }

        var padding = 100
        var contentWidth = maxX - minX + padding * 2
        var contentHeight = maxY - minY + padding * 2

        var scaleX = (nodeCanvas.width - padding * 2) / contentWidth
        var scaleY = (nodeCanvas.height - padding * 2) / contentHeight
        nodeCanvas.zoomLevel = Math.min(scaleX, scaleY, maxZoom)

        nodeCanvas.viewOffset.x = -minX * nodeCanvas.zoomLevel + padding
        nodeCanvas.viewOffset.y = -minY * nodeCanvas.zoomLevel + padding

        connectionLayer.requestPaint()
        gridCanvas.requestPaint()
        nodeCanvas.viewChanged()
    }

    function centerOnNode(node) {
        if (!node) return

        var nodeCenterX = (node.position.x + 100) * nodeCanvas.zoomLevel + nodeCanvas.viewOffset.x
        var nodeCenterY = (node.position.y + 50) * nodeCanvas.zoomLevel + nodeCanvas.viewOffset.y

        nodeCanvas.viewOffset.x += nodeCanvas.width/2 - nodeCenterX
        nodeCanvas.viewOffset.y += nodeCanvas.height/2 - nodeCenterY

        connectionLayer.requestPaint()
        gridCanvas.requestPaint()
        nodeCanvas.viewChanged()
    }

    function adjustViewOffsetAfterZoom(oldZoom) {
        var centerX = nodeCanvas.width / 2
        var centerY = nodeCanvas.height / 2

        var worldX = (centerX - nodeCanvas.viewOffset.x) / oldZoom
        var worldY = (centerY - nodeCanvas.viewOffset.y) / oldZoom

        nodeCanvas.viewOffset.x = centerX - worldX * nodeCanvas.zoomLevel
        nodeCanvas.viewOffset.y = centerY - worldY * nodeCanvas.zoomLevel

        connectionLayer.requestPaint()
        gridCanvas.requestPaint()
        nodeCanvas.viewChanged()
    }

    function autoLayout() {
        if (nodeGraph && typeof nodeGraph.autoLayout === 'function') {
            nodeGraph.autoLayout()
            // Force repaint after layout
            Qt.callLater(function() {
                connectionLayer.requestPaint()
                gridCanvas.requestPaint()
            })
        } else {
            console.log("Auto layout not available")
        }
    }

    function clearCanvas() {
        nodeCanvas.selectedNodes = []
        nodeCanvas.selectedNode = null
        nodeCanvas.tempConnection = null
        nodeCanvas.isCreatingConnection = false
    }

    function getNodeById(nodeId) {
        if (!nodeGraph || !nodeGraph.nodes) return null
        for (var i = 0; i < nodeGraph.nodes.length; i++) {
            if (nodeGraph.nodes[i].nodeId === nodeId) {
                return nodeGraph.nodes[i]
            }
        }
        return null
    }

    function getConnectionCount(node) {
        if (!node || !nodeGraph || !nodeGraph.connections) return 0
        var count = 0
        for (var i = 0; i < nodeGraph.connections.length; i++) {
            var connection = nodeGraph.connections[i]
            if (connection.sourceNodeId === node.nodeId || connection.targetNodeId === node.nodeId) {
                count++
            }
        }
        return count
    }

    Component.onCompleted: {
        gridCanvas.requestPaint()
        connectionLayer.requestPaint()
        console.log("NodeCanvas initialized")
    }

    onNodeGraphChanged: {
        clearCanvas()
        gridCanvas.requestPaint()
        connectionLayer.requestPaint()
    }
}
