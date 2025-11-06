// InfoItem.qml
import QtQuick
import QtQuick.Layouts

Item {
    id: infoItem
    height: 30
    property string label: ""
    property string value: ""
    property string icon: ""
    
    RowLayout {
        anchors.fill: parent
        spacing: 8
        
        Text {
            text: infoItem.icon
            font.pixelSize: 12
            Layout.alignment: Qt.AlignVCenter
        }
        
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            
            Text {
                text: infoItem.label
                color: theme.textSecondary
                font.pixelSize: 10
                Layout.fillWidth: true
            }
            
            Text {
                text: infoItem.value
                color: theme.textPrimary
                font.pixelSize: 11
                font.bold: true
                Layout.fillWidth: true
                elide: Text.ElideRight
            }
        }
    }
}