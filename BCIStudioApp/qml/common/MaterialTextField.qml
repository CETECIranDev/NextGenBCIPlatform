import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: textField
    
    property string label: ""
    property string text: ""
    property string placeholderText: ""
    property color accentColor: theme.primary
    
    spacing: 4
    
    Text {
        text: label
        color: theme.textSecondary
        font.pixelSize: 12
        font.bold: true
    }
    
    Rectangle {
        Layout.fillWidth: true
        height: 48
        radius: 8
        color: theme.backgroundLight
        border.color: textField.activeFocus ? accentColor : theme.border
        border.width: 2
        
        TextInput {
            id: input
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            verticalAlignment: Text.AlignVCenter
            text: textField.text
            font.pixelSize: 16
            color: theme.textPrimary
            
            onTextChanged: textField.text = text
            
            Text {
                text: placeholderText
                color: theme.textTertiary
                font.pixelSize: 16
                visible: !input.text && !input.activeFocus
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}