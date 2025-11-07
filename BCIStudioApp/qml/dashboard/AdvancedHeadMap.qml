// AdvancedHeadMapEnterprise.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: advancedHeadMap

    property var qualityData: []
    property var electrodePositions: []
    property bool showHeatMap: true
    property bool showLabels: true
    property real scale: 1.0
    property string selectedRegion: ""

    signal electrodeSelected(string channel, real quality)
    signal regionSelected(string region)

    // Head background - بزرگ‌تر و شفاف
    Rectangle {
        id: headBackground
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) * 0.9 * scale  // 90% فضای available
        height: width
        radius: width / 2
        color: "transparent"
        border.color: Qt.rgba(theme.textPrimary.r, theme.textPrimary.g, theme.textPrimary.b, 0.6)
        border.width: 3

        // گرادیانت نرم برای عمق
        RadialGradient {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(1, 1, 1, 0.05) }
                GradientStop { position: 0.8; color: "transparent" }
            }
        }
    }

    // Heat map overlay
    Rectangle {
        anchors.fill: headBackground
        radius: headBackground.radius
        opacity: showHeatMap ? 0.2 : 0
        visible: showHeatMap

        RadialGradient {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: Qt.rgba(0.3, 0.8, 0.3, 0.4) }
                GradientStop { position: 0.5; color: Qt.rgba(0.8, 0.8, 0.3, 0.2) }
                GradientStop { position: 1.0; color: Qt.rgba(0.8, 0.3, 0.3, 0.1) }
            }
        }
    }

    // Electrodes container
    Item {
        id: electrodesContainer
        anchors.fill: headBackground

        Repeater {
            id: electrodeRepeater
            model: advancedHeadMap.qualityData

            delegate: ElectrodeItemEnterprise {
                channel: modelData.channel
                quality: modelData.quality
                impedance: modelData.impedance
                region: modelData.region
                showLabel: advancedHeadMap.showLabels
                mapSize: headBackground.width

                position: {
                    var pos = findElectrodePosition(modelData.channel)
                    return pos ? { x: pos.x, y: pos.y } : { x: 0.5, y: 0.5 }
                }

                onClicked: function(channel, quality) {
                    advancedHeadMap.electrodeSelected(channel, quality)
                    highlightRegion(region)
                }
            }
        }
    }

    function findElectrodePosition(channel) {
        for (var i = 0; i < electrodePositions.length; i++) {
            if (electrodePositions[i].label === channel) {
                return electrodePositions[i]
            }
        }
        return null
    }

    function highlightRegion(region) {
        if (region && region !== selectedRegion) {
            selectedRegion = region
            regionSelected(region)
        }
    }
}
