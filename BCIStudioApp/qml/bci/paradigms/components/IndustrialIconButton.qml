import QtQuick
import QtQuick.Layouts

Rectangle {
    id: iconButton
    
    property string icon: ""
    property string tooltip: ""
    
    signal clicked()
    
    width: 36
    height: 36
    radius: 6
    color: mouseArea.containsMouse ? "#333344" : "#252540"
    border.color: "#444466"
    border.width: 1
    
    Text {
        text: iconButton.icon
        font.pixelSize: 14
        anchors.centerIn: parent
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: iconButton.clicked()
    }
    
    // Tooltip
    Rectangle {
        id: tooltipRect
        visible: mouseArea.containsMouse
        width: tooltipText.width + 12
        height: tooltipText.height + 8
        color: "#1A1A2E"
        radius: 3
        border.color: "#333344"
        border.width: 1
        x: parent.width + 5
        y: (parent.height - height) / 2
        
        Text {
            id: tooltipText
            text: iconButton.tooltip
            color: "white"
            font.pixelSize: 10
            font.family: "Segoe UI"
            anchors.centerIn: parent
        }
    }
}