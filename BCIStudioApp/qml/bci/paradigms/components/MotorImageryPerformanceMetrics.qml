import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects  // برای Qt 6

Rectangle {
    id: performanceMetrics
    color: Material.background
    radius: 12
    border.color: Material.accent
    border.width: 1
    
    property var confusionMatrix: [
        [15, 2, 1, 0],
        [1, 16, 1, 0],
        [2, 1, 14, 1],
        [0, 0, 2, 16]
    ]
    property var classes: ["Left Hand", "Right Hand", "Both Hands", "Both Feet"]
    property real accuracy: 0.85
    property real kappa: 0.79
    property var f1Scores: [0.88, 0.86, 0.82, 0.84]
    property var learningCurve: [0.45, 0.58, 0.65, 0.72, 0.78, 0.82, 0.85]
    
    signal metricsUpdated(var newMetrics)
    
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 2
        verticalOffset: 2
        radius: 8
        samples: 17
        color: "#20000000"
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12
        
        // Header
        Text {
            text: "📊 Performance Metrics"
            font.pixelSize: 20
            font.bold: true
            color: Material.foreground
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Overall Metrics
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            MetricCard {
                title: "🎯 Accuracy"
                value: (accuracy * 100).toFixed(1) + "%"
                color: Material.Green
                Layout.fillWidth: true
            }
            
            MetricCard {
                title: "📈 Kappa"
                value: kappa.toFixed(3)
                color: Material.Blue
                Layout.fillWidth: true
            }
            
            MetricCard {
                title: "⚡ F1 Score"
                value: (f1Scores.reduce((a, b) => a + b, 0) / f1Scores.length).toFixed(3)
                color: Material.Purple
                Layout.fillWidth: true
            }
        }
        
        // Confusion Matrix
        GroupBox {
            title: "🔄 Confusion Matrix"
            Layout.fillWidth: true
            Layout.preferredHeight: 200
            
            background: Rectangle {
                color: Material.background
                radius: 6
                border.color: Material.accent
            }
            
            GridLayout {
                columns: classes.length + 1
                rowSpacing: 5
                columnSpacing: 5
                anchors.fill: parent
                anchors.margins: 5
                
                // Header row
                Repeater {
                    model: ["Predicted →"].concat(classes)
                    
                    delegate: Text {
                        text: modelData
                        color: Material.foreground
                        font.bold: true
                        font.pixelSize: 10
                        Layout.alignment: Qt.AlignCenter
                    }
                }
                
                // Matrix rows
                Repeater {
                    model: classes.length
                    
                    delegate: Row {
                        property int rowIndex: index
                        
                        // True class label
                        Text {
                            text: classes[rowIndex]
                            color: Material.foreground
                            font.bold: true
                            font.pixelSize: 10
                            width: 60
                            horizontalAlignment: Text.AlignRight
                        }
                        
                        // Matrix cells
                        Repeater {
                            model: classes.length
                            
                            delegate: Rectangle {
                                width: 40
                                height: 25
                                color: getCellColor(rowIndex, index)
                                radius: 3
                                border.color: Material.background
                                
                                Text {
                                    text: confusionMatrix[rowIndex][index]
                                    color: "white"
                                    font.bold: true
                                    font.pixelSize: 10
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Learning Curve and F1 Scores
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            
            // Learning Curve
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: Material.background
                radius: 8
                border.color: Material.accent
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    
                    Text {
                        text: "📈 Learning Curve"
                        color: Material.foreground
                        font.bold: true
                        font.pixelSize: 12
                    }
                    
                    ChartView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        theme: ChartView.ChartThemeLight
                        antialiasing: true
                        
                        LineSeries {
                            name: "Accuracy"
                            axisX: ValueAxis {
                                min: 1
                                max: learningCurve.length
                                tickCount: 6
                                labelFormat: "%d"
                            }
                            axisY: ValueAxis {
                                min: 0
                                max: 1
                                tickCount: 6
                                labelFormat: "%.2f"
                            }
                            
                            XYPoint { x: 1; y: learningCurve[0] }
                            XYPoint { x: 2; y: learningCurve[1] }
                            XYPoint { x: 3; y: learningCurve[2] }
                            XYPoint { x: 4; y: learningCurve[3] }
                            XYPoint { x: 5; y: learningCurve[4] }
                            XYPoint { x: 6; y: learningCurve[5] }
                            XYPoint { x: 7; y: learningCurve[6] }
                        }
                    }
                }
            }
            
            // F1 Scores per Class
            Rectangle {
                Layout.preferredWidth: 150
                Layout.fillHeight: true
                color: Material.background
                radius: 8
                border.color: Material.accent
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    
                    Text {
                        text: "🎯 F1 Scores"
                        color: Material.foreground
                        font.bold: true
                        font.pixelSize: 12
                    }
                    
                    Repeater {
                        model: classes
                        
                        delegate: RowLayout {
                            Layout.fillWidth: true
                            
                            Text {
                                text: modelData
                                color: Material.foreground
                                font.pixelSize: 10
                                Layout.fillWidth: true
                            }
                            
                            Text {
                                text: (f1Scores[index] * 100).toFixed(1) + "%"
                                color: getScoreColor(f1Scores[index])
                                font.bold: true
                                font.pixelSize: 10
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Component for Metric Cards
    component MetricCard: Rectangle {
        property string title: ""
        property string value: ""
        //property color color: Material.blue
        
        height: 80
        radius: 8
        color: parent.color
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 5
            
            Text {
                text: parent.title
                color: "white"
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: parent.value
                color: "white"
                font.pixelSize: 18
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
    
    // Functions
    function getCellColor(row, col) {
        var value = confusionMatrix[row][col]
        var maxVal = Math.max(...confusionMatrix.flat())
        var intensity = value / maxVal
        
        if (row === col) {
            // Diagonal - correct classifications
            return Qt.rgba(0.2, 0.7, 0.3, 0.3 + intensity * 0.7)
        } else {
            // Off-diagonal - errors
            return Qt.rgba(0.9, 0.3, 0.3, 0.1 + intensity * 0.6)
        }
    }
    
    function getScoreColor(score) {
        if (score >= 0.9) return Material.Green
        if (score >= 0.7) return Material.Orange
        return Material.Red
    }
    
    function updateMetrics(newMetrics) {
        if (newMetrics.confusionMatrix) confusionMatrix = newMetrics.confusionMatrix
        if (newMetrics.accuracy) accuracy = newMetrics.accuracy
        if (newMetrics.kappa) kappa = newMetrics.kappa
        if (newMetrics.f1Scores) f1Scores = newMetrics.f1Scores
        if (newMetrics.learningCurve) learningCurve = newMetrics.learningCurve
        
        metricsUpdated(newMetrics)
    }
    
    function resetMetrics() {
        confusionMatrix = Array(classes.length).fill().map(() => Array(classes.length).fill(0))
        accuracy = 0
        kappa = 0
        f1Scores = Array(classes.length).fill(0)
        learningCurve = []
    }
    
    Component.onCompleted: {
        console.log("Performance Metrics initialized")
    }
}
