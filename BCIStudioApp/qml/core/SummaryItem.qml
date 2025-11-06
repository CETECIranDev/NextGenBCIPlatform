// کامپوننت Summary Item
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    id: summaryItem
    
    property string label: ""
    property string value: ""
    
    RowLayout {
        width: parent.width
        
        Text {
            text: label + ":"
            font.family: robotoBold.name
            font.pixelSize: 14
            color: "#AAAAAA"
            Layout.preferredWidth: 120
        }
        
        Text {
            text: value
            font.family: robotoRegular.name
            font.pixelSize: 14
            color: "white"
            Layout.fillWidth: true
            wrapMode: Text.Wrap
        }
    }
}
