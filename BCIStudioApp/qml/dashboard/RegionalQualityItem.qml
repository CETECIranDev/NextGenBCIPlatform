// RegionalQualityItem.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: regionalItem

    // Properties
    property string region: ""
    property real quality: 0
    property int electrodeCount: 0
    property color customColor: "transparent"

    // Signals
    signal clicked(string region)
    signal hovered(string region, real quality)

    height: 36
    radius: 6
    color: theme.backgroundLight
    border.color: theme.border
    border.width: 1

    // Hover effect
    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: regionalItem
                color: theme.backgroundLighter
                scale: 1.02
            }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "color, scale"; duration: 200 }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        // Quality indicator
        Rectangle {
            width: 12
            height: 12
            radius: 6
            color: customColor !== "transparent" ? customColor : getQualityColor(quality)
            Layout.alignment: Qt.AlignVCenter

            // Pulse for poor quality regions
            SequentialAnimation on opacity {
                running: quality < 50 && regionalItem.visible
                loops: Animation.Infinite
                NumberAnimation { to: 0.5; duration: 1000; easing.type: Easing.InOutQuad }
                NumberAnimation { to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
            }
        }

        // Region info
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
                text: getRegionDisplayName()
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 11
                Layout.fillWidth: true
            }

            Text {
                text: electrodeCount + " electrode" + (electrodeCount !== 1 ? "s" : "")
                color: theme.textSecondary
                font.pixelSize: 9
                Layout.fillWidth: true
            }
        }

        // Quality percentage
        Text {
            text: Math.round(quality) + "%"
            color: customColor !== "transparent" ? customColor : getQualityColor(quality)
            font.bold: true
            font.pixelSize: 12
            Layout.alignment: Qt.AlignVCenter
        }
    }

    // Mouse interaction
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            regionalTooltip.show()
            hovered(region, quality)
        }

        onExited: {
            regionalTooltip.hide()
        }

        onClicked: {
            regionalItem.clicked(region)

            // Click feedback
            clickAnimation.start()
        }
    }

    // Click feedback animation
    SequentialAnimation {
        id: clickAnimation
        NumberAnimation {
            target: regionalItem
            property: "scale"
            from: 1.0
            to: 0.95
            duration: 100
        }
        NumberAnimation {
            target: regionalItem
            property: "scale"
            from: 0.95
            to: 1.0
            duration: 100
        }
    }

    // Tooltip with regional details
    ToolTip {
        id: regionalTooltip
        delay: 500

        contentItem: ColumnLayout {
            spacing: 8

            Text {
                text: "🧠 " + getRegionDisplayName()
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 13
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

                Text { text: "Average Quality:"; color: theme.textSecondary; font.pixelSize: 11 }
                Text {
                    text: Math.round(quality) + "%";
                    color: getQualityColor(quality);
                    font.bold: true;
                    font.pixelSize: 11
                }

                Text { text: "Electrodes:"; color: theme.textSecondary; font.pixelSize: 11 }
                Text {
                    text: electrodeCount;
                    color: theme.textPrimary;
                    font.pixelSize: 11
                }

                Text { text: "Status:"; color: theme.textSecondary; font.pixelSize: 11 }
                Text {
                    text: getQualityDescription(quality);
                    color: getQualityColor(quality);
                    font.bold: true;
                    font.pixelSize: 11
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.divider
            }

            Text {
                text: getRegionalDescription()
                color: theme.textSecondary
                font.pixelSize: 10
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.maximumWidth: 200
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

    function getQualityDescription(quality) {
        if (quality >= 80) return "Excellent"
        if (quality >= 60) return "Good"
        if (quality >= 40) return "Fair"
        if (quality >= 20) return "Poor"
        return "Critical"
    }

    function getRegionDisplayName() {
        if (region === "frontal") return "Frontal"
        if (region === "central") return "Central"
        if (region === "parietal") return "Parietal"
        if (region === "occipital") return "Occipital"
        if (region === "temporal") return "Temporal"
        return region.charAt(0).toUpperCase() + region.slice(1)
    }

    function getRegionalDescription() {
        if (region === "frontal") return "Executive functions, decision making, problem solving"
        if (region === "central") return "Motor control, sensory processing"
        if (region === "parietal") return "Spatial awareness, sensory integration"
        if (region === "occipital") return "Visual processing"
        if (region === "temporal") return "Auditory processing, memory, language"
        return "Brain region monitoring"
    }

    // Public API methods
    function setQuality(newQuality) {
        quality = Math.max(0, Math.min(100, newQuality))
    }

    function setElectrodeCount(count) {
        electrodeCount = Math.max(0, count)
    }

    function highlight() {
        highlightAnimation.start()
    }

    // Highlight animation - تصحیح شده
    SequentialAnimation {
        id: highlightAnimation
        loops: 2

        ParallelAnimation {
            ColorAnimation {  // تغییر از NumberAnimation به ColorAnimation
                target: regionalItem
                property: "border.color"
                to: "#FF4081"
                duration: 300
            }
            NumberAnimation {
                target: regionalItem
                property: "border.width"
                to: 3
                duration: 300
            }
        }

        ParallelAnimation {
            ColorAnimation {  // تغییر از NumberAnimation به ColorAnimation
                target: regionalItem
                property: "border.color"
                to: theme.border
                duration: 300
            }
            NumberAnimation {
                target: regionalItem
                property: "border.width"
                to: 1
                duration: 300
            }
        }
    }
}
