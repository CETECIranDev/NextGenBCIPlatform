import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCharts
import "../../common"
import "./components"

Rectangle {
    id: motorImageryView
    
    property var config: ({
        trialDuration: 4,
        restDuration: 2,
        numTrials: 40,
        cueType: 0,
        classes: ["Left Hand", "Right Hand", "Both Hands", "Feet"],
        realtimeFeedback: true,
        visualFeedback: true,
        auditoryFeedback: false
    })
    property var theme
    property bool experimentRunning: false
    property int currentTrial: 0
    property int totalTrials: 40
    property string currentCue: "Rest"
    property real accuracy: 0.88
    property real confidence: 0.82
    property string predictedClass: "Left Hand"
    property real motorCortexActivation: 0.75
    
    color: "#0F0F1A"

    // Background pattern
    Canvas {
        anchors.fill: parent
        opacity: 0.02
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.strokeStyle = "#FF6D00"
            ctx.lineWidth = 0.5
            
            // Draw neural network pattern
            for (var x = 0; x < width; x += 60) {
                for (var y = 0; y < height; y += 60) {
                    ctx.beginPath()
                    ctx.arc(x, y, 2, 0, Math.PI * 2)
                    ctx.stroke()
                    
                    // Draw connections
                    if (x < width - 60 && y < height - 60) {
                        ctx.beginPath()
                        ctx.moveTo(x, y)
                        ctx.lineTo(x + 60, y + 60)
                        ctx.stroke()
                    }
                }
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        // Left Sidebar - Control Panel
        MotorImageryControlPanel {
            id: controlPanel
            Layout.preferredWidth: 320
            Layout.fillHeight: true
            experimentRunning: motorImageryView.experimentRunning
            currentTrial: motorImageryView.currentTrial
            totalTrials: motorImageryView.totalTrials
            accuracy: motorImageryView.accuracy
            currentCue: motorImageryView.currentCue
            onStartExperiment: motorImageryView.startExperiment()
            onPauseExperiment: motorImageryView.pauseExperiment()
            onStopExperiment: motorImageryView.stopExperiment()
            onBackRequested: motorImageryView.backRequested()
        }

        // Main Content Area
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Top Bar
            MotorImageryTopBar {
                Layout.fillWidth: true
                experimentRunning: motorImageryView.experimentRunning
                currentCue: motorImageryView.currentCue
                predictedClass: motorImageryView.predictedClass
                confidence: motorImageryView.confidence
            }

            // Main Visualization Area
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 20

                    // Left Column - Cue Visualization and Brain Map
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 20

                        // Cue Visualization
                        CueVisualization {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 300
                            currentCue: motorImageryView.currentCue
                            experimentRunning: motorImageryView.experimentRunning
                            trialProgress: motorImageryView.currentTrial / motorImageryView.totalTrials
                        }

                        // Motor Cortex Activation Map
                        BrainActivationMap {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            predictedClass: motorImageryView.predictedClass
                            activationLevel: motorImageryView.motorCortexActivation
                            experimentRunning: motorImageryView.experimentRunning
                        }
                    }

                    // Right Column - Real-time Data and Analytics
                    ColumnLayout {
                        Layout.preferredWidth: 500
                        Layout.fillHeight: true
                        spacing: 20

                        // EEG Signal Visualization
                        MotorImageryEEGVisualizer {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 200
                            experimentRunning: motorImageryView.experimentRunning
                            predictedClass: motorImageryView.predictedClass
                        }

                        // CSP Patterns Visualization
                        CSPPatternsVisualizer {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 200
                            //experimentRunning: motorImageryView.experimentRunning
                        }

                        // Performance Metrics
                        MotorImageryPerformanceMetrics {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            accuracy: motorImageryView.accuracy
                            //confidence: motorImageryView.confidence
                            //predictedClass: motorImageryView.predictedClass
                        }
                    }
                }
            }
        }
    }

    // Experiment Controller
    MotorImageryExperimentController {
        id: experimentController
        running: motorImageryView.experimentRunning
        trialDuration: motorImageryView.config.trialDuration
        restDuration: motorImageryView.config.restDuration
        onCueChanged: (cue) => motorImageryView.currentCue = cue
        onTrialCompleted: motorImageryView.handleTrialCompletion()
        onClassificationResult: (predictedClass, confidence) => {
            motorImageryView.predictedClass = predictedClass
            motorImageryView.confidence = confidence
        }
        onExperimentStarted: {
                console.log("Motor Imagery experiment started")
            }

            onExperimentStopped: {
                console.log("Motor Imagery experiment stopped")
            }
    }

    signal backRequested()

    function startExperiment() {
        experimentRunning = true
        currentTrial = 0
        experimentController.start()
        dataSimulationTimer.start()
        console.log("Motor Imagery experiment started")
    }

    function pauseExperiment() {
        experimentRunning = false
        experimentController.pause()
        dataSimulationTimer.stop()
    }

    function stopExperiment() {
        experimentRunning = false
        currentTrial = 0
        experimentController.stop()
        dataSimulationTimer.stop()
        currentCue = "Rest"
    }

    function handleTrialCompletion() {
        currentTrial++
        
        // Simulate performance updates
        accuracy = Math.max(0.7, Math.min(0.95, accuracy + (Math.random() - 0.5) * 0.05))
        confidence = Math.max(0.6, Math.min(0.9, confidence + (Math.random() - 0.5) * 0.03))
        motorCortexActivation = 0.6 + Math.random() * 0.3
        
        if (currentTrial >= totalTrials) {
            stopExperiment()
        }
    }

    // Simulate real-time data updates
    Timer {
        id: dataSimulationTimer
        interval: 100
        running: false
        repeat: true
        onTriggered: {
            // Simulate motor cortex activation changes
            motorCortexActivation = 0.5 + Math.random() * 0.4
            
            // Simulate class prediction changes during trials
            if (experimentRunning && currentCue !== "Rest") {
                var classes = ["Left Hand", "Right Hand", "Both Hands", "Feet"]
                if (Math.random() > 0.7) {
                    predictedClass = classes[Math.floor(Math.random() * classes.length)]
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("Enterprise Motor Imagery View initialized")
    }
}
