import QtQuick
import QtQuick.Layouts

Rectangle {
    id: performanceMetrics
    
    property real accuracy: 0.85
    property real detectionRate: 0.92
    property real snr: 12.5
    property int responseTime: 280
    property var frequencyAccuracy: ({
        "8": 0.88,
        "10": 0.92,
        "12": 0.85,
        "14": 0.81
    })
    
    color: "#1A1A2E"
    radius: 12
    border.color: "#333344"
    border.width: 2

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 10

        // Header
        Text {
            text: "SSVEP PERFORMANCE"
            color: "white"
            font.bold: true
            font.pixelSize: 14
            font.family: "Segoe UI"
        }

        // Main Metrics Grid
        GridLayout {
            columns: 2
            columnSpacing: 15
            rowSpacing: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            PerformanceMetric {
                label: "OVERALL ACCURACY"
                value: (accuracy * 100).toFixed(1)
                unit: "%"
                color: accuracy > 0.9 ? "#00C853" : "#FFA000"
                trend: accuracy > 0.85 ? "up" : "down"
                Layout.fillWidth: true
            }
            
            PerformanceMetric {
                label: "DETECTION RATE"
                value: (detectionRate * 100).toFixed(1)
                unit: "%"
                color: detectionRate > 0.9 ? "#00C853" : "#FFA000"
                trend: "up"
                Layout.fillWidth: true
            }
            
            PerformanceMetric {
                label: "AVG RESPONSE TIME"
                value: responseTime
                unit: "ms"
                color: responseTime < 300 ? "#00C853" : "#FFA000"
                trend: responseTime < 350 ? "down" : "up"
                Layout.fillWidth: true
            }
            
            PerformanceMetric {
                label: "SIGNAL QUALITY"
                value: snr.toFixed(1)
                unit: "dB"
                color: snr > 10 ? "#00C853" : "#FFA000"
                trend: "up"
                Layout.fillWidth: true
            }
        }

        // Frequency-wise Accuracy
        Rectangle {
            Layout.fillWidth: true
            height: 80
            radius: 6
            color: "#252540"
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5
                
                Text {
                    text: "FREQUENCY ACCURACY"
                    color: "#AAAAAA"
                    font.bold: true
                    font.pixelSize: 11
                    font.family: "Segoe UI"
                }
                
                RowLayout {
                    spacing: 8
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    Repeater {
                        model: ["8", "10", "12", "14"]
                        
                        FrequencyAccuracy {
                            frequency: modelData + " Hz"
                            accuracy: frequencyAccuracy[modelData] || 0
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }

        // Performance Summary
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            SummaryItem {
                label: "TOTAL TRIALS"
                value: "156"
                Layout.fillWidth: true
            }
            
            SummaryItem {
                label: "SUCCESS RATE"
                value: "92%"
                Layout.fillWidth: true
            }
            
            SummaryItem {
                label: "AVG CONFIDENCE"
                value: "88%"
                Layout.fillWidth: true
            }
        }
    }
}