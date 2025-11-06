import QtQuick
import QtQuick.Controls

Rectangle {
    id: flatButton
    
    property string text: ""
    property color backgroundColor: "#7C4DFF"
    property color textColor: "white"
    property color hoverColor: Qt.darker(backgroundColor, 1.1)
    property color pressColor: Qt.darker(backgroundColor, 1.2)
    
    signal clicked()
    
    height: 45
    radius: 6
    color: flatButtonMouseArea.pressed ? pressColor : 
           flatButtonMouseArea.containsMouse ? hoverColor : backgroundColor
    
    Text {
        text: flatButton.text
        color: textColor
        font.bold: true
        font.pixelSize: 13
        font.family: "Segoe UI"
        anchors.centerIn: parent
    }
    
    MouseArea {
        id: flatButtonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: flatButton.clicked()
    }
}