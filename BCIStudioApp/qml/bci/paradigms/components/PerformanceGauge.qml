import QtQuick
import QtQuick.Layouts
// Performance Gauge Component
Rectangle {
    id: performanceGauge
    
    property string label: ""
    property real value: 0
    property real maxValue: 100
    //property color color: "#7C4DFF"
    property string trend: "neutral"
    property string suffix: "%"
    
    radius: 8
    color: "#252540"
    border.color: "#333344"
    border.width: 1
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 4
        
        Text {
            text: performanceGauge.label
            color: "#AAAAAA"
            font.pixelSize: 9
            font.bold: true
            font.family: "Segoe UI"
            Layout.fillWidth: true
        }
        
        RowLayout {
            spacing: 6
            
            Text {
                text: performanceGauge.value.toFixed(0) + performanceGauge.suffix
                color: performanceGauge.color
                font.bold: true
                font.pixelSize: 18
                font.family: "Segoe UI"
            }
            
            Text {
                text: {
                    if (performanceGauge.trend === "up") return "↗"
                    if (performanceGauge.trend === "down") return "↘"
                    return "•"
                }
                color: {
                    if (performanceGauge.trend === "up") return "#00C853"
                    if (performanceGauge.trend === "down") return "#FFA000"
                    return "#666677"
                }
                font.pixelSize: 14
            }
        }
        
        // Progress bar
        Rectangle {
            Layout.fillWidth: true
            height: 6
            radius: 3
            color: "#333344"
            
            Rectangle {
                width: parent.width * (performanceGauge.value / performanceGauge.maxValue)
                height: parent.height
                radius: 3
                color: performanceGauge.color
                
                Behavior on width {
                    NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                }
            }
        }
        
        Text {
            text: Math.floor((performanceGauge.value / performanceGauge.maxValue) * 100) + "%"
            color: "#666677"
            font.pixelSize: 8
            font.family: "Segoe UI"
            Layout.alignment: Qt.AlignRight
        }
    }
}
