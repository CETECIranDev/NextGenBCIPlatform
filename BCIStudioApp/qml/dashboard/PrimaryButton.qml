// PrimaryButton.qaml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: primaryButton
    height: 44
    radius: 10
    color: buttonMouseArea.containsMouse ? Qt.lighter(theme.primary, 1.1) : theme.primary
    border.color: Qt.darker(theme.primary, 1.1)
    border.width: 1
    
    property string text: ""
    property string icon: ""
    signal clicked()
    
    RowLayout {
        anchors.centerIn: parent
        spacing: 8
        
        Text {
            text: primaryButton.icon
            font.pixelSize: 16
            color: "white"
        }
        
        Text {
            text: primaryButton.text
            color: "white"
            font.bold: true
            font.pixelSize: 14
        }
    }
    
    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: primaryButton.clicked()
    }
}

