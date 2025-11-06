// AdvancedStatusIndicator.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects  // برای Qt 6

Item {
    id: advancedStatusIndicator

    // Properties
    property string status: "unknown"
    property string text: getDefaultText(status)
    property color color: getStatusColor(status)
    property string icon: getStatusIcon(status)
    property bool showText: true
    property bool showIcon: true
    property bool pulseAnimation: false
    property real pulseDuration: 1000
    property bool glowEffect: true
    property real glowRadius: 8
    property bool showBorder: false
    property real borderWidth: 1

    // Sizes
    property real indicatorSize: 14
    property real iconSize: 16
    property real spacing: 8

    // Animation properties
    property bool enableTransitions: true
    property int transitionDuration: 300

    implicitWidth: contentRow.implicitWidth
    implicitHeight: Math.max(indicatorSize, textItem.implicitHeight)

    // Background for better visibility
    Rectangle {
        id: background
        anchors.fill: contentRow
        anchors.margins: -4
        radius: 6
        color: "transparent"
        border.color: advancedStatusIndicator.showBorder ? advancedStatusIndicator.color : "transparent"
        border.width: advancedStatusIndicator.borderWidth
        opacity: 0.1
    }

    RowLayout {
        id: contentRow
        anchors.fill: parent
        spacing: advancedStatusIndicator.spacing

        // Main Indicator Container
        Item {
            id: indicatorContainer
            width: advancedStatusIndicator.indicatorSize
            height: advancedStatusIndicator.indicatorSize
            Layout.alignment: Qt.AlignVCenter

            // Indicator Dot with multiple effects
            Rectangle {
                id: indicatorDot
                anchors.fill: parent
                radius: width / 2
                color: advancedStatusIndicator.color

                // Color transition
                Behavior on color {
                    enabled: advancedStatusIndicator.enableTransitions
                    ColorAnimation { duration: advancedStatusIndicator.transitionDuration }
                }

                // Scale transition
                Behavior on scale {
                    enabled: advancedStatusIndicator.enableTransitions
                    NumberAnimation { duration: advancedStatusIndicator.transitionDuration }
                }
            }

            // Glow Effect
            Glow {
                anchors.fill: indicatorDot
                radius: advancedStatusIndicator.glowRadius
                samples: 16
                color: advancedStatusIndicator.color
                source: indicatorDot
                visible: advancedStatusIndicator.glowEffect &&
                        (advancedStatusIndicator.pulseAnimation ||
                         advancedStatusIndicator.status === "connected" ||
                         advancedStatusIndicator.status === "success")
            }
        }

        // Status Icon with animation
        Item {
            id: iconContainer
            width: advancedStatusIndicator.showIcon ? advancedStatusIndicator.iconSize : 0
            height: advancedStatusIndicator.iconSize
            Layout.alignment: Qt.AlignVCenter
            visible: advancedStatusIndicator.showIcon

            Text {
                id: iconItem
                anchors.centerIn: parent
                text: advancedStatusIndicator.icon
                font.pixelSize: advancedStatusIndicator.iconSize

                // Rotation animation for processing states
                RotationAnimation on rotation {
                    id: iconRotation
                    running: advancedStatusIndicator.status === "processing" ||
                            advancedStatusIndicator.status === "connecting"
                    from: 0
                    to: 360
                    duration: 2000
                    loops: Animation.Infinite
                }
            }
        }

        // Status Text with fade animation
        Text {
            id: textItem
            text: advancedStatusIndicator.text
            color: theme.textPrimary
            font.pixelSize: 12
            font.bold: advancedStatusIndicator.status === "error" ||
                      advancedStatusIndicator.status === "warning"
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            visible: advancedStatusIndicator.showText

            // Text change animation
            Behavior on text {
                enabled: advancedStatusIndicator.enableTransitions
                PropertyAnimation {
                    duration: advancedStatusIndicator.transitionDuration
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    // Pulse Animation Sequence
    SequentialAnimation {
        id: pulseSequence
        running: advancedStatusIndicator.pulseAnimation &&
                (advancedStatusIndicator.status === "processing" ||
                 advancedStatusIndicator.status === "connecting" ||
                 advancedStatusIndicator.status === "warning")
        loops: Animation.Infinite

        ParallelAnimation {
            NumberAnimation {
                target: indicatorDot
                property: "scale"
                from: 1.0
                to: 1.3
                duration: advancedStatusIndicator.pulseDuration / 2
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                target: indicatorDot
                property: "opacity"
                from: 1.0
                to: 0.7
                duration: advancedStatusIndicator.pulseDuration / 2
                easing.type: Easing.InOutQuad
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: indicatorDot
                property: "scale"
                from: 1.3
                to: 1.0
                duration: advancedStatusIndicator.pulseDuration / 2
                easing.type: Easing.InOutQuad
            }

            NumberAnimation {
                target: indicatorDot
                property: "opacity"
                from: 0.7
                to: 1.0
                duration: advancedStatusIndicator.pulseDuration / 2
                easing.type: Easing.InOutQuad
            }
        }
    }

    // Status-specific animations
    SequentialAnimation {
        id: successAnimation
        running: advancedStatusIndicator.status === "success"
        loops: 1

        ParallelAnimation {
            NumberAnimation {
                target: indicatorDot
                property: "scale"
                from: 1.0
                to: 1.5
                duration: 200
                easing.type: Easing.OutBack
            }

            NumberAnimation {
                target: indicatorDot
                property: "opacity"
                from: 1.0
                to: 0.8
                duration: 200
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: indicatorDot
                property: "scale"
                from: 1.5
                to: 1.0
                duration: 300
                easing.type: Easing.OutElastic
            }

            NumberAnimation {
                target: indicatorDot
                property: "opacity"
                from: 0.8
                to: 1.0
                duration: 300
            }
        }
    }

    // Functions
    function getStatusColor(status) {
        switch(status) {
            case "connected":
            case "success":
            case "active":
                return "#4CAF50" // Green

            case "disconnected":
            case "inactive":
            case "offline":
                return "#757575" // Gray

            case "error":
            case "failed":
                return "#F44336" // Red

            case "warning":
            case "caution":
                return "#FF9800" // Orange

            case "processing":
            case "connecting":
            case "loading":
                return "#2196F3" // Blue

            case "standby":
                return "#FFC107" // Yellow

            case "initializing":
                return "#9C27B0" // Purple

            case "unknown":
            default:
                return "#9E9E9E" // Light Gray
        }
    }

    function getStatusIcon(status) {
        switch(status) {
            case "connected":
            case "success":
                return "✅"

            case "disconnected":
            case "inactive":
                return "⭕"

            case "error":
            case "failed":
                return "❌"

            case "warning":
            case "caution":
                return "⚠️"

            case "processing":
            case "connecting":
                return "🔄"

            case "loading":
                return "⏳"

            case "standby":
                return "⏸️"

            case "initializing":
                return "🚀"

            case "unknown":
            default:
                return "❓"
        }
    }

    function getDefaultText(status) {
        switch(status) {
            case "connected": return "Connected"
            case "disconnected": return "Disconnected"
            case "error": return "Error"
            case "warning": return "Warning"
            case "processing": return "Processing"
            case "success": return "Success"
            case "connecting": return "Connecting..."
            case "loading": return "Loading..."
            case "active": return "Active"
            case "inactive": return "Inactive"
            case "failed": return "Failed"
            case "standby": return "Standby"
            case "initializing": return "Initializing"
            case "unknown": return "Unknown"
            default: return status.charAt(0).toUpperCase() + status.slice(1)
        }
    }

    // Public API
    function setStatus(newStatus, customText, customIcon) {
        if (customText !== undefined) {
            text = customText
        } else {
            text = getDefaultText(newStatus)
        }

        if (customIcon !== undefined) {
            icon = customIcon
        } else {
            icon = getStatusIcon(newStatus)
        }

        status = newStatus
    }

    function startPulse(duration) {
        if (duration !== undefined) {
            pulseDuration = duration
        }
        pulseAnimation = true
    }

    function stopPulse() {
        pulseAnimation = false
        indicatorDot.scale = 1.0
        indicatorDot.opacity = 1.0
    }

    function showTemporaryStatus(newStatus, duration, callback) {
        var originalStatus = status
        var originalText = text
        var originalIcon = icon

        setStatus(newStatus)

        tempStatusTimer.interval = duration
        tempStatusTimer.callback = function() {
            setStatus(originalStatus, originalText, originalIcon)
            if (callback) callback()
        }
        tempStatusTimer.start()
    }

    // Timer for temporary status
    Timer {
        id: tempStatusTimer
        property var callback
        onTriggered: {
            if (callback) callback()
            callback = null
        }
    }

    // Tooltip for additional information
    ToolTip {
        id: statusTooltip
        delay: 500
        text: getTooltipText()
    }

    function getTooltipText() {
        var baseText = text + " (" + status + ")"
        switch(status) {
            case "connected": return baseText + "\nAll systems operational"
            case "error": return baseText + "\nImmediate attention required"
            case "warning": return baseText + "\nPotential issue detected"
            case "processing": return baseText + "\nOperation in progress"
            default: return baseText
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            console.log("Status indicator clicked:", status)
        }
        onEntered: statusTooltip.visible = true
        onExited: statusTooltip.visible = false
    }

    // Component initialization
    Component.onCompleted: {
        console.log("AdvancedStatusIndicator initialized with status:", status)
    }
}
