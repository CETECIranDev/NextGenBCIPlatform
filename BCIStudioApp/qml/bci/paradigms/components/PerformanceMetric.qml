import QtQuick
import QtQuick.Layouts

Rectangle {
    id: performanceMetric
    
    property string label: ""
    property string value: ""
    property string unit: ""
    property color metricColor: "#00C853"  // تغییر نام از color به metricColor
    property string trend: "neutral" // "up", "down", "neutral"
    
    height: 70
    radius: 8
    color: "#252540"
    border.color: "#333344"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 4
        
        Text {
            text: performanceMetric.label
            color: "#AAAAAA"
            font.pixelSize: 10
            font.family: "Segoe UI"
            Layout.fillWidth: true
        }
        
        RowLayout {
            spacing: 4
            
            Text {
                text: performanceMetric.value
                color: performanceMetric.metricColor
                font.bold: true
                font.pixelSize: 18
                font.family: "Segoe UI"
            }
            
            Text {
                text: performanceMetric.unit
                color: "#666677"
                font.pixelSize: 12
                font.family: "Segoe UI"
            }
            
            // Trend indicator
            Text {
                text: {
                    if (performanceMetric.trend === "up") return "↗"
                    if (performanceMetric.trend === "down") return "↘"
                    return "•"
                }
                color: {
                    if (performanceMetric.trend === "up") return "#00C853"
                    if (performanceMetric.trend === "down") return "#FF5252"
                    return "#666677"
                }
                font.pixelSize: 14
                font.bold: true
            }
        }
        
        // Progress bar
        Rectangle {
            Layout.fillWidth: true
            height: 4
            radius: 2
            color: "#333344"
            
            Rectangle {
                width: {
                    var numericValue = parseFloat(performanceMetric.value)
                    if (performanceMetric.unit === "%") {
                        return parent.width * (numericValue / 100)
                    } else if (performanceMetric.unit === "ms") {
                        return parent.width * (1 - numericValue / 500) // inverse for response time
                    } else if (performanceMetric.unit === "dB") {
                        return parent.width * (numericValue / 20) // assuming 20dB max
                    }
                    return parent.width * 0.8
                }
                height: parent.height
                radius: 2
                color: performanceMetric.metricColor
            }
        }
    }
}
