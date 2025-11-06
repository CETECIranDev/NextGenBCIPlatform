import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: topBar
    
    property bool experimentRunning: false
    property string targetCharacter: "A"
    property real confidence: 0.87
    property int responseTime: 320
    
    height: 80
    color: "#1E1E2E"
    border.color: "#333344"
    border.width: 1
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        spacing: 20
        
        // Title and Status
        ColumnLayout {
            spacing: 2
            
            Text {
                text: "🧠 P300 SPELLER SYSTEM"
                color: "white"
                font.bold: true
                font.pixelSize: 18
                font.family: "Segoe UI"
            }
            
            Text {
                text: "Enterprise Brain-Computer Interface Platform"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.family: "Segoe UI"
            }
        }
        
        Item { Layout.fillWidth: true }
        
        // Live Metrics
        RowLayout {
            spacing: 15
            
            LiveMetric {
                label: "TARGET"
                value: targetCharacter
                color: "#7C4DFF"
                blinking: experimentRunning
                icon: "🎯"
            }
            
            LiveMetric {
                label: "CONFIDENCE"
                value: (confidence * 100).toFixed(0) + "%"
                color: confidence > 0.8 ? "#00C853" : "#FFA000"
                trend: confidence > 0.85 ? "up" : "down"
                icon: "📊"
            }
            
            LiveMetric {
                label: "RESPONSE TIME"
                value: responseTime + "ms"
                color: responseTime < 350 ? "#00C853" : "#FFA000"
                trend: responseTime < 300 ? "down" : "up"
                icon: "⚡"
            }
            
            LiveMetric {
                label: "STATUS"
                value: experimentRunning ? "ACTIVE" : "READY"
                color: experimentRunning ? "#00C853" : "#666677"
                icon: experimentRunning ? "🔴" : "🟢"
            }
        }
        
        // System Controls
        RowLayout {
            spacing: 8
            
            IndustrialIconButton {
                icon: "📁"
                tooltip: "Save Session"
                onClicked: console.log("Save session")
            }
            
            IndustrialIconButton {
                icon: "📊"
                tooltip: "Export Data"
                onClicked: console.log("Export data")
            }
            
            IndustrialIconButton {
                icon: "⚙️"
                tooltip: "System Settings"
                onClicked: console.log("Open settings")
            }
            
            IndustrialIconButton {
                icon: "❓"
                tooltip: "Help & Documentation"
                onClicked: console.log("Open help")
            }
        }
    }
    
    // Connection Status Bar
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 2
        color: experimentRunning ? "#00C853" : "#666677"
        
        SequentialAnimation on opacity {
            running: experimentRunning
            loops: Animation.Infinite
            NumberAnimation { from: 0.7; to: 1.0; duration: 1000 }
            NumberAnimation { from: 1.0; to: 0.7; duration: 1000 }
        }
    }
}
