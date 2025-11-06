import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "../../common"
import "./components"

Rectangle {
    id: ssvepView
    
    property var config: ({})
    property var theme
    property bool isRunning: false
    property int currentStimulation: 0
    property int totalStimulations: 20
    property int activeFrequency: 0
    
    color: theme.backgroundPrimary
    
    RowLayout {
        anchors.fill: parent
        spacing: 0
        
        // Control Panel
        ControlPanel {
            accentColor: "#00BFA5"
            Layout.fillHeight: true
        }
        
        // Main Content
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            
            EnterpriseToolBar {
                title: "SSVEP Stimulation"
                subtitle: "Steady-State Visual Evoked Potential - Frequency-Based Control"
                accentColor: "#00BFA5"
                Layout.fillWidth: true
                
                onBackRequested: ssvepView.backRequested()
            }
            
            // Main Visualization Area
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: theme.backgroundPrimary
                
                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    columns: 2
                    rows: 2
                    columnSpacing: 20
                    rowSpacing: 20
                    
                    // SSVEP Stimulation Targets
                    Rectangle {
                        id: stimulationArea
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: theme.backgroundCard
                        radius: 12
                        
                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0
                            verticalOffset: 4
                            radius: 20
                            samples: 41
                            color: "#20000000"
                        }
                        
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 10
                            
                            Text {
                                text: "SSVEP Stimulation Targets"
                                color: theme.textPrimary
                                font.bold: true
                                font.pixelSize: 18
                                font.family: "Segoe UI"
                                Layout.alignment: Qt.AlignHCenter
                            }
                            
                            Grid {
                                columns: 2
                                spacing: 30
                                Layout.alignment: Qt.AlignCenter
                                
                                Repeater {
                                    model: config.frequencies || [8, 10, 12, 14]
                                    
                                    SSVEPTarget {
                                        width: 150
                                        height: 150
                                        frequency: modelData
                                        isActive: ssvepView.isRunning
                                        isFocused: ssvepView.activeFrequency === frequency
                                        stimulationDuration: config.stimulationDuration || 5
                                        
                                        onClicked: {
                                            console.log("SSVEP target clicked:", frequency + "Hz")
                                            ssvepView.activeFrequency = frequency
                                        }
                                    }
                                }
                            }
                            
                            // Stimulation Status
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 20
                                
                                StatItem {
                                    label: "Stimulation Progress"
                                    value: currentStimulation + "/" + totalStimulations
                                    progress: currentStimulation / totalStimulations
                                    color: "#00BFA5"
                                }
                                
                                StatItem {
                                    label: "Active Frequency"
                                    value: (activeFrequency || config.frequencies[0]) + " Hz"
                                    progress: 1.0
                                    color: "#7C4DFF"
                                }
                                
                                StatItem {
                                    label: "Detection Confidence"
                                    value: "85%"
                                    progress: 0.85
                                    color: "#FFD600"
                                }
                            }
                        }
                    }
                    
                    // Frequency Spectrum
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: theme.backgroundCard
                        radius: 12
                        
                        FrequencySpectrum {
                            anchors.fill: parent
                            anchors.margins: 10
                            frequencies: config.frequencies || [8, 10, 12, 14]
                            activeFrequency: ssvepView.activeFrequency
                            isRunning: ssvepView.isRunning
                        }
                    }
                    
                    // EEG Signal Visualization
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: theme.backgroundCard
                        radius: 12
                        
                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            
                            Text {
                                text: "Real-time EEG - Oz Channel"
                                color: theme.textPrimary
                                font.bold: true
                                font.pixelSize: 14
                                font.family: "Segoe UI"
                            }
                            
                            SSVEPSignalVisualizer {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                frequencies: config.frequencies || [8, 10, 12, 14]
                                isRunning: ssvepView.isRunning
                            }
                        }
                    }
                    
                    // Performance Metrics
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: theme.backgroundCard
                        radius: 12
                        
                        SSVEPPerformanceMetrics {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            accuracy: 0.87
                            detectionRate: 0.91
                            snr: 13.2
                            responseTime: 265
                            frequencyAccuracy: {
                                "8": 0.85,
                                "10": 0.92,
                                "12": 0.88,
                                "14": 0.83
                            }
                        }
                    }
                }
            }
        }
    }
    
    signal backRequested()
    
    function startExperiment() {
        isRunning = true
        stimulationTimer.start()
    }
    
    function stopExperiment() {
        isRunning = false
        stimulationTimer.stop()
    }
    
    Timer {
        id: stimulationTimer
        interval: (config.stimulationDuration || 5) * 1000
        running: false
        repeat: true
        onTriggered: {
            currentStimulation++
            if (currentStimulation >= totalStimulations) {
                stopExperiment()
            }
        }
    }
}

