import QtQuick
import QtQuick.Controls

Rectangle {
    id: iconButton
    width: size
    height: size
    radius: 8
    color: "transparent"
    
    property string icon: "⚙️"
    property string tooltipText: "Button"
    property int size: 40
    property color hoverColor: theme.primaryColor
    
    signal clicked()
    
    property bool hovered: false
    
    Text {
        text: icon
        font.pixelSize: 16
        anchors.centerIn: parent
        opacity: hovered ? 1.0 : 0.7
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onEntered: hovered = true
        onExited: hovered = false
        onClicked: iconButton.clicked()
    }
    
    // Background on hover
    Rectangle {
        anchors.fill: parent
        color: hoverColor
        opacity: hovered ? 0.1 : 0
        radius: parent.radius
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }
    
    ToolTip.text: tooltipText
    ToolTip.visible: hovered
    ToolTip.delay: 500
}