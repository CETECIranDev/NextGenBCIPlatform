// SecondaryButton.qaml  
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: secondaryButton
    height: 44
    radius: 10
    color: buttonMouseArea.containsMouse ? theme.backgroundLighter : theme.backgroundLight
    border.color: theme.border
    border.width: 1
    
    property string text: ""
    property string icon: ""
    signal clicked()
    
    RowLayout {
        anchors.centerIn: parent
        spacing: 8
        
        Text {
            text: secondaryButton.icon
            font.pixelSize: 16
            color: theme.textPrimary
        }
        
        Text {
            text: secondaryButton.text
            color: theme.textPrimary
            font.bold: true
            font.pixelSize: 14
        }
    }
    
    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: secondaryButton.clicked()
    }
}
