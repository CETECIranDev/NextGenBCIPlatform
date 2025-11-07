// ElectrodeItem.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: electrodeItem

    // Properties
    property string channel: ""
    property real quality: 0
    property var position: ({ x: 0.5, y: 0.5 })
    property real mapSize: 300
    property bool showInterpolation: true
    property real impedance: 0
    property string region: ""
    property bool showLabel: true  // Property جدید برای کنترل نمایش label

    // Signals
    signal clicked(string channel, real quality)
    signal hovered(string channel, real quality)

    // Positioning
    x: (position.x - 0.5) * mapSize * 1.8 + mapSize/2 - width/2
    y: (position.y - 0.5) * mapSize * 1.8 + mapSize/2 - height/2
    width: 28
    height: 28

    // Quality indicator with glow effect
    Rectangle {
        id: electrodeCircle
        anchors.centerIn: parent
        width: 22
        height: 22
        radius: 11
        color: getQualityColor(quality)
        border.color: quality >= 60 ? "white" : theme.textPrimary
        border.width: quality >= 80 ? 3 : quality >= 60 ? 2 : 1

        // Pulse animation for poor quality electrodes
        SequentialAnimation on scale {
            running: quality < 40 && electrodeItem.visible
            loops: Animation.Infinite
            NumberAnimation { to: 1.1; duration: 800; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
        }
    }

    // Glow effect for good quality electrodes (separate item)
    Glow {
        id: electrodeGlow
        anchors.fill: electrodeCircle
        source: electrodeCircle
        radius: quality >= 90 ? 12 : quality >= 80 ? 8 : 4
        samples: 16
        color: electrodeCircle.color
        transparentBorder: true
        visible: quality >= 70
    }

    // Channel label - با کنترل showLabel
    Text {
        id: channelLabel
        anchors.centerIn: parent
        text: channel
        color: quality >= 40 ? "white" : theme.textPrimary
        font.bold: true
        font.pixelSize: quality >= 60 ? 10 : 9
        visible: showLabel  // کنترل نمایش با property جدید
    }

    // Quality percentage (shown on hover)
    Rectangle {
        id: qualityBadge
        anchors {
            top: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        width: qualityText.implicitWidth + 8
        height: qualityText.implicitHeight + 4
        radius: 4
        color: theme.backgroundCard
        border.color: getQualityColor(quality)
        border.width: 1
        opacity: 0
        scale: 0.8

        Text {
            id: qualityText
            anchors.centerIn: parent
            text: Math.round(quality) + "%"
            color: getQualityColor(quality)
            font.bold: true
            font.pixelSize: 9
        }

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }

        Behavior on scale {
            NumberAnimation { duration: 200 }
        }
    }

    // Impedance indicator (small dot)
    Rectangle {
        id: impedanceDot
        anchors {
            top: parent.top
            right: parent.right
            margins: 2
        }
        width: 6
        height: 6
        radius: 3
        color: getImpedanceColor(impedance)
        visible: impedance > 0

        ToolTip.text: "Impedance: " + impedance.toFixed(1) + " kΩ"
    }

    // Mouse area for interaction
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            qualityBadge.opacity = 1
            qualityBadge.scale = 1
            electrodeTooltip.show()
            hovered(channel, quality)
        }

        onExited: {
            qualityBadge.opacity = 0
            qualityBadge.scale = 0.8
            electrodeTooltip.hide()
        }

        onClicked: {
            electrodeItem.clicked(channel, quality)
            clickAnimation.start()
        }
    }

    // Click feedback animation
    SequentialAnimation {
        id: clickAnimation
        ParallelAnimation {
            NumberAnimation {
                target: electrodeCircle
                property: "scale"
                from: 1.0
                to: 1.3
                duration: 150
            }
            NumberAnimation {
                target: electrodeCircle
                property: "opacity"
                from: 1.0
                to: 0.7
                duration: 150
            }
        }
        ParallelAnimation {
            NumberAnimation {
                target: electrodeCircle
                property: "scale"
                from: 1.3
                to: 1.0
                duration: 150
            }
            NumberAnimation {
                target: electrodeCircle
                property: "opacity"
                from: 0.7
                to: 1.0
                duration: 150
            }
        }
    }

    // Tooltip with detailed information
    ToolTip {
        id: electrodeTooltip
        delay: 300

        contentItem: ColumnLayout {
            spacing: 6

            Text {
                text: "🧠 " + channel
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.divider
            }

            GridLayout {
                columns: 2
                columnSpacing: 10
                rowSpacing: 4

                Text { text: "Quality:"; color: theme.textSecondary; font.pixelSize: 10 }
                Text {
                    text: Math.round(quality) + "%";
                    color: getQualityColor(quality);
                    font.bold: true;
                    font.pixelSize: 10
                }

                Text { text: "Impedance:"; color: theme.textSecondary; font.pixelSize: 10 }
                Text {
                    text: impedance > 0 ? impedance.toFixed(1) + " kΩ" : "N/A";
                    color: getImpedanceColor(impedance);
                    font.pixelSize: 10
                }

                Text { text: "Region:"; color: theme.textSecondary; font.pixelSize: 10 }
                Text {
                    text: region.charAt(0).toUpperCase() + region.slice(1);
                    color: theme.textPrimary;
                    font.pixelSize: 10
                }

                Text { text: "Status:"; color: theme.textSecondary; font.pixelSize: 10 }
                Text {
                    text: getQualityDescription(quality);
                    color: getQualityColor(quality);
                    font.bold: true;
                    font.pixelSize: 10
                }

                Text { text: "Label:"; color: theme.textSecondary; font.pixelSize: 10 }
                Text {
                    text: showLabel ? "Visible" : "Hidden";
                    color: showLabel ? "#4CAF50" : "#FF9800";
                    font.bold: true;
                    font.pixelSize: 10
                }
            }
        }
    }

    // Helper functions
    function getQualityColor(quality) {
        if (quality >= 80) return "#4CAF50"
        if (quality >= 60) return "#8BC34A"
        if (quality >= 40) return "#FFC107"
        if (quality >= 20) return "#FF9800"
        return "#F44336"
    }

    function getImpedanceColor(impedance) {
        if (impedance <= 5) return "#4CAF50"
        if (impedance <= 10) return "#8BC34A"
        if (impedance <= 20) return "#FFC107"
        if (impedance <= 50) return "#FF9800"
        return "#F44336"
    }

    function getQualityDescription(quality) {
        if (quality >= 80) return "Excellent"
        if (quality >= 60) return "Good"
        if (quality >= 40) return "Fair"
        if (quality >= 20) return "Poor"
        return "Bad"
    }

    // Public API methods
    function highlight() {
        highlightAnimation.start()
    }

    function setQuality(newQuality) {
        quality = Math.max(0, Math.min(100, newQuality))
        electrodeGlow.radius = quality >= 90 ? 12 : quality >= 80 ? 8 : 4
    }

    function setImpedance(newImpedance) {
        impedance = Math.max(0, newImpedance)
    }

    // تابع جدید برای کنترل نمایش label
    function showChannelLabel(show) {
        showLabel = show
    }

    function toggleLabel() {
        showLabel = !showLabel
    }

    // Highlight animation
    SequentialAnimation {
        id: highlightAnimation
        loops: 3

        ParallelAnimation {
            NumberAnimation {
                target: electrodeCircle
                property: "scale"
                to: 1.4
                duration: 200
            }
            ColorAnimation {
                target: electrodeCircle
                property: "border.color"
                to: "#FF4081"
                duration: 200
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: electrodeCircle
                property: "scale"
                to: 1.0
                duration: 200
            }
            ColorAnimation {
                target: electrodeCircle
                property: "border.color"
                to: quality >= 60 ? "white" : theme.textPrimary
                duration: 200
            }
        }
    }

    // Update glow when quality changes
    onQualityChanged: {
        electrodeGlow.radius = quality >= 90 ? 12 : quality >= 80 ? 8 : 4
        electrodeGlow.visible = quality >= 70
    }

    // رفتار هنگام تغییر showLabel
    onShowLabelChanged: {
        console.log("Electrode", channel, "label visibility:", showLabel ? "Visible" : "Hidden")
    }
}
