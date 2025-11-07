import QtQuick
import QtQuick.Controls

Item {
    id: electrodeItem

    property string channel: ""
    property real quality: 0
    property var position: ({ x: 0.5, y: 0.5 })
    property real mapSize: 300
    property real impedance: 0
    property string region: ""
    property bool showLabel: true

    signal clicked(string channel, real quality)

    // Positioning - بهینه شده برای سر بزرگ‌تر
    x: (position.x - 0.5) * mapSize + mapSize/2 - width/2
    y: (position.y - 0.5) * mapSize + mapSize/2 - height/2
    width: 36
    height: 36

    Rectangle {
        id: electrodeCircle
        anchors.centerIn: parent
        width: 30
        height: 30
        radius: 15
        color: getQualityColor(quality)
        border.color: quality >= 60 ? "white" : theme.textPrimary
        border.width: quality >= 80 ? 3 : quality >= 60 ? 2 : 1
    }

    Text {
        anchors.centerIn: parent
        text: channel
        color: quality >= 40 ? "white" : theme.textPrimary
        font.bold: true
        font.pixelSize: 10
        visible: showLabel
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: electrodeItem.clicked(channel, quality)
    }

    function getQualityColor(quality) {
        if (quality >= 80) return "#4CAF50"
        if (quality >= 60) return "#8BC34A"
        if (quality >= 40) return "#FFC107"
        if (quality >= 20) return "#FF9800"
        return "#F44336"
    }
}