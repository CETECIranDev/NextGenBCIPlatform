import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../common"
import "./components"

Rectangle {
    id: p300View

    property var config: ({
        rows: 6,
        cols: 6,
        stimulusDuration: 100,
        isiDuration: 200,
        trialsPerChar: 10,
        charSet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    })
    property var theme
    property bool experimentRunning: false
    property int currentTrial: 0
    property int totalTrials: 120
    property string targetCharacter: "A"
    property real accuracy: 0.92
    property real confidence: 0.87
    property int responseTime: 320

    color: "#0F0F1A"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Top Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: experimentRunning ? "#0F0F1A" : "#1A1A2E"
            Behavior on color { ColorAnimation { duration: 300 } }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 24
                anchors.rightMargin: 24
                spacing: 20

                ColumnLayout {
                    spacing: 2

                    Text {
                        text: "🧠 P300 SPELLER SYSTEM"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 18
                    }

                    Text {
                        text: "Enterprise Character Spelling Interface"
                        color: experimentRunning ? "#666677" : "#7C4DFF"
                        font.pixelSize: 11
                        Behavior on color { ColorAnimation { duration: 300 } }
                    }
                }

                Item { Layout.fillWidth: true }

                RowLayout {
                    spacing: 15

                    StatusIndicator {
                        label: "TARGET"
                        value: targetCharacter
                        color: "#7C4DFF"
                        icon: "🎯"
                    }

                    StatusIndicator {
                        label: "ACCURACY"
                        value: Math.floor(accuracy * 100) + "%"
                        color: accuracy > 0.9 ? "#00C853" : "#FFA000"
                        icon: "📊"
                    }

                    StatusIndicator {
                        label: "STATUS"
                        value: experimentRunning ? "ACTIVE" : "READY"
                        color: experimentRunning ? "#00C853" : "#666677"
                        icon: experimentRunning ? "🔴" : "🟢"
                    }
                }
            }
        }

        // Main Content Area
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            // Speller Grid - مرکز صفحه
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: parent.width * 0.7
                color: "transparent"

                // Focus Background هنگام اجرای آزمایش
                Rectangle {
                    anchors.fill: parent
                    color: experimentRunning ? "#7C4DFF" : "transparent"
                    opacity: experimentRunning ? 0.05 : 0
                    Behavior on opacity { NumberAnimation { duration: 400 } }
                }

                P300GridVisualization {
                    id: gridVisualization
                    anchors.centerIn: parent
                    width: Math.min(parent.width * 0.9, 600)
                    height: Math.min(parent.height * 0.9, 600)
                    config: p300View.config
                    experimentRunning: p300View.experimentRunning
                    targetCharacter: p300View.targetCharacter
                    onCharacterSelected: p300View.handleCharacterSelection(character)
                }
            }

            // Control Panel - سمت راست
            Rectangle {
                Layout.preferredWidth: 320
                Layout.fillHeight: true
                color: experimentRunning ? "#0F0F1A" : "#1A1A2E"
                Behavior on color { ColorAnimation { duration: 300 } }

                P300ControlPanel {
                    anchors.fill: parent
                    experimentRunning: p300View.experimentRunning
                    currentTrial: p300View.currentTrial
                    totalTrials: p300View.totalTrials
                    accuracy: p300View.accuracy
                    onStartExperiment: p300View.startExperiment()
                    onPauseExperiment: p300View.pauseExperiment()
                    onStopExperiment: p300View.stopExperiment()
                    onBackRequested: p300View.backRequested()
                }
            }
        }

        // Bottom Panel - نمودارها و متریک‌ها
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 280
            color: experimentRunning ? "#0F0F1A" : "#1A1A2E"
            opacity: experimentRunning ? 0.7 : 1.0
            Behavior on color { ColorAnimation { duration: 300 } }
            Behavior on opacity { NumberAnimation { duration: 300 } }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15

                P300EEGVisualizer {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    experimentRunning: p300View.experimentRunning
                }

                P300ERPVisualizer {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    experimentRunning: p300View.experimentRunning
                }

                P300PerformanceMetrics {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    accuracy: p300View.accuracy
                    confidence: p300View.confidence
                    responseTime: p300View.responseTime
                }
            }
        }
    }

    // Focus Message
    Rectangle {
        id: focusMessage
        anchors.centerIn: parent
        width: 400
        height: 80
        radius: 12
        color: "#7C4DFF"
        opacity: 0
        visible: opacity > 0

        Text {
            text: "🎯 FOCUS ON THE STIMULUS"
            color: "white"
            font.bold: true
            font.pixelSize: 18
            anchors.centerIn: parent
        }

        Behavior on opacity { NumberAnimation { duration: 500 } }
    }

    // Flash Controller
    P300FlashController {
        id: flashController
        gridSize: config.rows * config.cols
        stimulusDuration: config.stimulusDuration
        isiDuration: config.isiDuration
        running: p300View.experimentRunning
        onFlashSequence: p300View.handleFlashSequence(sequence)
    }

    signal backRequested()

    function startExperiment() {
        experimentRunning = true
        currentTrial = 0
        generateNewTarget()
        flashController.start()
        dataSimulationTimer.start()

        // نمایش پیغام تمرکز
        showFocusMessage()
    }

    function pauseExperiment() {
        experimentRunning = false
        flashController.stop()
        dataSimulationTimer.stop()
    }

    function stopExperiment() {
        experimentRunning = false
        currentTrial = 0
        flashController.stop()
        dataSimulationTimer.stop()
    }

    function showFocusMessage() {
        focusMessage.opacity = 1
        focusMessageTimer.start()
    }

    function hideFocusMessage() {
        focusMessage.opacity = 0
    }

    function handleCharacterSelection(character) {
        console.log("Character selected:", character)
    }

    function handleFlashSequence(sequence) {
        gridVisualization.highlightSequence(sequence)
        currentTrial++
        if (currentTrial >= totalTrials) stopExperiment()
    }

    function generateNewTarget() {
        var chars = config.charSet.split('')
        targetCharacter = chars[Math.floor(Math.random() * chars.length)]
    }

    Timer {
        id: dataSimulationTimer
        interval: 100
        running: false
        repeat: true
        onTriggered: {
            accuracy = Math.max(0.7, Math.min(0.98, accuracy + (Math.random() - 0.5) * 0.02))
            confidence = Math.max(0.6, Math.min(0.95, confidence + (Math.random() - 0.5) * 0.01))
            responseTime = 280 + Math.random() * 100
        }
    }

    Timer {
        id: focusMessageTimer
        interval: 2000
        onTriggered: hideFocusMessage()
    }
}
