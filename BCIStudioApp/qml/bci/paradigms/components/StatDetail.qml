import QtQuick
import QtQuick.Layouts

// Stat Detail Component

ColumnLayout {
    id: statDetail
    
    property string label: ""
    property string value: ""
    property string subtext: ""
    
    spacing: 2
    
    Text {
        text: statDetail.label
        color: "#666677"
        font.pixelSize: 8
        font.bold: true
        font.family: "Segoe UI"
        Layout.fillWidth: true
    }
    
    Text {
        text: statDetail.value
        color: "white"
        font.bold: true
        font.pixelSize: 14
        font.family: "Segoe UI"
        Layout.fillWidth: true
    }
    
    Text {
        text: statDetail.subtext
        color: "#666677"
        font.pixelSize: 8
        font.family: "Segoe UI"
        Layout.fillWidth: true
    }
}