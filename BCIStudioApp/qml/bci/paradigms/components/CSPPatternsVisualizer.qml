import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15
import QtQuick.Layouts

Rectangle {
    id: cspVisualizer
    color: "#1E1E1E"
    
    property var cspPatterns: []
    property var cspFilters: []
    property var classMeans: []
    property var classVariances: []
    property int currentComponent: 0
    property int totalComponents: 6
    
    signal componentSelected(int component)
    signal patternUpdated(var patterns)
    
    GridLayout {
        anchors.fill: parent
        anchors.margins: 10
        columns: 2
        rowSpacing: 10
        columnSpacing: 10
        
        // CSP Patterns Heatmap
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#2D2D2D"
            radius: 8
            border.color: "#444"
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                
                Text {
                    text: "🧩 CSP Patterns - Component " + (currentComponent + 1)
                    color: "white"
                    font.bold: true
                    font.pixelSize: 14
                    Layout.alignment: Qt.AlignHCenter
                }
                
                Grid {
                    id: patternGrid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    columns: 3
                    spacing: 5
                    
                    Repeater {
                        model: 9 // 3x3 grid for demonstration
                        
                        delegate: Rectangle {
                            width: (patternGrid.width - 20) / 3
                            height: (patternGrid.height - 20) / 3
                            color: getPatternColor(index)
                            radius: 4
                            border.color: "#666"
                            
                            Text {
                                anchors.centerIn: parent
                                text: getPatternValue(index).toFixed(2)
                                color: Math.abs(getPatternValue(index)) > 0.5 ? "white" : "black"
                                font.pixelSize: 10
                                font.bold: true
                            }
                        }
                    }
                }
            }
        }
        
        // Component Selection and Info
        ColumnLayout {
            Layout.preferredWidth: 200
            Layout.fillHeight: true
            spacing: 10
            
            // Component Selector
            Rectangle {
                Layout.fillWidth: true
                height: 120
                color: "#2D2D2D"
                radius: 8
                border.color: "#444"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    
                    Text {
                        text: "📊 Components"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 12
                    }
                    
                    GridLayout {
                        columns: 3
                        rowSpacing: 5
                        columnSpacing: 5
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        Repeater {
                            model: totalComponents
                            
                            delegate: Button {
                                text: (index + 1).toString()
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                highlighted: currentComponent === index
                                
                                background: Rectangle {
                                    color: parent.highlighted ? "#4ECDC4" : "#444"
                                    radius: 4
                                }
                                
                                onClicked: {
                                    currentComponent = index
                                    componentSelected(index)
                                }
                            }
                        }
                    }
                }
            }
            
            // Variance Information
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#2D2D2D"
                radius: 8
                border.color: "#444"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    
                    Text {
                        text: "📈 Variance Explained"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 12
                    }
                    
                    ChartView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        theme: ChartView.ChartThemeDark
                        antialiasing: true
                        
                        BarSeries {
                            id: varianceSeries
                            axisX: BarCategoryAxis {
                                categories: ["Comp 1", "Comp 2", "Comp 3", "Comp 4", "Comp 5", "Comp 6"]
                            }
                            axisY: ValueAxis {
                                min: 0
                                max: 100
                                tickCount: 6
                                labelFormat: "%.0f%%"
                            }
                            
                            BarSet {
                                label: "Variance"
                                values: [45, 25, 15, 8, 4, 3]
                                color: "#4ECDC4"
                            }
                        }
                    }
                }
            }
            
            // Class Separation
            Rectangle {
                Layout.fillWidth: true
                height: 100
                color: "#2D2D2D"
                radius: 8
                border.color: "#444"
                
                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    
                    Text {
                        text: "🎯 Class Separation"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 12
                    }
                    
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "transparent"
                            
                            Text {
                                text: "Left vs Right:\n85%"
                                color: "#4ECDC4"
                                font.bold: true
                                font.pixelSize: 16
                                anchors.centerIn: parent
                            }
                        }
                        
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            color: "transparent"
                            
                            Text {
                                text: "Hands vs Feet:\n78%"
                                color: "#FF6B6B"
                                font.bold: true
                                font.pixelSize: 16
                                anchors.centerIn: parent
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Functions
    function getPatternColor(index) {
        var value = getPatternValue(index)
        var intensity = Math.min(Math.abs(value) * 2, 1.0)
        
        if (value > 0) {
            return Qt.rgba(0.3, 0.8, 0.6, intensity) // Green for positive
        } else {
            return Qt.rgba(0.9, 0.4, 0.4, intensity) // Red for negative
        }
    }
    
    function getPatternValue(index) {
        // Simulate CSP pattern values
        var basePattern = [0.8, -0.6, 0.4, -0.3, 0.2, -0.1, 0.1, -0.05, 0.02]
        return basePattern[index] * (1 + currentComponent * 0.1)
    }
    
    function updatePatterns(newPatterns) {
        cspPatterns = newPatterns
        patternUpdated(newPatterns)
    }
    
    function updateFilters(newFilters) {
        cspFilters = newFilters
    }
    
    function calculateVariance() {
        // Simulate variance calculation
        return [45, 25, 15, 8, 4, 3]
    }
    
    Component.onCompleted: {
        console.log("CSP Patterns Visualizer initialized")
        updatePatterns([])
    }
}
