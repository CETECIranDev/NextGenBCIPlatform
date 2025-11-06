import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// Control Section Component
Rectangle {
    id: controlSection
    
    property string title: ""
    property string icon: ""
    
    Layout.fillWidth: true
    implicitHeight: content.height + 20
    color: theme.backgroundCard
    radius: 8
    
    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        RowLayout {
            spacing: 8
            
            Text {
                text: controlSection.icon
                font.pixelSize: 14
            }
            
            Text {
                text: controlSection.title
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 14
                Layout.fillWidth: true
            }
        }
        
        // Content placeholder
        Item {
            Layout.fillWidth: true
            implicitHeight: childrenRect.height
        }
    }
}