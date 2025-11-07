import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: widgetCard
    height: 120
    radius: 12
    color: theme.backgroundLight
    border.color: theme.border
    border.width: 1
    
    property var widgetData: ({})
    signal addClicked()
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8
        
        // Header
        RowLayout {
            spacing: 12
            Layout.fillWidth: true
            
            // Icon
            Rectangle {
                width: 40
                height: 40
                radius: 10
                color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)
                border.color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.3)
                border.width: 1
                
                Text {
                    anchors.centerIn: parent
                    text: widgetData.icon
                    font.pixelSize: 18
                    color: theme.primary
                }
            }
            
            // Info
            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true
                
                Text {
                    text: widgetData.name
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 14
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                
                Text {
                    text: widgetData.description
                    color: theme.textSecondary
                    font.pixelSize: 11
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }
        }
        
        // Footer
        RowLayout {
            spacing: 8
            Layout.fillWidth: true
            
            // Category Tag
            Rectangle {
                height: 20
                radius: 10
                color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)
                
                Text {
                    anchors.centerIn: parent
                    text: getCategoryName(widgetData.category)
                    color: theme.primary
                    font.bold: true
                    font.pixelSize: 9
                    padding: 6
                }
            }
            
            Item { Layout.fillWidth: true }
            
            // Add Button
            Rectangle {
                width: 32
                height: 32
                radius: 8
                color: addMouseArea.containsMouse ? theme.primary : Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)
                border.color: theme.primary
                border.width: 1
                
                Text {
                    anchors.centerIn: parent
                    text: "➕"
                    font.pixelSize: 14
                    color: addMouseArea.containsMouse ? "white" : theme.primary
                }
                
                MouseArea {
                    id: addMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        addClicked()
                        scaleAnimation.start()
                    }
                }
                
                SequentialAnimation on scale {
                    id: scaleAnimation
                    NumberAnimation { to: 0.8; duration: 100 }
                    NumberAnimation { to: 1.0; duration: 200; easing.type: Easing.OutBack }
                }
            }
        }
    }
    
    function getCategoryName(category) {
        var names = {
            "visualization": "Chart",
            "analysis": "Analysis", 
            "monitoring": "Monitor",
            "system": "System",
            "output": "Output"
        }
        return names[category] || category
    }
}