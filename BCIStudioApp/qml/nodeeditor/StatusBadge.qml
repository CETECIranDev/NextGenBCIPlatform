import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout {
    id: statusBadge
    spacing: 6

    // Properties
    property string badgeLabel: ""
    property string badgeValue: ""
    property color badgeColor: theme.primary
    property string badgeIcon: ""
    property string badgeType: "default" // "default", "success", "warning", "error", "info", "neutral"
    property bool showIcon: true
    property bool showLabel: true
    property bool showValue: true
    property bool clickable: false
    property string tooltipText: ""
    property bool pulse: false
    property bool showDot: false
    property real dotSize: 6
    property real iconSize: 12
    property real fontSize: 11
    property bool compact: false
    property bool outline: false
    property int badgeSize: 0 // 0=auto, 1=small, 2=medium, 3=large

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

    // Computed properties
    property color computedColor: {
        switch(badgeType) {
            case "success": return theme.success
            case "warning": return theme.warning
            case "error": return theme.error
            case "info": return theme.info
            case "neutral": return theme.textTertiary
            default: return badgeColor
        }
    }

    property color textColor: {
        if (outline) return computedColor
        return theme.backgroundPrimary
    }

    property color backgroundColor: {
        if (outline) return "transparent"
        return computedColor
    }

    property color borderColor: {
        if (outline) return computedColor
        return computedColor
    }

    property real computedIconSize: {
        switch(badgeSize) {
            case 1: return 10
            case 2: return 14
            case 3: return 16
            default: return iconSize
        }
    }

    property real computedFontSize: {
        switch(badgeSize) {
            case 1: return 9
            case 2: return 12
            case 3: return 14
            default: return fontSize
        }
    }

    property real computedSpacing: {
        switch(badgeSize) {
            case 1: return 4
            case 2: return 6
            case 3: return 8
            default: return 6
        }
    }

    property real padding: {
        switch(badgeSize) {
            case 1: return 4
            case 2: return 6
            case 3: return 8
            default: return 6
        }
    }

    // Signals
    signal clicked()
    signal rightClicked()
    signal doubleClicked()
    signal hovered(bool hovered)

    // Main container
    Rectangle {
        id: badgeContainer
        radius: 12
        color: backgroundColor
        border.color: borderColor
        border.width: outline ? 1 : 0
        Layout.preferredHeight: {
            switch(badgeSize) {
                case 1: return 18
                case 2: return 24
                case 3: return 30
                default: return 24
            }
        }
        Layout.preferredWidth: compact ? undefined : badgeContent.width + (padding * 2)
        implicitWidth: badgeContent.width + (padding * 2)
        implicitHeight: badgeContent.height + (padding * 2)

        // Pulse animation
        SequentialAnimation on opacity {
            running: pulse
            loops: Animation.Infinite
            NumberAnimation { to: 0.7; duration: 1000; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
        }

        // Content
        RowLayout {
            id: badgeContent
            anchors.centerIn: parent
            spacing: computedSpacing

            // Dot indicator
            Rectangle {
                id: dotIndicator
                width: dotSize
                height: dotSize
                radius: dotSize / 2
                color: textColor
                visible: showDot && !badgeIcon
                Layout.alignment: Qt.AlignVCenter
            }

            // Icon
            Text {
                id: iconText
                text: badgeIcon
                font.pixelSize: computedIconSize
                color: textColor
                visible: showIcon && badgeIcon !== "" && !showDot
                Layout.alignment: Qt.AlignVCenter
            }

            // Label
            Text {
                id: labelText
                text: badgeLabel + (showLabel && showValue && badgeValue !== "" ? ":" : "")
                color: textColor
                font.family: "Segoe UI"
                font.pixelSize: computedFontSize
                font.bold: false
                visible: showLabel && badgeLabel !== "" && !compact
                Layout.alignment: Qt.AlignVCenter
            }

            // Value
            Text {
                id: valueText
                text: badgeValue
                color: textColor
                font.family: "Segoe UI"
                font.pixelSize: computedFontSize
                font.bold: true
                visible: showValue && badgeValue !== ""
                Layout.alignment: Qt.AlignVCenter
            }
        }

        // Mouse area for interactions
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
            acceptedButtons: clickable ? (Qt.LeftButton | Qt.RightButton) : Qt.NoButton

            onClicked: (mouse) => {
                if (mouse.button === Qt.LeftButton) {
                    statusBadge.clicked()
                } else if (mouse.button === Qt.RightButton) {
                    statusBadge.rightClicked()
                }
            }

            onDoubleClicked: {
                statusBadge.doubleClicked()
            }

            onEntered: {
                statusBadge.hovered(true)
                if (tooltipText !== "") {
                    badgeTooltip.show()
                }
            }

            onExited: {
                statusBadge.hovered(false)
                badgeTooltip.hide()
            }

            onPressed: {
                if (clickable) {
                    badgeContainer.scale = 0.95
                }
            }

            onReleased: {
                if (clickable) {
                    badgeContainer.scale = 1.0
                }
            }
        }

        Behavior on scale {
            NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
        }
    }

    // Tooltip
    ToolTip {
        id: badgeTooltip
        text: tooltipText
        delay: 500
        timeout: 3000
    }

    // Public functions
    function setValue(newValue) {
        badgeValue = newValue
    }

    function setLabel(newLabel) {
        badgeLabel = newLabel
    }

    function setIcon(newIcon) {
        badgeIcon = newIcon
    }

    function setType(newType) {
        badgeType = newType
    }

    function setColor(newColor) {
        badgeColor = newColor
    }

    function startPulse() {
        pulse = true
    }

    function stopPulse() {
        pulse = false
    }

    function flash() {
        flashAnimation.start()
    }

    function show() {
        visible = true
    }

    function hide() {
        visible = false
    }

    function toggle() {
        visible = !visible
    }

    // Animations
    SequentialAnimation {
        id: flashAnimation
        running: false

        ParallelAnimation {
            NumberAnimation {
                target: badgeContainer
                property: "scale"
                to: 1.2
                duration: 100
            }
            ColorAnimation {
                target: badgeContainer
                property: "color"
                to: theme.warning
                duration: 100
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: badgeContainer
                property: "scale"
                to: 1.0
                duration: 200
            }
            ColorAnimation {
                target: badgeContainer
                property: "color"
                to: backgroundColor
                duration: 200
            }
        }
    }

    Component.onCompleted: {
        console.log("StatusBadge created:", badgeLabel, badgeValue, badgeType)
    }
}


