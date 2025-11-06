// AdvancedMetricItem.qml
import QtQuick
import QtQuick.Layouts

Item {
    id: metricItem
    height: 40
    
    property string label: ""
    property string value: ""
    property string unit: ""
    property color color: theme.primary
    property string icon: ""
    property string trend: ""
    property color trendColor: "#4CAF50"
    property bool pulse: false
    
    RowLayout {
        anchors.fill: parent
        spacing: 8
        
        // Icon
        Text {
            text: metricItem.icon
            font.pixelSize: 14
            Layout.alignment: Qt.AlignVCenter
        }
        
        // Content
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            
            Text {
                text: metricItem.label
                color: theme.textSecondary
                font.pixelSize: 10
                Layout.fillWidth: true
            }
            
            RowLayout {
                spacing: 4
                
                Text {
                    text: metricItem.value
                    color: metricItem.color
                    font.bold: true
                    font.pixelSize: 12
                }
                
                Text {
                    text: metricItem.unit
                    color: theme.textTertiary
                    font.pixelSize: 9
                    visible: metricItem.unit !== ""
                }
                
                Text {
                    text: metricItem.trend
                    color: metricItem.trendColor
                    font.bold: true
                    font.pixelSize: 9
                    visible: metricItem.trend !== ""
                }
            }
        }
        
        // Pulse indicator
        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: metricItem.color
            visible: metricItem.pulse
            Layout.alignment: Qt.AlignVCenter
            
            SequentialAnimation on opacity {
                running: metricItem.pulse
                loops: Animation.Infinite
                NumberAnimation { to: 0.3; duration: 800; easing.type: Easing.InOutQuad }
                NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
            }
        }
    }
}