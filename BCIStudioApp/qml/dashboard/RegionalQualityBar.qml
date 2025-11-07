import QtQuick
import QtQuick.Layouts

Rectangle {
    id: regionalBar
    height: 28
    radius: 6
    color: "transparent"
    border.color: mouseArea.containsMouse ? customColor : "transparent"
    border.width: 1

    property string region: ""
    property real quality: 0
    property int electrodeCount: 0
    property color customColor: theme.primary

    signal clicked(string region)

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 8

        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: customColor
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
            color: customColor
            font.bold: true
            font.pixelSize: 11
        }

        Text {
            text: electrodeCount
            color: theme.textSecondary
            font.pixelSize: 10
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: regionalBar.clicked(region)
    }

    function getRegionShortName(region) {
        var names = {
            "frontal": "FRONTAL",
            "central": "CENTRAL", 
            "parietal": "PARIETAL",
            "occipital": "OCCIPITAL",
            "temporal": "TEMPORAL"
        }
        return names[region] || region
    }
}