import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: distributionItem

    // Properties
    property string label: "Excellent"
    property int count: 0
    property int total: 0
    property color itemColor: theme.primary  // تغییر نام property برای جلوگیری از conflict
    property real percentage: total > 0 ? (count / total) * 100 : 0

    // Signals
    signal clicked()
    signal hovered(bool isHovered)

    height: 60
    radius: 10
    color: theme.backgroundLight  // اینجا فقط یک بار تنظیم شده
    border.color: theme.border
    border.width: 1

    // Hover effect
    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: distributionItem
                color: theme.backgroundLighter  // اینجا فقط در state تغییر می‌کند
                scale: 1.02
            }
            PropertyChanges {
                target: highlightBar
                opacity: 0.8
            }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "color, scale, opacity"; duration: 200 }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        // Header row
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            // Color indicator
            Rectangle {
                width: 12
                height: 12
                radius: 6
                color: distributionItem.itemColor  // استفاده از itemColor
                Layout.alignment: Qt.AlignVCenter

                // Pulse animation for important items
                SequentialAnimation on scale {
                    running: percentage > 0 && (label === "Poor" || label === "Bad")
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.2; duration: 1000; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
                }
            }

            // Label
            Text {
                text: distributionItem.label
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 12
                Layout.fillWidth: true
            }

            // Count
            Text {
                text: distributionItem.count
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 14
                Layout.alignment: Qt.AlignVCenter
            }
        }

        // Progress bar background
        Rectangle {
            Layout.fillWidth: true
            height: 6
            radius: 3
            color: theme.backgroundLighter

            // Progress fill
            Rectangle {
                id: progressFill
                width: parent.width * (percentage / 100)
                height: parent.height
                radius: 3
                color: distributionItem.itemColor  // استفاده از itemColor

                Behavior on width {
                    NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                }
            }
        }

        // Footer row
        RowLayout {
            spacing: 6
            Layout.fillWidth: true

            Text {
                text: Math.round(percentage) + "%"
                color: theme.textSecondary
                font.bold: true
                font.pixelSize: 11
            }

            Item { Layout.fillWidth: true }

            Text {
                text: distributionItem.count + "/" + distributionItem.total
                color: theme.textTertiary
                font.pixelSize: 10
            }
        }
    }

    // Highlight bar on hover
    Rectangle {
        id: highlightBar
        anchors.bottom: parent.bottom
        width: parent.width
        height: 3
        radius: 1.5
        color: distributionItem.itemColor  // استفاده از itemColor
        opacity: 0
    }

    // Mouse interaction
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            distributionItem.hovered(true)
            distributionTooltip.show()
        }

        onExited: {
            distributionItem.hovered(false)
            distributionTooltip.hide()
        }

        onClicked: {
            distributionItem.clicked()
            clickAnimation.start()
        }
    }

    // Click feedback animation
    SequentialAnimation {
        id: clickAnimation
        NumberAnimation {
            target: distributionItem
            property: "scale"
            from: 1.0
            to: 0.95
            duration: 100
        }
        NumberAnimation {
            target: distributionItem
            property: "scale"
            from: 0.95
            to: 1.0
            duration: 100
            easing.type: Easing.OutBack
        }
    }

    // Tooltip with detailed information
    ToolTip {
        id: distributionTooltip
        delay: 500
        timeout: 3000

        contentItem: ColumnLayout {
            spacing: 8
            width: 200

            Text {
                text: distributionItem.label + " Quality"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 14
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.divider
            }

            GridLayout {
                columns: 2
                columnSpacing: 15
                rowSpacing: 6
                Layout.fillWidth: true

                Text {
                    text: "Channels:"
                    color: theme.textSecondary
                    font.pixelSize: 11
                }
                Text {
                    text: distributionItem.count
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 11
                }

                Text {
                    text: "Percentage:"
                    color: theme.textSecondary
                    font.pixelSize: 11
                }
                Text {
                    text: Math.round(percentage) + "%"
                    color: distributionItem.itemColor  // استفاده از itemColor
                    font.bold: true
                    font.pixelSize: 11
                }

                Text {
                    text: "Status:"
                    color: theme.textSecondary
                    font.pixelSize: 11
                }
                Text {
                    text: getStatusText()
                    color: getStatusColor()
                    font.bold: true
                    font.pixelSize: 11
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.divider
            }

            Text {
                text: getQualityDescription()
                color: theme.textSecondary
                font.pixelSize: 10
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.maximumWidth: 180
            }
        }
    }

    // Helper functions
    function getStatusText() {
        switch(label) {
            case "Excellent": return "Optimal"
            case "Good": return "Stable"
            case "Fair": return "Acceptable"
            case "Poor": return "Needs Attention"
            case "Bad": return "Critical"
            default: return "Normal"
        }
    }

    function getStatusColor() {
        switch(label) {
            case "Excellent": return "#4CAF50"
            case "Good": return "#8BC34A"
            case "Fair": return "#FFC107"
            case "Poor": return "#FF9800"
            case "Bad": return "#F44336"
            default: return theme.textPrimary
        }
    }

    function getQualityDescription() {
        switch(label) {
            case "Excellent":
                return "Excellent signal quality with minimal noise and optimal electrode contact."
            case "Good":
                return "Good signal quality suitable for most BCI applications."
            case "Fair":
                return "Acceptable signal quality with some noise. Consider checking electrode placement."
            case "Poor":
                return "Poor signal quality may affect BCI performance. Check electrode connections."
            case "Bad":
                return "Critical signal quality. Immediate attention required for electrode maintenance."
            default:
                return "Signal quality monitoring for EEG electrodes."
        }
    }

    // Public API methods
    function updateCount(newCount, newTotal) {
        count = newCount
        total = newTotal
        percentage = total > 0 ? (count / total) * 100 : 0
    }

    function setColor(newColor) {
        itemColor = newColor  // استفاده از itemColor
    }

    function highlight() {
        highlightAnimation.start()
    }

    // Highlight animation
    SequentialAnimation {
        id: highlightAnimation
        loops: 2

        ParallelAnimation {
            ColorAnimation {
                target: distributionItem
                property: "border.color"
                to: "#FF4081"
                duration: 300
            }
            NumberAnimation {
                target: distributionItem
                property: "border.width"
                to: 3
                duration: 300
            }
        }

        ParallelAnimation {
            ColorAnimation {
                target: distributionItem
                property: "border.color"
                to: theme.border
                duration: 300
            }
            NumberAnimation {
                target: distributionItem
                property: "border.width"
                to: 1
                duration: 300
            }
        }
    }

    // Entrance animation
    Component.onCompleted: {
        opacity = 0
        scale = 0.8
        entranceAnimation.start()
    }

    PropertyAnimation {
        id: entranceAnimation
        target: distributionItem
        properties: "opacity, scale"
        from: 0
        to: 1
        duration: 400
        easing.type: Easing.OutBack
    }
}
