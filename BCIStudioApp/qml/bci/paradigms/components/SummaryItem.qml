import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: summaryItem
    
    property string label: ""
    property string value: ""
    
    spacing: 2
    
    Text {
        text: summaryItem.label
        color: "#666677"
        font.pixelSize: 9
        font.family: "Segoe UI"
        Layout.alignment: Qt.AlignHCenter
    }
    
    Text {
        text: summaryItem.value
        color: "white"
        font.bold: true
        font.pixelSize: 12
        font.family: "Segoe UI"
        Layout.alignment: Qt.AlignHCenter
    }
}