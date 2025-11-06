import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Item {
    id: connectionItem

    property var connectionData: null
    property var canvas: null
    property var theme: null
    property bool isSelected: false
    property bool isHovered: false
    property bool isValid: connectionData ? connectionData.isValid : true
    property bool isTemp: false
    property bool isVisible: true  // تغییر نام به isVisible

    readonly property bool isConnectionItem: true

    signal connectionClicked(var connection)
    signal connectionDoubleClicked(var connection)
    signal connectionHovered(var connection, bool hovered)
    signal connectionDeleted(var connection)

    // محاسبه موقعیت‌ها
    property point startPoint: {
        if (!connectionData || !canvas) return Qt.point(0, 0)
        var pos = canvas.getPortPosition(connectionData.sourceNodeId, connectionData.sourcePortId, false)
        return pos ? pos : Qt.point(0, 0)
    }

    property point endPoint: {
        if (!connectionData || !canvas) return Qt.point(0, 0)
        var pos = canvas.getPortPosition(connectionData.targetNodeId, connectionData.targetPortId, true)
        return pos ? pos : Qt.point(0, 0)
    }

    // محاسبه نقاط کنترل برای منحنی Bézier
    property point controlPoint1: Qt.point(
        startPoint.x + Math.max(80, Math.abs(endPoint.x - startPoint.x) * 0.4),
        startPoint.y
    )

    property point controlPoint2: Qt.point(
        endPoint.x - Math.max(80, Math.abs(endPoint.x - startPoint.x) * 0.4),
        endPoint.y
    )

    // شکل اصلی اتصال
    Shape {
        id: mainShape
        anchors.fill: parent
        visible: connectionItem.isVisible && !isTemp

        ShapePath {
            id: connectionPath
            strokeWidth: getConnectionWidth()
            strokeColor: getConnectionColor()
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin

            startX: startPoint.x
            startY: startPoint.y

            PathCubic {
                x: endPoint.x
                y: endPoint.y
                control1X: controlPoint1.x
                control1Y: controlPoint1.y
                control2X: controlPoint2.x
                control2Y: controlPoint2.y
            }
        }
    }

    // سرپیکان
    Shape {
        id: arrowHead
        width: 16
        height: 16
        x: endPoint.x - 8
        y: endPoint.y - 8
        rotation: calculateArrowRotation()
        visible: connectionItem.isVisible && !isTemp

        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillColor: getConnectionColor()

            startX: 0; startY: 8
            PathLine { x: 16; y: 8 }
            PathLine { x: 8; y: 0 }
            PathLine { x: 0; y: 8 }
        }
    }

    // Highlight هنگام hover
    Rectangle {
        id: highlightOverlay
        x: Math.min(startPoint.x, endPoint.x, controlPoint1.x, controlPoint2.x) - 6
        y: Math.min(startPoint.y, endPoint.y, controlPoint1.y, controlPoint2.y) - 6
        width: Math.max(startPoint.x, endPoint.x, controlPoint1.x, controlPoint2.x) - x + 12
        height: Math.max(startPoint.y, endPoint.y, controlPoint1.y, controlPoint2.y) - y + 12
        color: "transparent"
        border.color: theme ? theme.primary : "#4361EE"
        border.width: 2
        radius: 10
        opacity: (isHovered || isSelected) ? 0.3 : 0
        visible: connectionItem.isVisible && (isHovered || isSelected) && !isTemp

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    // MouseArea برای تعامل
    MouseArea {
        id: connectionMouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
        propagateComposedEvents: true
        enabled: connectionItem.isVisible && !isTemp

        onContainsMouseChanged: {
            if (connectionItem.isVisible && !isTemp) {
                connectionItem.isHovered = containsMouse
                connectionItem.connectionHovered(connectionItem.connectionData, containsMouse)
            }
        }

        onClicked: (mouse) => {
            if (connectionItem.isVisible && !isTemp) {
                if (mouse.button === Qt.LeftButton) {
                    connectionItem.connectionClicked(connectionItem.connectionData)
                    mouse.accepted = true
                } else if (mouse.button === Qt.RightButton) {
                    connectionContextMenu.popup()
                    mouse.accepted = true
                }
            }
        }

        onDoubleClicked: {
            if (connectionItem.isVisible && !isTemp) {
                connectionItem.connectionDoubleClicked(connectionItem.connectionData)
            }
        }

        onPositionChanged: (mouse) => {
            if (containsMouse && connectionItem.isVisible && !isTemp) {
                var point = Qt.point(mouse.x, mouse.y)
                if (isPointNearCurve(point)) {
                    connectionItem.isHovered = true
                } else {
                    connectionItem.isHovered = false
                }
            }
        }
    }

    // منوی زمینه
    Menu {
        id: connectionContextMenu
        modal: true
        dim: false

        background: Rectangle {
            color: theme ? theme.backgroundCard : "#FFFFFF"
            border.color: theme ? theme.border : "#DEE2E6"
            border.width: 1
            radius: 8

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 2
                verticalOffset: 2
                radius: 8
                samples: 17
                color: "#20000000"
            }
        }

        MenuItem {
            text: "🔗 Connection Info"
            font.family: "Segoe UI"
            font.pixelSize: 12

            background: Rectangle {
                color: parent.highlighted ? (theme ? theme.backgroundTertiary : "#E9ECEF") : "transparent"
                radius: 4
            }

            onTriggered: {
                showConnectionInfo()
            }
        }

        MenuSeparator {
            contentItem: Rectangle {
                height: 1
                color: theme ? theme.border : "#DEE2E6"
            }
        }

        MenuItem {
            text: "🗑️ Delete Connection"
            font.family: "Segoe UI"
            font.pixelSize: 12
            enabled: !isTemp

            background: Rectangle {
                color: parent.highlighted ? (theme ? theme.error : "#EF476F") : "transparent"
                radius: 4
            }

            contentItem: Text {
                text: parent.text
                color: theme ? theme.error : "#EF476F"
                font: parent.font
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            onTriggered: {
                deleteConnection()
            }
        }
    }

    // Tooltip برای اطلاعات اتصال
    ToolTip {
        id: connectionTooltip
        delay: 500
        timeout: 3000
        visible: connectionMouseArea.containsMouse && connectionItem.isVisible && !isTemp

        background: Rectangle {
            color: theme ? theme.backgroundCard : "#FFFFFF"
            border.color: theme ? theme.border : "#DEE2E6"
            border.width: 1
            radius: 6

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 2
                verticalOffset: 2
                radius: 8
                samples: 17
                color: "#20000000"
            }
        }

        contentItem: ColumnLayout {
            spacing: 6

            Text {
                text: "🔗 Connection"
                color: theme ? theme.textPrimary : "#212529"
                font.family: "Segoe UI Semibold"
                font.pixelSize: 12
                font.weight: Font.DemiBold
            }

            Text {
                text: getConnectionInfo()
                color: theme ? theme.textSecondary : "#6C757D"
                font.family: "Segoe UI"
                font.pixelSize: 10
                wrapMode: Text.Wrap
            }

            Text {
                text: isValid ? "✅ Valid" : "❌ Invalid"
                color: isValid ? (theme ? theme.success : "#4CC9F0") : (theme ? theme.error : "#EF476F")
                font.family: "Segoe UI"
                font.pixelSize: 10
                font.weight: Font.Medium
            }
        }
    }

    // توابع کمکی
    function getConnectionColor() {
        if (!theme) return "#4361EE"
        if (isTemp) return theme.accent
        if (!isValid) return theme.error
        if (isSelected) return theme.primary
        if (isHovered) return Qt.darker(theme.primary, 1.1)
        return theme.primary
    }

    function getConnectionWidth() {
        if (isTemp) return 2
        if (isSelected) return 3
        if (isHovered) return 3
        return 2
    }

    function calculateArrowRotation() {
        var dx = endPoint.x - controlPoint2.x
        var dy = endPoint.y - controlPoint2.y
        return Math.atan2(dy, dx) * (180 / Math.PI)
    }

    function getPointOnCurve(t) {
        var x = Math.pow(1 - t, 3) * startPoint.x +
                3 * Math.pow(1 - t, 2) * t * controlPoint1.x +
                3 * (1 - t) * Math.pow(t, 2) * controlPoint2.x +
                Math.pow(t, 3) * endPoint.x

        var y = Math.pow(1 - t, 3) * startPoint.y +
                3 * Math.pow(1 - t, 2) * t * controlPoint1.y +
                3 * (1 - t) * Math.pow(t, 2) * controlPoint2.y +
                Math.pow(t, 3) * endPoint.y

        return Qt.point(x, y)
    }

    function isPointNearCurve(point) {
        var tolerance = isHovered ? 12 : 8

        for (var t = 0; t <= 1; t += 0.02) {
            var curvePoint = getPointOnCurve(t)
            var dx = point.x - curvePoint.x
            var dy = point.y - curvePoint.y
            var distance = Math.sqrt(dx * dx + dy * dy)

            if (distance <= tolerance) {
                return true
            }
        }
        return false
    }

    function getConnectionInfo() {
        if (!connectionData) return "Temporary Connection"

        var sourceNode = canvas ? canvas.getNodeById(connectionData.sourceNodeId) : null
        var targetNode = canvas ? canvas.getNodeById(connectionData.targetNodeId) : null

        var sourceName = sourceNode ? sourceNode.name : "Unknown"
        var targetName = targetNode ? targetNode.name : "Unknown"

        return sourceName + " → " + targetName
    }

    function showConnectionInfo() {
        if (connectionData) {
            console.log("🔗 Connection Info:", {
                id: connectionData.connectionId,
                source: connectionData.sourceNodeId,
                target: connectionData.targetNodeId,
                valid: connectionData.isValid
            })
        }
    }

    function deleteConnection() {
        if (connectionData && !isTemp) {
            console.log("🗑️ Deleting connection:", connectionData.connectionId)
            connectionItem.connectionDeleted(connectionData)
        }
    }

    // تابع برای آپدیت موقعیت‌ها
    function updatePosition() {
        // این تابع موقعیت‌ها را مجدداً محاسبه می‌کند
        startPoint = Qt.point(0, 0) // برای trigger کردن recompute
        endPoint = Qt.point(0, 0) // برای trigger کردن recompute
    }

    // تابع برای highlight کردن اتصال
    function highlight(duration = 1000) {
        isSelected = true
        highlightTimer.interval = duration
        highlightTimer.start()
    }

    Timer {
        id: highlightTimer
        onTriggered: {
            connectionItem.isSelected = false
        }
    }

    // مدیریت visibility بر اساس موقعیت
    function updateVisibility() {
        if (!canvas) {
            isVisible = true
            return
        }

        // بررسی اینکه اتصال در viewport قابل مشاهده باشد
        var viewport = Qt.rect(-canvas.viewOffset.x, -canvas.viewOffset.y,
                              canvas.width / canvas.zoomLevel, canvas.height / canvas.zoomLevel)

        var connectionRect = Qt.rect(
            Math.min(startPoint.x, endPoint.x, controlPoint1.x, controlPoint2.x),
            Math.min(startPoint.y, endPoint.y, controlPoint1.y, controlPoint2.y),
            Math.max(startPoint.x, endPoint.x, controlPoint1.x, controlPoint2.x) -
            Math.min(startPoint.x, endPoint.x, controlPoint1.x, controlPoint2.x),
            Math.max(startPoint.y, endPoint.y, controlPoint1.y, controlPoint2.y) -
            Math.min(startPoint.y, endPoint.y, controlPoint1.y, controlPoint2.y)
        )

        isVisible = viewport.intersects(connectionRect)
    }

    // آپدیت خودکار هنگام تغییر properties
    onStartPointChanged: {
        if (connectionData && canvas) {
            controlPoint1 = Qt.point(
                startPoint.x + Math.max(80, Math.abs(endPoint.x - startPoint.x) * 0.4),
                startPoint.y
            )
            updateVisibility()
        }
    }

    onEndPointChanged: {
        if (connectionData && canvas) {
            controlPoint2 = Qt.point(
                endPoint.x - Math.max(80, Math.abs(endPoint.x - startPoint.x) * 0.4),
                endPoint.y
            )
            updateVisibility()
        }
    }

    onConnectionDataChanged: {
        if (connectionData) {
            console.log("🔗 ConnectionItem created for:", connectionData.connectionId)
        }
    }

    Component.onCompleted: {
        if (connectionData) {
            console.log("🎯 ConnectionItem initialized:", connectionData.connectionId)
            updateVisibility()
        } else if (isTemp) {
            console.log("🎯 Temporary ConnectionItem initialized")
        }
    }

    Component.onDestruction: {
        if (connectionData) {
            console.log("🗑️ ConnectionItem destroyed:", connectionData.connectionId)
        }
    }
}
