import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: liveMetric
    
    property string label: ""
    property string value: ""
    // property color color: "#7C4DFF"
    property string trend: "neutral"
    property string icon: ""
    property bool blinking: false
    
    width: 120
    height: 50
    radius: 6
    color: "#252540"
    border.color: liveMetric.color
    border.width: 1
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8
        
        Text {
            text: liveMetric.icon
            font.pixelSize: 14
        }
        
        ColumnLayout {
            spacing: 2
            
            Text {
                text: liveMetric.label
                color: "#AAAAAA"
                font.pixelSize: 9
                font.bold: true
                font.family: "Segoe UI"
            }
            
            RowLayout {
                spacing: 4
                
                Text {
                    text: liveMetric.value
                    color: liveMetric.color
                    font.bold: true
                    font.pixelSize: 12
                    font.family: "Segoe UI"
                    
                    SequentialAnimation on opacity {
                        running: liveMetric.blinking
                        loops: Animation.Infinite
                        NumberAnimation { from: 0.7; to: 1.0; duration: 500 }
                        NumberAnimation { from: 1.0; to: 0.7; duration: 500 }
                    }
                }
                
                Text {
                    text: {
                        if (liveMetric.trend === "up") return "↗"
                        if (liveMetric.trend === "down") return "↘"
                        return "•"
                    }
                    color: {
                        if (liveMetric.trend === "up") return "#00C853"
                        if (liveMetric.trend === "down") return "#FFA000"
                        return "#666677"
                    }
                    font.pixelSize: 10
                    visible: liveMetric.trend !== "neutral"
                }
            }
        }
    }
}
