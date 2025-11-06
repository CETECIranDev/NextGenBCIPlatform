import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: systemInfoItem
    
    property string label: ""
    property string value: ""
    property color color: "#7C4DFF"
    
    spacing: 2
    
    Text {
        text: systemInfoItem.label
        color: "#AAAAAA"
        font.pixelSize: 9
        font.family: "Segoe UI"
        Layout.fillWidth: true
    }
    
    RowLayout {
        spacing: 6
        Layout.fillWidth: true
        
        Rectangle {
            width: 6
            height: 6
            radius: 3
            color: systemInfoItem.color
        }
        
        Text {
            text: systemInfoItem.value
            color: systemInfoItem.color
            font.bold: true
            font.pixelSize: 11
            font.family: "Segoe UI"
            Layout.fillWidth: true
        }
    }
}