import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: settingItem
    
    property string label: ""
    property string value: ""
    
    spacing: 2
    
    Text {
        text: settingItem.label
        color: "#AAAAAA"
        font.pixelSize: 10
        font.family: "Segoe UI"
        Layout.fillWidth: true
    }
    
    Text {
        text: settingItem.value
        color: "white"
        font.bold: true
        font.pixelSize: 12
        font.family: "Segoe UI"
        Layout.fillWidth: true
    }
}