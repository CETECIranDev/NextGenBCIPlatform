// در NodeCanvas.qml - این کد را جایگزین کنید
import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: nodeCanvas
    color: theme.backgroundPrimary
    clip: true

    property var nodeGraph: null
    property var selectedNode: null
    property var selectedNodes: []
    property real zoomLevel: 1.0
    property point viewOffset: Qt.point(0, 0)
    property real minZoom: 0.1
    property real maxZoom: 3.0
    property var tempConnection: null
    property bool isCreatingConnection: false
    property var theme

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

    // لایه شبکه
    Canvas {
        id: gridCanvas
        anchors.fill: parent
        z: 0

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var gridSize = 20 * nodeCanvas.zoomLevel
            var majorGridSize = 100 * nodeCanvas.zoomLevel

            var startX = -nodeCanvas.viewOffset.x % gridSize
            var startY = -nodeCanvas.viewOffset.y % gridSize

            // خطوط اصلی
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

            // خطوط فرعی
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

    // لایه اتصالات - باید زیر نودها باشد
    Canvas {
        id: connectionLayer
        anchors.fill: parent
        z: 1

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            // رسم اتصالات موجود
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
        }

        function drawConnection(ctx, connection) {
            var sourceNode = getNodeById(connection.sourceNodeId)
            var targetNode = getNodeById(connection.targetNodeId)

            if (!sourceNode || !targetNode) return

            var sourcePos = getPortPosition(sourceNode, connection.sourcePortId, false)
            var targetPos = getPortPosition(targetNode, connection.targetPortId, true)

            if (!sourcePos || !targetPos) return

            // بررسی اعتبار اتصال و انتخاب رنگ
            var isValid = true // اینجا باید منطق اعتبارسنجی واقعی را اضافه کنید
            var connectionColor = isValid ? theme.success : theme.error
            var lineWidth = isValid ? 3 : 2

            drawBezierCurve(ctx, sourcePos, targetPos, connectionColor, lineWidth, false)

            // اضافه کردن نقاط انتهایی
            drawPortCircle(ctx, sourcePos, connectionColor)
            drawPortCircle(ctx, targetPos, connectionColor)
        }

        function drawPortCircle(ctx, position, color) {
            ctx.fillStyle = color
            ctx.beginPath()
            ctx.arc(position.x, position.y, 4, 0, Math.PI * 2)
            ctx.fill()
        }

        function drawTempConnection(ctx) {
            var sourcePos = getPortPosition(tempConnection.sourceNode, tempConnection.sourcePortId, false)
            if (!sourcePos) return

            var endPos = Qt.point(tempConnection.mouseX, tempConnection.mouseY)
            drawBezierCurve(ctx, sourcePos, endPos, theme.accent, 2, true)
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

            var curveOffset = Math.min(Math.abs(end.x - start.x) * 0.5, 100 * zoomLevel)
            var cp1 = Qt.point(start.x + curveOffset, start.y)
            var cp2 = Qt.point(end.x - curveOffset, end.y)

            ctx.beginPath()
            ctx.moveTo(start.x, start.y)
            ctx.bezierCurveTo(cp1.x, cp1.y, cp2.x, cp2.y, end.x, end.y)
            ctx.stroke()

            ctx.setLineDash([])
            ctx.globalAlpha = 1.0
        }

        function getPortPosition(node, portId, isInput) {
            for (var i = 0; i < nodeRepeater.count; i++) {
                var nodeItem = nodeRepeater.itemAt(i)
                if (nodeItem && nodeItem.nodeModel && nodeItem.nodeModel.nodeId === node.nodeId) {
                    return nodeItem.getPortPosition(portId, isInput)
                }
            }
            return null
        }
    }

    // لایه نودها - باید بالای اتصالات باشد
    Repeater {
        id: nodeRepeater
        model: nodeGraph ? nodeGraph.nodes : []
        z: 2 // بالاتر از اتصالات

        delegate: NodeItem {
            id: nodeDelegate
            nodeModel: modelData
            // موقعیت‌یابی صحیح - استفاده از مختصات گراف
            x: modelData.position.x * nodeCanvas.zoomLevel + nodeCanvas.viewOffset.x
            y: modelData.position.y * nodeCanvas.zoomLevel + nodeCanvas.viewOffset.y
            scale: nodeCanvas.zoomLevel
            transformOrigin: Item.TopLeft
            z: (isSelected || isDragging) ? 1000 : 2 // نودهای انتخاب شده بالاتر
            theme: nodeCanvas.theme

            isSelected: nodeCanvas.selectedNodes.some(function(selectedNode) {
                return selectedNode && selectedNode.nodeId === modelData.nodeId
            })

            onSelected: (multiple) => {
                console.log("🔘 Node selected:", modelData.nodeId)
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
                console.log("🔘 Node deselected:", modelData.nodeId)
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
                // تبدیل به مختصات گراف
                var graphPos = Qt.point(
                    (newPos.x - nodeCanvas.viewOffset.x) / nodeCanvas.zoomLevel,
                    (newPos.y - nodeCanvas.viewOffset.y) / nodeCanvas.zoomLevel
                )
                console.log("📦 Node moved to graph position:", graphPos.x, graphPos.y)
                nodeCanvas.nodeMoved(modelData.nodeId, graphPos)
            }

            onConnectionStarted: (port, mouse) => {
                console.log("🔗 Connection started from port:", port.name)
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
                console.log("🔗 Connection finished to port:", port.name)
                if (nodeCanvas.tempConnection && nodeCanvas.tempConnection.active &&
                    nodeCanvas.tempConnection.sourceNode.nodeId !== modelData.nodeId) {

                    var connectionData = {
                        sourceNodeId: nodeCanvas.tempConnection.sourceNode.nodeId,
                        sourcePortId: nodeCanvas.tempConnection.sourcePortId,
                        targetNodeId: modelData.nodeId,
                        targetPortId: port.portId
                    }

                    console.log("✅ Creating connection:", connectionData)
                    nodeCanvas.connectionCreated(connectionData)
                }

                nodeCanvas.tempConnection = null
                nodeCanvas.isCreatingConnection = false
                connectionLayer.requestPaint()
            }

            onDoubleClicked: {
                console.log("🖱️ Node double clicked:", modelData.nodeId)
                nodeCanvas.nodeDoubleClicked(modelData)
            }

            onContextMenuRequested: (mouse) => {
                nodeCanvas.selectedNodes = [modelData]
                nodeCanvas.selectedNode = modelData
                // nodeContextMenu.node = modelData
                // nodeContextMenu.open(mouse)
                console.log("📋 Context menu requested for node:", modelData.nodeId)
            }
        }
    }

    // Drop Area برای نودهای جدید
    DropArea {
        id: nodeDropArea
        anchors.fill: parent
        keys: ["node/new"]
        enabled: true
        z: 3 // بالاترین لایه

        onEntered: (drag) => {
            console.log("📍 Drag entered NodeCanvas")
            if (drag.keys.indexOf("node/new") !== -1) {
                drag.accept()
                return true
            }
            return false
        }

        onDropped: (drop) => {
            console.log("🎯 Drop in NodeCanvas at:", drop.x, drop.y)
            if (drop.keys.indexOf("node/new") !== -1) {
                var graphPos = calculateScreenToGraphPosition(drop.x, drop.y)
                console.log("📐 Creating node at graph position:", graphPos.x, graphPos.y)

                if (typeof nodeEditorView !== 'undefined' && nodeEditorView.createNodeFromDrop) {
                    nodeEditorView.createNodeFromDrop(drop.getDataAsString("node/type"), graphPos)
                }
            }
        }
    }

    // MouseArea برای کنترل کانواس
    MouseArea {
        id: canvasMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        hoverEnabled: true
        z: 4 // بالاترین لایه برای رویدادهای ماوس

        property point lastMousePos
        property bool isPanning: false

        onPressed: (mouse) => {
            lastMousePos = Qt.point(mouse.x, mouse.y)
            forceActiveFocus()

            if (mouse.button === Qt.RightButton) {
                isPanning = true
                cursorShape = Qt.ClosedHandCursor
            } else if (mouse.button === Qt.MiddleButton) {
                nodeCanvas.canvasRightClicked(mouse.x, mouse.y)
            } else if (mouse.button === Qt.LeftButton) {
                // اگر روی فضای خالی کلیک شده، انتخاب‌ها را پاک کن
                if (!isNodeItem(mouse.target)) {
                    nodeCanvas.selectedNodes = []
                    nodeCanvas.selectedNode = null
                    nodeCanvas.nodeDeselected()
                }
            }
        }

        onPositionChanged: (mouse) => {
            if (pressedButtons & Qt.RightButton && isPanning) {
                var delta = Qt.point(mouse.x - lastMousePos.x, mouse.y - lastMousePos.y)
                nodeCanvas.viewOffset.x += delta.x / nodeCanvas.zoomLevel
                nodeCanvas.viewOffset.y += delta.y / nodeCanvas.zoomLevel
                lastMousePos = Qt.point(mouse.x, mouse.y)
                gridCanvas.requestPaint()
                connectionLayer.requestPaint()
                nodeCanvas.viewChanged()
            }
        }

        onReleased: (mouse) => {
            isPanning = false
            cursorShape = Qt.ArrowCursor
        }

        onWheel: (wheel) => {
            var zoomFactor = wheel.angleDelta.y > 0 ? 1.1 : 0.9
            var oldZoom = nodeCanvas.zoomLevel
            nodeCanvas.zoomLevel = Math.min(Math.max(nodeCanvas.zoomLevel * zoomFactor, minZoom), maxZoom)

            var mousePos = Qt.point(wheel.x, wheel.y)
            var worldPos = calculateScreenToGraphPosition(mousePos.x, mousePos.y)

            nodeCanvas.viewOffset.x = mousePos.x - worldPos.x * nodeCanvas.zoomLevel
            nodeCanvas.viewOffset.y = mousePos.y - worldPos.y * nodeCanvas.zoomLevel

            gridCanvas.requestPaint()
            connectionLayer.requestPaint()
            nodeCanvas.viewChanged()
        }

        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton && !isNodeItem(mouse.target)) {
                nodeCanvas.canvasRightClicked(mouse.x, mouse.y)
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

    function validateConnection(sourceNodeId, sourcePortId, targetNodeId, targetPortId) {
        var sourceNode = getNodeById(sourceNodeId)
        var targetNode = getNodeById(targetNodeId)

        if (!sourceNode || !targetNode) return false

        // بررسی اینکه نودها یکی نباشند
        if (sourceNodeId === targetNodeId) return false

        // بررسی نوع داده پورت‌ها (ساده‌شده)
        var sourcePort = getPortById(sourceNode, sourcePortId)
        var targetPort = getPortById(targetNode, targetPortId)

        if (!sourcePort || !targetPort) return false

        // پورت خروجی باید به پورت ورودی متصل شود
        if (sourcePort.direction === targetPort.direction) return false

        // بررسی نوع داده
        return sourcePort.dataType === targetPort.dataType
    }

    function getPortById(node, portId) {
        if (!node.ports) return null
        for (var i = 0; i < node.ports.length; i++) {
            if (node.ports[i].portId === portId) {
                return node.ports[i]
            }
        }
        return null
    }

    // توابع عمومی
    function calculateScreenToGraphPosition(screenX, screenY) {
        return Qt.point(
            (screenX - nodeCanvas.viewOffset.x) / nodeCanvas.zoomLevel,
            (screenY - nodeCanvas.viewOffset.y) / nodeCanvas.zoomLevel
        )
    }

    function screenToGraphPosition(screenX, screenY) {
        return calculateScreenToGraphPosition(screenX, screenY)
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
        nodeCanvas.zoomLevel = 1.0
        nodeCanvas.viewOffset = Qt.point(0, 0)
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

    Component.onCompleted: {
        console.log("🎨 NodeCanvas initialized")
        gridCanvas.requestPaint()
        connectionLayer.requestPaint()
    }

    onNodeGraphChanged: {
        console.log("🔄 NodeGraph changed")
        gridCanvas.requestPaint()
        connectionLayer.requestPaint()
    }
    Connections {
        target: nodeGraph
        onConnectionsChanged: connectionLayer.requestPaint()
    }
}
