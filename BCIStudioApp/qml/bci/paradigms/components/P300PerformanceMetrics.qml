import QtQuick
import QtQuick.Layouts

Rectangle {
    id: performanceMetrics
    
    property real accuracy: 0.92
    property real confidence: 0.87
    property int responseTime: 320
    
    color: "#1A1A2E"
    radius: 12
    border.color: "#333344"
    border.width: 2
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 8

        Text {
            text: "PERFORMANCE ANALYTICS"
            color: "white"
            font.bold: true
            font.pixelSize: 12
            font.family: "Segoe UI"
        }

        // Main Metrics Grid
        GridLayout {
            columns: 2
            columnSpacing: 12
            rowSpacing: 12
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            PerformanceGauge {
                label: "CLASSIFICATION ACCURACY"
                value: accuracy * 100
                maxValue: 100
                color: getAccuracyColor(accuracy)
                trend: accuracy > 0.9 ? "up" : "down"
                Layout.fillWidth: true
                Layout.preferredHeight: 80
            }
            
            PerformanceGauge {
                label: "DETECTION CONFIDENCE"
                value: confidence * 100
                maxValue: 100
                color: getConfidenceColor(confidence)
                trend: confidence > 0.85 ? "up" : "down"
                Layout.fillWidth: true
                Layout.preferredHeight: 80
            }
            
            PerformanceGauge {
                label: "AVG RESPONSE TIME"
                value: responseTime
                maxValue: 500
                color: getResponseTimeColor(responseTime)
                trend: responseTime < 350 ? "down" : "up"
                suffix: "ms"
                Layout.fillWidth: true
                Layout.preferredHeight: 80
            }
            
            PerformanceGauge {
                label: "SIGNAL QUALITY INDEX"
                value: 88
                maxValue: 100
                color: "#00BFA5"
                trend: "up"
                suffix: "%"
                Layout.fillWidth: true
                Layout.preferredHeight: 80
            }
        }

        // Detailed Statistics
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: "#252540"
            radius: 6
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 15
                
                StatDetail {
                    label: "TRIALS COMPLETED"
                    value: "45"
                    subtext: "of 120"
                    Layout.fillWidth: true
                }
                
                StatDetail {
                    label: "SUCCESS RATE"
                    value: "92%"
                    subtext: "Last 10 trials"
                    Layout.fillWidth: true
                }
                
                StatDetail {
                    label: "AVG LATENCY"
                    value: "312ms"
                    subtext: "P300 peak"
                    Layout.fillWidth: true
                }
                
                StatDetail {
                    label: "NOISE RATIO"
                    value: "2.3"
                    subtext: "SNR: 26.1dB"
                    Layout.fillWidth: true
                }
            }
        }
    }
    
    function getAccuracyColor(accuracy) {
        if (accuracy > 0.9) return "#00C853"
        if (accuracy > 0.8) return "#FFA000"
        return "#F44336"
    }
    
    function getConfidenceColor(confidence) {
        if (confidence > 0.85) return "#7C4DFF"
        if (confidence > 0.75) return "#FFA000"
        return "#F44336"
    }
    
    function getResponseTimeColor(time) {
        if (time < 300) return "#00C853"
        if (time < 400) return "#FFA000"
        return "#F44336"
    }
}



