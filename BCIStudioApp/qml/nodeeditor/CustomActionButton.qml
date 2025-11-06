import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: actionButton

    // Properties
    property string buttonIcon: ""
    property string tooltipText: ""
    property string buttonText: ""
    property bool enabled: true
    property bool isAccent: false
    property bool isSmall: false
    property bool showText: false
    property string buttonType: "icon" // "icon", "text", "icon-text"
    property color customColor: "transparent"
    property color customHoverColor: "transparent"
    property color customPressedColor: "transparent"
    property real iconSize: 12
    property real textSize: 9
    property bool showBorder: false
    property string badgeText: ""
    property color badgeColor: theme.error
    property bool loading: false
    property real loadingProgress: 0

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

    // Computed properties for sizing - فقط یک بار bind می‌شوند
    property real computedWidth: {
        if (isSmall) return 24
        if (showText && buttonText) return Math.max(32, buttonText.length * 6 + 20)
        return 32
    }

    property real computedHeight: isSmall ? 24 : 32

    // اینجا فقط یک بار width و height را bind می‌کنیم
    width: computedWidth
    height: computedHeight
    radius: 6

    // Computed properties for colors
    property color backgroundColor: {
        if (!enabled) return theme.backgroundTertiary
        if (customColor !== "transparent") return customColor

        if (mouseArea.containsPress) {
            if (customPressedColor !== "transparent") return customPressedColor
            return isAccent ? Qt.darker(theme.error, 1.2) : Qt.darker(theme.primary, 1.2)
        }

        if (mouseArea.containsMouse) {
            if (customHoverColor !== "transparent") return customHoverColor
            return isAccent ? Qt.lighter(theme.error, 1.1) : Qt.lighter(theme.primary, 1.1)
        }

        return isAccent ? theme.error : theme.backgroundTertiary
    }

    property color contentColor: {
        if (!enabled) return theme.textTertiary
        if (isAccent || customColor !== "transparent") return "white"
        return theme.textPrimary
    }

    property color borderColor: {
        if (!enabled) return theme.border
        if (showBorder) return isAccent ? theme.error : theme.primary
        return "transparent"
    }

    opacity: enabled ? 1.0 : 0.5
    color: backgroundColor
    border.color: borderColor
    border.width: showBorder ? 1 : 0

    // Animations
    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Behavior on scale {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    // Content
    Row {
        id: contentRow
        anchors.centerIn: parent
        spacing: 4
        visible: !loading

        // Icon
        Text {
            id: iconText
            text: buttonIcon
            font.pixelSize: isSmall ? 10 : iconSize
            color: contentColor
            anchors.verticalCenter: parent.verticalCenter
            visible: buttonType !== "text" && buttonIcon !== ""
        }

        // Text
        Text {
            id: buttonLabel
            text: buttonText
            color: contentColor
            font.family: "Segoe UI"
            font.pixelSize: isSmall ? 8 : textSize
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            visible: (buttonType !== "icon" && buttonText !== "") || showText
        }
    }

    // Loading indicator
    Rectangle {
        id: loadingIndicator
        anchors.centerIn: parent
        width: 16
        height: 16
        radius: 8
        color: "transparent"
        border.color: contentColor
        border.width: 2
        visible: loading

        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 1000
            loops: Animation.Infinite
            running: loading
        }
    }

    // Progress indicator
    Rectangle {
        id: progressBackground
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 2
        color: theme.border
        visible: loading && loadingProgress > 0
    }

    Rectangle {
        id: progressBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        height: 2
        width: parent.width * loadingProgress
        color: theme.primary
        visible: loading && loadingProgress > 0

        Behavior on width {
            NumberAnimation { duration: 300 }
        }
    }

    // Badge
    Rectangle {
        id: badge
        width: Math.max(12, badgeText.length * 4 + 4)
        height: 12
        radius: 6
        color: badgeColor
        border.color: theme.backgroundPrimary
        border.width: 1
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: -2
        visible: badgeText !== ""

        Text {
            text: badgeText
            color: "white"
            font.family: "Segoe UI"
            font.pixelSize: 7
            font.bold: true
            anchors.centerIn: parent
        }
    }

    // Mouse area
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            if (enabled) {
                actionButton.clicked()
            }
        }

        onPressed: {
            if (enabled) {
                actionButton.scale = 0.95
            }
        }

        onReleased: {
            if (enabled) {
                actionButton.scale = 1.0
            }
        }

        onEntered: {
            if (enabled) {
                actionButton.scale = 1.05
            }
        }

        onExited: {
            if (enabled) {
                actionButton.scale = 1.0
            }
        }
    }

    // Tooltip
    ToolTip {
        text: tooltipText
        visible: mouseArea.containsMouse && tooltipText !== "" && enabled
        delay: 500
    }

    // Signals
    signal clicked()
    signal pressed()
    signal released()
    signal entered()
    signal exited()

    // Public functions
    function setEnabled(state) {
        enabled = state
    }

    function setLoading(state) {
        loading = state
    }

    function setProgress(progress) {
        loadingProgress = Math.max(0, Math.min(1, progress))
    }

    function setBadge(text) {
        badgeText = text
    }

    function clearBadge() {
        badgeText = ""
    }

    function flash() {
        flashAnimation.start()
    }

    function pulse() {
        pulseAnimation.start()
    }

    // Animations
    SequentialAnimation {
        id: flashAnimation
        running: false
        loops: 2

        PropertyAnimation {
            target: actionButton
            property: "opacity"
            to: 0.3
            duration: 100
        }

        PropertyAnimation {
            target: actionButton
            property: "opacity"
            to: 1.0
            duration: 100
        }
    }

    SequentialAnimation {
        id: pulseAnimation
        running: false
        loops: Animation.Infinite

        PropertyAnimation {
            target: actionButton
            property: "scale"
            to: 1.1
            duration: 500
            easing.type: Easing.InOutQuad
        }

        PropertyAnimation {
            target: actionButton
            property: "scale"
            to: 1.0
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }

    Component.onCompleted: {
        console.log("CustomActionButton created:", buttonText || buttonIcon)
    }
}
