// AdvancedBciOutputCard.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

DashboardCard {
    id: advancedOutputCard
    title: "BCI Command Output"
    icon: "🎯"
    subtitle: "Real-time Brain-Computer Interface"
    headerColor: "#9C27B0"
    badgeText: "LIVE"
    badgeColor: "#FF4081"
    collapsible: true
    //contentMargin: 16

    // Properties
    property string currentCommand: "NEUTRAL"
    property real commandConfidence: 0
    property int commandPredictionTime: 0
    property bool systemActive: false
    property string currentParadigm: "Motor Imagery"
    property real informationTransferRate: 0
    property int totalCommandCount: 0
    property string previousCommand: "NONE"
    property var commandHistory: []
    property int maxHistoryLength: 6
    property bool showDetailedView: true

    // Signal for command execution
    signal commandExecuted(string command, real confidence)
    signal confidenceThresholdReached(string command, real confidence)

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // Command Display Section
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            radius: 12
            color: getCommandColor(advancedOutputCard.currentCommand)
            border.color: Qt.darker(getCommandColor(advancedOutputCard.currentCommand), 1.1)
            border.width: 2

            // Glass morphism effect
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: parent.width
                    height: parent.height
                    radius: parent.radius
                }
            }

            // Background gradient
            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(parent.width, parent.height)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.lighter(getCommandColor(advancedOutputCard.currentCommand), 1.3) }
                    GradientStop { position: 1.0; color: getCommandColor(advancedOutputCard.currentCommand) }
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 20

                // Command Icon
                Rectangle {
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 60
                    radius: 30
                    color: Qt.rgba(1, 1, 1, 0.2)
                    border.color: Qt.rgba(1, 1, 1, 0.3)
                    border.width: 2

                    Text {
                        id: commandIcon
                        anchors.centerIn: parent
                        text: getCommandIcon(advancedOutputCard.currentCommand)
                        font.pixelSize: 24
                        color: "white"
                    }

                    // Active pulse animation
                    Rectangle {
                        anchors.fill: parent
                        radius: parent.radius
                        color: "transparent"
                        border.color: "white"
                        border.width: 2
                        opacity: advancedOutputCard.systemActive ? 0.6 : 0

                        SequentialAnimation on scale {
                            running: advancedOutputCard.systemActive
                            loops: Animation.Infinite
                            NumberAnimation { to: 1.3; duration: 1000; easing.type: Easing.InOutQuad }
                            NumberAnimation { to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
                        }
                    }
                }

                // Command Info
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8

                    Text {
                        text: advancedOutputCard.currentCommand
                        color: "white"
                        font.bold: true
                        font.pixelSize: 24
                        font.family: "Segoe UI, Roboto, sans-serif"
                    }

                    // Confidence Bar
                    ColumnLayout {
                        spacing: 4
                        Layout.fillWidth: true

                        RowLayout {
                            Text {
                                text: "Confidence"
                                color: Qt.rgba(1, 1, 1, 0.8)
                                font.pixelSize: 12
                                font.bold: true
                            }

                            Item { Layout.fillWidth: true }

                            Text {
                                text: Math.round(advancedOutputCard.commandConfidence * 100) + "%"
                                color: "white"
                                font.bold: true
                                font.pixelSize: 14
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 8
                            radius: 4
                            color: Qt.rgba(1, 1, 1, 0.3)

                            Rectangle {
                                width: parent.width * advancedOutputCard.commandConfidence
                                height: parent.height
                                radius: parent.radius
                                gradient: Gradient {
                                    GradientStop { position: 0.0; color: "#FFFFFF" }
                                    GradientStop { position: 1.0; color: "#E0E0E0" }
                                }

                                Behavior on width {
                                    NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                                }
                            }
                        }
                    }
                }

                // Status Indicators
                ColumnLayout {
                    spacing: 8
                    Layout.alignment: Qt.AlignTop

                    StatusPill {
                        statusText: advancedOutputCard.systemActive ? "ACTIVE" : "STANDBY"
                        statusColor: advancedOutputCard.systemActive ? "#00E676" : "#757575"
                        shouldPulse: advancedOutputCard.systemActive
                    }

                    StatusPill {
                        statusText: advancedOutputCard.commandPredictionTime + "ms"
                        statusColor: getPerformanceColor(advancedOutputCard.commandPredictionTime)
                    }
                }
            }
        }

        // Metrics Grid
        GridLayout {
            Layout.fillWidth: true
            Layout.topMargin: 16
            columns: 3
            rowSpacing: 12
            columnSpacing: 12
            visible: showDetailedView

            MetricTile {
                metricTitle: "Information Rate"
                metricValue: advancedOutputCard.informationTransferRate.toFixed(1)
                metricUnit: "bits/min"
                metricIcon: "📈"
                tileColor: "#2196F3"
                valueTrend: advancedOutputCard.informationTransferRate > 20 ? "+" : ""
                Layout.fillWidth: true
            }

            MetricTile {
                metricTitle: "Commands"
                metricValue: advancedOutputCard.totalCommandCount
                metricUnit: ""
                metricIcon: "🔢"
                tileColor: "#9C27B0"
                Layout.fillWidth: true
            }

            MetricTile {
                metricTitle: "Accuracy"
                metricValue: "92.5"
                metricUnit: "%"
                metricIcon: "🎯"
                tileColor: "#4CAF50"
                valueTrend: "+1.2%"
                Layout.fillWidth: true
            }
        }

        // Command History
        ColumnLayout {
            Layout.fillWidth: true
            Layout.topMargin: 16
            spacing: 8
            visible: showDetailedView && advancedOutputCard.commandHistory.length > 0

            Text {
                text: "Recent Commands"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 14
            }

            Flow {
                Layout.fillWidth: true
                spacing: 8

                Repeater {
                    model: Math.min(advancedOutputCard.commandHistory.length, 6)

                    CommandChip {
                        chipCommand: advancedOutputCard.commandHistory[index].command
                        chipConfidence: advancedOutputCard.commandHistory[index].confidence
                        chipTimestamp: advancedOutputCard.commandHistory[index].timestamp
                    }
                }
            }
        }

        // Quick Actions
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 16
            spacing: 8
            visible: showDetailedView

            ActionButton {
                buttonText: advancedOutputCard.systemActive ? "⏹️ Stop" : "▶️ Start"
                buttonColor: advancedOutputCard.systemActive ? "#F44336" : "#4CAF50"
                Layout.fillWidth: true
                onButtonClicked: advancedOutputCard.systemActive = !advancedOutputCard.systemActive
            }

            ActionButton {
                buttonText: "🔄 Calibrate"
                buttonColor: "#FF9800"
                Layout.fillWidth: true
                onButtonClicked: runCalibration()

            }

            ActionButton {
                buttonText: "📊 Details"
                buttonColor: "#607D8B"
                Layout.fillWidth: true
                onButtonClicked: showDetailedView = !showDetailedView
            }
        }

        Item { Layout.fillHeight: true }
    }

    // Helper Functions
    function getCommandColor(command) {
        const colors = {
            "LEFT": "#2196F3",
            "RIGHT": "#4CAF50",
            "UP": "#FF9800",
            "DOWN": "#F44336",
            "SELECT": "#9C27B0",
            "NEUTRAL": "#757575",
            "START": "#00E676",
            "STOP": "#F44336",
            "HOME": "#FF4081"
        }
        return colors[command] || "#607D8B"
    }

    function getCommandIcon(command) {
        const icons = {
            "LEFT": "⬅️",
            "RIGHT": "➡️",
            "UP": "⬆️",
            "DOWN": "⬇️",
            "SELECT": "✅",
            "START": "🚀",
            "STOP": "⏹️",
            "HOME": "🏠",
            "NEUTRAL": "⏸️"
        }
        return icons[command] || "❓"
    }

    function getPerformanceColor(time) {
        if (time < 100) return "#4CAF50"
        if (time < 200) return "#FFC107"
        if (time < 300) return "#FF9800"
        return "#F44336"
    }

    // Public API Methods
    function updateCommand(newCommand, newConfidence, newPredictionTime) {
        var oldCommand = advancedOutputCard.currentCommand
        advancedOutputCard.currentCommand = newCommand
        advancedOutputCard.commandConfidence = newConfidence || 0
        advancedOutputCard.commandPredictionTime = newPredictionTime || 0

        // Add to history
        addCommandToHistory(newCommand, newConfidence)

        // Trigger animation for new commands
        if (oldCommand !== newCommand && newCommand !== "NEUTRAL") {
            commandAnimation.start()
            commandExecuted(newCommand, newConfidence)
        }

        // Check confidence threshold
        if (newConfidence >= 0.8) {
            confidenceThresholdReached(newCommand, newConfidence)
        }
    }

    function addCommandToHistory(command, confidence) {
        advancedOutputCard.commandHistory.unshift({
            command: command,
            confidence: confidence,
            timestamp: new Date()
        })

        if (advancedOutputCard.commandHistory.length > maxHistoryLength) {
            advancedOutputCard.commandHistory.pop()
        }

        advancedOutputCard.totalCommandCount++
        advancedOutputCard.previousCommand = command
    }

    function clearCommandHistory() {
        advancedOutputCard.commandHistory = []
        advancedOutputCard.totalCommandCount = 0
    }

    function setSystemActive(active) {
        advancedOutputCard.systemActive = active
    }

    function updateParadigm(newParadigm) {
        advancedOutputCard.currentParadigm = newParadigm
    }

    function updateInformationTransferRate(itr) {
        advancedOutputCard.informationTransferRate = itr
    }

    function runCalibration() {
        console.log("Starting BCI calibration...")
        // Calibration logic here
    }

    // Command animation
    SequentialAnimation {
        id: commandAnimation
        NumberAnimation {
            target: commandIcon
            property: "scale"
            to: 1.3
            duration: 200
            easing.type: Easing.OutBack
        }
        NumberAnimation {
            target: commandIcon
            property: "scale"
            to: 1.0
            duration: 300
            easing.type: Easing.OutBounce
        }
    }

    // Auto-simulation for demo
    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            if (advancedOutputCard.systemActive) {
                simulateRandomCommand()
            }
        }
    }

    function simulateRandomCommand() {
        var commands = ["LEFT", "RIGHT", "UP", "DOWN", "SELECT", "NEUTRAL"]
        var randomCommand = commands[Math.floor(Math.random() * commands.length)]
        var randomConfidence = Math.random() * 0.3 + 0.6 // 0.6 - 0.9
        var randomTime = Math.floor(Math.random() * 100) + 50 // 50 - 150ms

        updateCommand(randomCommand, randomConfidence, randomTime)
        updateInformationTransferRate(15 + Math.random() * 20) // 15-35 bits/min
    }

    Component.onCompleted: {
        console.log("Enterprise BCI Output Card initialized")
        updateCommand("NEUTRAL", 0.1, 0)
    }
}
