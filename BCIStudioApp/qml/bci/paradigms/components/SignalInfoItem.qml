import QtQuick
import QtQuick.Layouts

Rectangle {
    id: signalInfoItem
    
    property string label: ""
    property string value: ""
    property string unit: ""
    property color indicatorColor: "#7C4DFF"  // تغییر نام از color به indicatorColor
    property string trend: "neutral" // "up", "down", "neutral"
    property bool showTrend: false
    
    height: 60
    radius: 8
    color: "#252540"
    border.color: "#333344"
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10
        
        // Status Indicator
        Rectangle {
            width: 4
            height: 20
            radius: 2
            color: signalInfoItem.indicatorColor
        }
        
        // Content
        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true
            
            Text {
                text: signalInfoItem.label
                color: "#AAAAAA"
                font.pixelSize: 11
                font.family: "Segoe UI"
                Layout.fillWidth: true
            }
            
            RowLayout {
                spacing: 4
                
                Text {
                    text: signalInfoItem.value
                    color: "white"
                    font.bold: true
                    font.pixelSize: 16
                    font.family: "Segoe UI"
                }
                
                Text {
                    text: signalInfoItem.unit
                    color: "#666677"
                    font.pixelSize: 12
                    font.family: "Segoe UI"
                    visible: signalInfoItem.unit !== ""
                }
                
                // Trend Indicator
                Text {
                    text: {
                        if (signalInfoItem.trend === "up") return "↗"
                        if (signalInfoItem.trend === "down") return "↘"
                        return "•"
                    }
                    color: {
                        if (signalInfoItem.trend === "up") return "#00C853"
                        if (signalInfoItem.trend === "down") return "#FF5252"
                        return "#666677"
                    }
                    font.pixelSize: 14
                    font.bold: true
                    visible: signalInfoItem.showTrend
                }
            }
        }
    }
}
