import QtQuick
import QtQuick.Layouts

Rectangle {
    id: regionalCompact
    height: 32
    radius: 8
    color: mouseArea.containsMouse ? theme.backgroundLighter : theme.backgroundLight
    border.color: theme.border
    border.width: 1

    property string region: ""
    property real quality: 0
    property int electrodeCount: 0
    property color customColor: "transparent"

    signal clicked(string region)

    RowLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 8

        Rectangle {
            width: 10
            height: 10
            radius: 5
            color: customColor !== "transparent" ? customColor : getQualityColor(quality)
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: getRegionShortName(region)
            color: theme.textPrimary
            font.bold: true
            font.pixelSize: 10
            Layout.fillWidth: true
        }

        Text {
            text: Math.round(quality) + "%"
            color: customColor !== "transparent" ? customColor : getQualityColor(quality)
            font.bold: true
            font.pixelSize: 11
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: regionalCompact.clicked(region)
    }

    function getRegionShortName(region) {
        var names = {
            "frontal": "FRONT",
            "central": "CENT", 
            "parietal": "PAR",
            "occipital": "OCC",
            "temporal": "TEMP"
        }
        return names[region] || region
    }

    function getQualityColor(quality) {
        if (quality >= 80) return "#4CAF50"
        if (quality >= 60) return "#8BC34A"
        if (quality >= 40) return "#FFC107"
        if (quality >= 20) return "#FF9800"
        return "#F44336"
    }
}