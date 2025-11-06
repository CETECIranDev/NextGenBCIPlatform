import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Shapes 1.15
import Qt5Compat.GraphicalEffects

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
    property var connectionStartPort: null
    property var connectionStartNode: null
    property var theme
    property var connectionToDelete: null

    // Selection rectangle
    property var selectionStart: Qt.point(0, 0)
    property var selectionEnd: Qt.point(0, 0)
    property bool isSelecting: false

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
    signal connectionHovered(var connection, bool hovered)

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
            ctx.globalAlpha = 0.3

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
            ctx.globalAlpha = 0.15

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

    // Selection Rectangle
    Rectangle {
        id: selectionRect
        visible: isSelecting
        color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)
        border.color: theme.primary
        border.width: 1
        z: 10

        x: Math.min(selectionStart.x, selectionEnd.x)
        y: Math.min(selectionStart.y, selectionEnd.y)
        width: Math.abs(selectionEnd.x - selectionStart.x)
        height: Math.abs(selectionEnd.y - selectionStart.y)
    }

    // لایه اتصالات - باید زیر نودها باشد
    Repeater {
        id: connectionRepeater
        model: nodeGraph ? nodeGraph.connections : []
        z: 1

        delegate: ConnectionItem {
            id: connectionDelegate
            connectionData: modelData
            canvas: nodeCanvas
            theme: nodeCanvas.theme
            z: 1

            onConnectionClicked: (connection) => {
                console.log("🔗 Connection clicked:", connection.connectionId)
                // می‌توانید برای انتخاب اتصال استفاده کنید
            }

            onConnectionDoubleClicked: (connection) => {
                console.log("🔗 Connection double clicked - delete:", connection.connectionId)
                nodeCanvas.connectionDeleted(connection.connectionId)
            }

            onConnectionHovered: (connection, hovered) => {
                nodeCanvas.connectionHovered(connection, hovered)
            }
        }
    }

    // اتصال موقت هنگام درگ
    Shape {
        id: tempConnectionShape
        visible: isCreatingConnection && tempConnection
        z: 2

        ShapePath {
            id: tempConnectionPath
            strokeWidth: 3
            strokeColor: getTempConnectionColor()
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: tempConnection ? tempConnection.startX : 0
            startY: tempConnection ? tempConnection.startY : 0

            PathCubic {
                id: tempConnectionCurve
                x: tempConnection ? tempConnection.endX : 0
                y: tempConnection ? tempConnection.endY : 0
                control1X: tempConnection ? tempConnection.control1X : 0
                control1Y: tempConnection ? tempConnection.control1Y : 0
                control2X: tempConnection ? tempConnection.control2X : 0
                control2Y: tempConnection ? tempConnection.control2Y : 0
            }
        }

        // Arrow head for temp connection
        Canvas {
            id: tempConnectionArrow
            width: 20
            height: 20
            x: tempConnection ? tempConnection.endX - 10 : 0
            y: tempConnection ? tempConnection.endY - 10 : 0
            z: 3

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                if (tempConnection) {
                    ctx.fillStyle = getTempConnectionColor()
                    ctx.strokeStyle = getTempConnectionColor()
                    ctx.lineWidth = 2

                    ctx.beginPath()
                    ctx.moveTo(10, 0)
                    ctx.lineTo(20, 10)
                    ctx.lineTo(10, 20)
                    ctx.lineTo(5, 10)
                    ctx.closePath()
                    ctx.fill()
                    ctx.stroke()
                }
            }
        }
    }

    // لایه نودها - باید بالای اتصالات باشد
    Repeater {
        id: nodeRepeater
        model: nodeGraph ? nodeGraph.nodes : []
        z: 3

        delegate: NodeItem {
            id: nodeDelegate
            nodeModel: modelData
            x: modelData.position.x * nodeCanvas.zoomLevel + nodeCanvas.viewOffset.x
            y: modelData.position.y * nodeCanvas.zoomLevel + nodeCanvas.viewOffset.y
            scale: nodeCanvas.zoomLevel
            transformOrigin: Item.TopLeft
            z: (isSelected || isDragging) ? 1000 : 3
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
                console.log("🔗 Connection started from port:", port.name, "on node:", modelData.nodeId)

                nodeCanvas.connectionStartPort = port
                nodeCanvas.connectionStartNode = modelData
                nodeCanvas.isCreatingConnection = true

                // شروع اتصال موقت
                var portPos = nodeDelegate.getPortGlobalPosition(port.portId, port.direction === "input")
                nodeCanvas.startTempConnection(portPos, Qt.point(mouse.x, mouse.y))
            }

            onConnectionFinished: (port) => {
                console.log("🔗 Connection finished to port:", port.name, "on node:", modelData.nodeId)

                if (nodeCanvas.isCreatingConnection &&
                    nodeCanvas.connectionStartPort &&
                    nodeCanvas.connectionStartNode &&
                    nodeCanvas.connectionStartNode.nodeId !== modelData.nodeId) {

                    // بررسی سازگاری پورت‌ها
                    var isValid = nodeCanvas.validateConnection(nodeCanvas.connectionStartPort, port)
                    var connectionData = {
                        connectionId: "conn_" + Math.random().toString(36).substr(2, 9),
                        sourceNodeId: nodeCanvas.connectionStartNode.nodeId,
                        sourcePortId: nodeCanvas.connectionStartPort.portId,
                        targetNodeId: modelData.nodeId,
                        targetPortId: port.portId,
                        isValid: isValid
                    }

                    if (isValid) {
                        console.log("✅ Creating valid connection:", connectionData)
                        nodeCanvas.connectionCreated(connectionData)
                    } else {
                        console.log("❌ Invalid connection - port types don't match")
                        // نمایش خطای اتصال
                        nodeCanvas.showConnectionError(connectionData)
                    }
                }

                nodeCanvas.cleanupTempConnection()
            }

            onDoubleClicked: {
                console.log("🖱️ Node double clicked:", modelData.nodeId)
                nodeCanvas.nodeDoubleClicked(modelData)
            }

            onContextMenuRequested: (mouse) => {
                nodeCanvas.selectedNodes = [modelData]
                nodeCanvas.selectedNode = modelData
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
        z: 4

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
                console.log("📐 Creating node at exact graph position:", graphPos.x, graphPos.y)

                if (typeof nodeEditorView !== 'undefined' && nodeEditorView.createNodeAtPosition) {
                    nodeEditorView.createNodeAtPosition(drop.getDataAsString("node/type"), graphPos)
                }
            }
        }
    }

    // Connection Error Indicator
    Rectangle {
        id: connectionErrorIndicator
        visible: false
        width: errorText.contentWidth + 20
        height: errorText.contentHeight + 10
        color: theme.error
        radius: 5
        z: 1000

        property point position: Qt.point(0, 0)

        x: position.x - width / 2
        y: position.y - height - 10

        Text {
            id: errorText
            text: "Invalid Connection!"
            color: "white"
            font.pixelSize: 10
            font.bold: true
            anchors.centerIn: parent
        }

        // Arrow pointing to error location
        Canvas {
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            width: 10
            height: 5

            onPaint: {
                var ctx = getContext("2d")
                ctx.fillStyle = theme.error
                ctx.beginPath()
                ctx.moveTo(0, 0)
                ctx.lineTo(5, 5)
                ctx.lineTo(10, 0)
                ctx.closePath()
                ctx.fill()
            }
        }
    }

    // MouseArea برای کنترل کانواس و اتصالات
    MouseArea {
        id: canvasMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        hoverEnabled: true
        z: 5

        property point lastMousePos
        property bool isPanning: false
        property bool isSpacePressed: false

        onPressed: (mouse) => {
            lastMousePos = Qt.point(mouse.x, mouse.y)
            forceActiveFocus()

            if (mouse.button === Qt.RightButton || (mouse.button === Qt.LeftButton && isSpacePressed)) {
                isPanning = true
                cursorShape = Qt.ClosedHandCursor
            } else if (mouse.button === Qt.MiddleButton) {
                nodeCanvas.canvasRightClicked(mouse.x, mouse.y)
            } else if (mouse.button === Qt.LeftButton) {
                // اگر روی فضای خالی کلیک شده، انتخاب‌ها را پاک کن
                if (!isNodeItem(mouse.target) && !isPortItem(mouse.target) && !isConnectionItem(mouse.target)) {
                    nodeCanvas.selectedNodes = []
                    nodeCanvas.selectedNode = null
                    nodeCanvas.nodeDeselected()

                    // شروع انتخاب با مستطیل
                    if (mouse.modifiers & Qt.ShiftModifier) {
                        isSelecting = true
                        selectionStart = Qt.point(mouse.x, mouse.y)
                        selectionEnd = Qt.point(mouse.x, mouse.y)
                    }
                }

                // اگر در حال ایجاد اتصال هستیم و روی فضای خالی کلیک شد، اتصال را لغو کن
                if (nodeCanvas.isCreatingConnection) {
                    nodeCanvas.cleanupTempConnection()
                }
            }
        }

        onPositionChanged: (mouse) => {
            if ((pressedButtons & Qt.RightButton && isPanning) ||
                (pressedButtons & Qt.LeftButton && isSpacePressed)) {
                // Panning با راست کلیک یا Space + چپ کلیک
                var delta = Qt.point(mouse.x - lastMousePos.x, mouse.y - lastMousePos.y)
                nodeCanvas.viewOffset.x += delta.x
                nodeCanvas.viewOffset.y += delta.y
                lastMousePos = Qt.point(mouse.x, mouse.y)
                gridCanvas.requestPaint()
                nodeCanvas.viewChanged()
            } else if (nodeCanvas.isCreatingConnection && nodeCanvas.tempConnection) {
                // آپدیت اتصال موقت
                nodeCanvas.updateTempConnection(Qt.point(mouse.x, mouse.y))
            } else if (isSelecting) {
                // آپدیت مستطیل انتخاب
                selectionEnd = Qt.point(mouse.x, mouse.y)
                updateSelection()
            }
        }

        onReleased: (mouse) => {
            isPanning = false
            cursorShape = Qt.ArrowCursor

            // پایان انتخاب با مستطیل
            if (isSelecting) {
                isSelecting = false
                finalizeSelection()
            }

            // اگر اتصال موقت فعال است و رها شده، آن را پاک کن
            if (nodeCanvas.isCreatingConnection) {
                nodeCanvas.cleanupTempConnection()
            }
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
            nodeCanvas.viewChanged()
        }

        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton && !isNodeItem(mouse.target) && !isPortItem(mouse.target) && !isConnectionItem(mouse.target)) {
                nodeCanvas.canvasRightClicked(mouse.x, mouse.y)
            }
        }

        onDoubleClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton && !isNodeItem(mouse.target) && !isPortItem(mouse.target) && !isConnectionItem(mouse.target)) {
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

        function isPortItem(item) {
            while (item && item !== nodeCanvas) {
                if (item.hasOwnProperty("isPortItem")) {
                    return true
                }
                item = item.parent
            }
            return false
        }

        function isConnectionItem(item) {
            while (item && item !== nodeCanvas) {
                if (item.hasOwnProperty("isConnectionItem")) {
                    return true
                }
                item = item.parent
            }
            return false
        }
    }

    // Keyboard Handler for Space panning
    Item {
        focus: true
        Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Space) {
                canvasMouseArea.isSpacePressed = true
                canvasMouseArea.cursorShape = Qt.ClosedHandCursor
                event.accepted = true
            }
        }

        Keys.onReleased: (event) => {
            if (event.key === Qt.Key_Space) {
                canvasMouseArea.isSpacePressed = false
                canvasMouseArea.cursorShape = Qt.ArrowCursor
                event.accepted = true
            }
        }
    }

    // توابع مدیریت اتصالات
    function startTempConnection(startPos, mousePos) {
        tempConnection = {
            startX: startPos.x,
            startY: startPos.y,
            endX: mousePos.x,
            endY: mousePos.y,
            control1X: startPos.x + Math.max(100, Math.abs(mousePos.x - startPos.x) * 0.5),
            control1Y: startPos.y,
            control2X: mousePos.x - Math.max(100, Math.abs(mousePos.x - startPos.x) * 0.5),
            control2Y: mousePos.y
        }
        updateTempConnectionPath()
    }

    function updateTempConnection(mousePos) {
        if (tempConnection) {
            tempConnection.endX = mousePos.x
            tempConnection.endY = mousePos.y
            tempConnection.control2X = mousePos.x - Math.max(100, Math.abs(mousePos.x - tempConnection.startX) * 0.5)
            tempConnection.control2Y = mousePos.y
            updateTempConnectionPath()
            tempConnectionArrow.requestPaint()
        }
    }

    function updateTempConnectionPath() {
        if (tempConnection) {
            tempConnectionPath.startX = tempConnection.startX
            tempConnectionPath.startY = tempConnection.startY
            tempConnectionCurve.x = tempConnection.endX
            tempConnectionCurve.y = tempConnection.endY
            tempConnectionCurve.control1X = tempConnection.control1X
            tempConnectionCurve.control1Y = tempConnection.control1Y
            tempConnectionCurve.control2X = tempConnection.control2X
            tempConnectionCurve.control2Y = tempConnection.control2Y
        }
    }

    function cleanupTempConnection() {
        tempConnection = null
        isCreatingConnection = false
        connectionStartPort = null
        connectionStartNode = null
    }

    function getTempConnectionColor() {
        return theme.accent
    }

    function showConnectionError(connectionData) {
        // نمایش خطای اتصال به صورت موقت
        var startPos = getPortPosition(connectionData.sourceNodeId, connectionData.sourcePortId, false)
        var endPos = getPortPosition(connectionData.targetNodeId, connectionData.targetPortId, true)

        if (startPos && endPos) {
            var errorPos = Qt.point(
                (startPos.x + endPos.x) / 2,
                (startPos.y + endPos.y) / 2
            )

            connectionErrorIndicator.position = errorPos
            connectionErrorIndicator.visible = true

            // پنهان کردن خطا بعد از 2 ثانیه
            errorTimer.start()
        }
    }

    Timer {
        id: errorTimer
        interval: 2000
        onTriggered: {
            connectionErrorIndicator.visible = false
        }
    }

    function validateConnection(sourcePort, targetPort) {
        if (!sourcePort || !targetPort) {
            console.log("❌ Connection failed: Missing ports")
            return false
        }

        // پورت خروجی باید به پورت ورودی متصل شود
        if (sourcePort.direction === targetPort.direction) {
            console.log("❌ Connection failed: Same port direction", sourcePort.direction, targetPort.direction)
            return false
        }

        // بررسی نوع داده
        if (sourcePort.dataType !== targetPort.dataType) {
            console.log("❌ Connection failed: Data type mismatch", sourcePort.dataType, "vs", targetPort.dataType)
            return false
        }

        // بررسی اینکه پورت قبلاً متصل نشده باشد
        if (isPortConnected(sourcePort) || isPortConnected(targetPort)) {
            console.log("❌ Connection failed: Port already connected")
            return false
        }

        // اتصال معتبر
        console.log("✅ Connection valid:", sourcePort.dataType, "to", targetPort.dataType)
        return true
    }

    function isPortConnected(port) {
        if (!nodeGraph || !nodeGraph.connections) return false

        for (var i = 0; i < nodeGraph.connections.length; i++) {
            var conn = nodeGraph.connections[i]
            if ((conn.sourcePortId === port.portId && conn.sourceNodeId === port.nodeId) ||
                (conn.targetPortId === port.portId && conn.targetNodeId === port.nodeId)) {
                return true
            }
        }
        return false
    }

    // توابع انتخاب با مستطیل
    function updateSelection() {
        // این تابع می‌تواند برای highlight کردن نودهای داخل مستطیل استفاده شود
    }

    function finalizeSelection() {
        var selectedNodes = []
        var selectionRect = Qt.rect(
            Math.min(selectionStart.x, selectionEnd.x),
            Math.min(selectionStart.y, selectionEnd.y),
            Math.abs(selectionEnd.x - selectionStart.x),
            Math.abs(selectionEnd.y - selectionStart.y)
        )

        for (var i = 0; i < nodeRepeater.count; i++) {
            var nodeItem = nodeRepeater.itemAt(i)
            if (nodeItem && isItemInSelection(nodeItem, selectionRect)) {
                selectedNodes.push(nodeItem.nodeModel)
            }
        }

        if (selectedNodes.length > 0) {
            nodeCanvas.selectedNodes = selectedNodes
            nodeCanvas.selectedNode = selectedNodes.length === 1 ? selectedNodes[0] : null
            nodeCanvas.nodesSelected(selectedNodes)
        }
    }

    function isItemInSelection(item, selectionRect) {
        var itemRect = Qt.rect(item.x, item.y, item.width * item.scale, item.height * item.scale)
        return itemRect.intersects(selectionRect)
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

    function getPortPosition(nodeId, portId, isInput) {
        for (var i = 0; i < nodeRepeater.count; i++) {
            var nodeItem = nodeRepeater.itemAt(i)
            if (nodeItem && nodeItem.nodeModel && nodeItem.nodeModel.nodeId === nodeId) {
                return nodeItem.getPortGlobalPosition(portId, isInput)
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
        gridCanvas.requestPaint()
        nodeCanvas.viewChanged()
    }

    function fitToView() {
        if (!nodeGraph || !nodeGraph.nodes || nodeGraph.nodes.length === 0) return

        var minX = Number.MAX_VALUE, minY = Number.MAX_VALUE
        var maxX = Number.MIN_VALUE, maxY = Number.MIN_VALUE

        for (var i = 0; i < nodeGraph.nodes.length; i++) {
            var node = nodeGraph.nodes[i]
            minX = Math.min(minX, node.position.x)
            minY = Math.min(minY, node.position.y)
            maxX = Math.max(maxX, node.position.x + 200) // assuming node width
            maxY = Math.max(maxY, node.position.y + 100) // assuming node height
        }

        var padding = 80
        var graphWidth = Math.max(maxX - minX + padding * 2, 400)
        var graphHeight = Math.max(maxY - minY + padding * 2, 300)

        var scaleX = (nodeCanvas.width - padding * 2) / graphWidth
        var scaleY = (nodeCanvas.height - padding * 2) / graphHeight
        nodeCanvas.zoomLevel = Math.min(scaleX, scaleY, maxZoom)

        nodeCanvas.viewOffset.x = padding - minX * nodeCanvas.zoomLevel
        nodeCanvas.viewOffset.y = padding - minY * nodeCanvas.zoomLevel

        gridCanvas.requestPaint()
        nodeCanvas.viewChanged()
    }

    function autoLayout() {
        console.log("🔄 Auto layout started")

        if (!nodeGraph || !nodeGraph.nodes || nodeGraph.nodes.length === 0) {
            console.log("❌ No nodes to layout")
            return
        }

        // Layout ساده: قرار دادن نودها در یک شبکه
        var nodes = nodeGraph.nodes
        var cols = Math.ceil(Math.sqrt(nodes.length))
        var spacing = 250

        for (var i = 0; i < nodes.length; i++) {
            var row = Math.floor(i / cols)
            var col = i % cols

            var newPos = Qt.point(
                col * spacing + 100,
                row * spacing + 100
            )

            // آپدیت موقعیت نود
            if (nodeGraphManager && nodeGraphManager.updateNodePosition) {
                nodeGraphManager.updateNodePosition(nodes[i].nodeId, newPos)
            }
        }

        console.log("✅ Auto layout completed")
        gridCanvas.requestPaint()
    }

    function selectAllNodes() {
        if (nodeGraph && nodeGraph.nodes) {
            nodeCanvas.selectedNodes = nodeGraph.nodes.slice()
            nodeCanvas.selectedNode = nodeGraph.nodes.length === 1 ? nodeGraph.nodes[0] : null
            nodeCanvas.nodesSelected(nodeCanvas.selectedNodes)
            console.log("🔘 Selected all nodes:", nodeCanvas.selectedNodes.length)
        }
    }

    function deselectAllNodes() {
        nodeCanvas.selectedNodes = []
        nodeCanvas.selectedNode = null
        nodeCanvas.nodeDeselected()
        console.log("🔘 Deselected all nodes")
    }

    function adjustViewOffsetAfterZoom(oldZoom) {
        var centerX = nodeCanvas.width / 2
        var centerY = nodeCanvas.height / 2

        var worldX = (centerX - nodeCanvas.viewOffset.x) / oldZoom
        var worldY = (centerY - nodeCanvas.viewOffset.y) / oldZoom

        nodeCanvas.viewOffset.x = centerX - worldX * nodeCanvas.zoomLevel
        nodeCanvas.viewOffset.y = centerY - worldY * nodeCanvas.zoomLevel

        gridCanvas.requestPaint()
        nodeCanvas.viewChanged()
    }

    // تابع برای گرفتن bounding box تمام نودها
    function getNodesBoundingBox() {
        if (!nodeGraph || !nodeGraph.nodes || nodeGraph.nodes.length === 0) {
            return Qt.rect(0, 0, 0, 0)
        }

        var minX = Number.MAX_VALUE, minY = Number.MAX_VALUE
        var maxX = Number.MIN_VALUE, maxY = Number.MIN_VALUE

        for (var i = 0; i < nodeGraph.nodes.length; i++) {
            var node = nodeGraph.nodes[i]
            minX = Math.min(minX, node.position.x)
            minY = Math.min(minY, node.position.y)
            maxX = Math.max(maxX, node.position.x + 200)
            maxY = Math.max(maxY, node.position.y + 100)
        }

        return Qt.rect(minX, minY, maxX - minX, maxY - minY)
    }

    // تابع برای center کردن روی نود خاص
    function centerOnNode(nodeId) {
        var node = getNodeById(nodeId)
        if (node) {
            var centerX = nodeCanvas.width / 2
            var centerY = nodeCanvas.height / 2

            nodeCanvas.viewOffset.x = centerX - node.position.x * nodeCanvas.zoomLevel
            nodeCanvas.viewOffset.y = centerY - node.position.y * nodeCanvas.zoomLevel

            gridCanvas.requestPaint()
            nodeCanvas.viewChanged()
        }
    }

    // تابع برای center کردن روی تمام نودها
    function centerOnAllNodes() {
        var bbox = getNodesBoundingBox()
        if (bbox.width > 0 && bbox.height > 0) {
            var centerX = nodeCanvas.width / 2
            var centerY = nodeCanvas.height / 2

            nodeCanvas.viewOffset.x = centerX - (bbox.x + bbox.width / 2) * nodeCanvas.zoomLevel
            nodeCanvas.viewOffset.y = centerY - (bbox.y + bbox.height / 2) * nodeCanvas.zoomLevel

            gridCanvas.requestPaint()
            nodeCanvas.viewChanged()
        }
    }

    Component.onCompleted: {
        console.log("🎨 NodeCanvas initialized with advanced features")
        console.log("📐 Zoom level:", zoomLevel)
        console.log("📍 View offset:", viewOffset.x, viewOffset.y)
        gridCanvas.requestPaint()
    }

    onNodeGraphChanged: {
        console.log("🔄 NodeGraph changed")
        gridCanvas.requestPaint()
    }

    onZoomLevelChanged: {
        console.log("🔍 Zoom level changed to:", zoomLevel)
        gridCanvas.requestPaint()
    }
}
