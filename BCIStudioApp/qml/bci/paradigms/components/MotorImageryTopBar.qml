import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: topBar
    
    property bool experimentRunning: false
    property string currentCue: "Rest"
    property string predictedClass: "Left Hand"
    property real confidence: 0.82
    
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
                text: "💪 MOTOR IMAGERY SYSTEM"
                color: "white"
                font.bold: true
                font.pixelSize: 18
                font.family: "Segoe UI"
            }
            
            Text {
                text: "Motor Cortex Activation & Classification"
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
                label: "CURRENT CUE"
                value: currentCue
                color: getCueColor(currentCue)
                blinking: experimentRunning && currentCue !== "Rest"
                icon: "🎯"
            }
            
            LiveMetric {
                label: "PREDICTED"
                value: predictedClass
                color: getCueColor(predictedClass)
                icon: "🔮"
            }
            
            LiveMetric {
                label: "CONFIDENCE"
                value: (confidence * 100).toFixed(0) + "%"
                color: confidence > 0.8 ? "#00C853" : "#FFA000"
                trend: confidence > 0.85 ? "up" : "down"
                icon: "📊"
            }
            
            LiveMetric {
                label: "STATUS"
                value: experimentRunning ? "ACTIVE" : "READY"
                color: experimentRunning ? "#00C853" : "#666677"
                icon: experimentRunning ? "🔴" : "🟢"
            }
        }
    }
    
    function getCueColor(cue) {
        switch(cue) {
            case "Left Hand": return "#2196F3"
            case "Right Hand": return "#4CAF50"
            case "Both Hands": return "#FF9800"
            case "Feet": return "#9C27B0"
            case "Tongue": return "#E91E63"
            case "Rest": return "#666677"
            default: return "#AAAAAA"
        }
    }
}