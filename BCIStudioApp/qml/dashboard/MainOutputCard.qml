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
    // badgeText: "LIVE"
    // badgeColor: "#FF4081"
    // collapsible: true

    // Properties
    property string command: "NEUTRAL"
    property real confidence: 0
    property int predictionTime: 0
    property bool isActive: false
    property string paradigm: "Motor Imagery"
    property real informationTransferRate: 0
    property int commandCount: 0
    property string lastCommand: "NONE"
    property var commandHistory: []
    property int maxHistoryLength: 5

    // Signal for command execution
    signal commandExecuted(string command, real confidence)
    signal confidenceThresholdReached(string command, real confidence)

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // Main Command Display
        Rectangle {
            id: commandDisplay
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            radius: 12
            color: getCommandColor(advancedOutputCard.command)
            border.color: Qt.darker(getCommandColor(advancedOutputCard.command), 1.2)
            border.width: 2

            // Glow effect for active commands
            layer.enabled: advancedOutputCard.isActive && advancedOutputCard.command !== "NEUTRAL"
            layer.effect: Glow {
                radius: 16
                samples: 32
                color: getCommandColor(advancedOutputCard.command)
                transparentBorder: true
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 8

                // Command Icon with animation
                Text {
                    id: commandIcon
                    text: getCommandIcon(advancedOutputCard.command)
                    font.pixelSize: 32
                    Layout.alignment: Qt.AlignHCenter

                    // Bounce animation for new commands
                    SequentialAnimation on scale {
                        id: commandAnimation
                        running: false
                        NumberAnimation { to: 1.3; duration: 200; easing.type: Easing.OutBack }
                        NumberAnimation { to: 1.0; duration: 300; easing.type: Easing.OutBounce }
                    }
                }

                // Command Text
                Text {
                    text: advancedOutputCard.command
                    color: "white"
                    font.bold: true
                    font.pixelSize: 20
                    font.family: "Segoe UI, Roboto, sans-serif"
                    Layout.alignment: Qt.AlignHCenter
                }

                // Confidence and Timing
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 15

                    Text {
                        text: "🎯 " + Math.round(advancedOutputCard.confidence * 100) + "%"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 12
                    }

                    Text {
                        text: "⏱️ " + advancedOutputCard.predictionTime + "ms"
                        color: "white"
                        font.pixelSize: 12
                        opacity: 0.9
                    }
                }
            }

            // Active indicator
            Rectangle {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 8
                width: 12
                height: 12
                radius: 6
                color: advancedOutputCard.isActive ? "#00E676" : "#757575"

                // Pulse animation when active
                SequentialAnimation on scale {
                    running: advancedOutputCard.isActive
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.5; duration: 800; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
                }
            }
        }

        // Confidence Visualization
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Confidence Level"
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 12
                }

                Item { Layout.fillWidth: true }

                // Confidence level with color indicator
                RowLayout {
                    spacing: 6

                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: getConfidenceColor(advancedOutputCard.confidence)
                    }

                    Text {
                        text: getConfidenceLevel(advancedOutputCard.confidence)
                        color: getConfidenceColor(advancedOutputCard.confidence)
                        font.bold: true
                        font.pixelSize: 11
                    }
                }
            }

            // Advanced confidence bar with markers
            Item {
                Layout.fillWidth: true
                height: 16

                // Background
                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: theme.backgroundLight
                }

                // Confidence fill with gradient
                Rectangle {
                    width: parent.width * advancedOutputCard.confidence
                    height: parent.height
                    radius: 8
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#F44336" }
                        GradientStop { position: 0.3; color: "#FF9800" }
                        GradientStop { position: 0.7; color: "#FFC107" }
                        GradientStop { position: 1.0; color: "#4CAF50" }
                    }

                    Behavior on width {
                        NumberAnimation { duration: 600; easing.type: Easing.OutElastic }
                    }
                }

                // Threshold markers
                Repeater {
                    model: [0.5, 0.7, 0.9]

                    Rectangle {
                        x: parent.width * modelData - 1
                        width: 2
                        height: parent.height
                        color: "white"
                        opacity: 0.6
                    }
                }

                // Current confidence indicator
                Rectangle {
                    x: parent.width * advancedOutputCard.confidence - 4
                    y: -8
                    width: 8
                    height: 8
                    radius: 4
                    color: "white"
                    border.color: getConfidenceColor(advancedOutputCard.confidence)
                    border.width: 2
                }
            }

            // Confidence threshold labels
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Low"
                    color: "#F44336"
                    font.pixelSize: 9
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "High"
                    color: "#4CAF50"
                    font.pixelSize: 9
                    font.bold: true
                }
            }
        }

        // Performance Metrics Grid
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 10
            columnSpacing: 15

            AdvancedMetricItem {
                label: "Prediction Speed"
                value: advancedOutputCard.predictionTime.toString()
                unit: "ms"
                color: getPerformanceColor(advancedOutputCard.predictionTime)
                icon: "⚡"
                trend: advancedOutputCard.predictionTime < 150 ? "Fast" : "Normal"
                Layout.fillWidth: true
            }

            AdvancedMetricItem {
                label: "System Status"
                value: advancedOutputCard.isActive ? "ACTIVE" : "STANDBY"
                color: advancedOutputCard.isActive ? "#00E676" : "#757575"
                icon: advancedOutputCard.isActive ? "🟢" : "⚪"
                pulse: advancedOutputCard.isActive
                Layout.fillWidth: true
            }

            AdvancedMetricItem {
                label: "ITR"
                value: advancedOutputCard.informationTransferRate.toFixed(1)
                unit: "bits/min"
                color: "#2196F3"
                icon: "📈"
                trend: advancedOutputCard.informationTransferRate > 20 ? "High" : "Normal"
                Layout.fillWidth: true
            }

            AdvancedMetricItem {
                label: "Paradigm"
                value: advancedOutputCard.paradigm
                color: theme.textPrimary
                icon: "🧠"
                Layout.fillWidth: true
            }

            AdvancedMetricItem {
                label: "Commands"
                value: advancedOutputCard.commandCount.toString()
                color: "#9C27B0"
                icon: "🔢"
                Layout.fillWidth: true
            }

            AdvancedMetricItem {
                label: "Accuracy"
                value: "92.5"
                unit: "%"
                color: "#4CAF50"
                icon: "🎯"
                trend: "+1.2%"
                trendColor: "#4CAF50"
                Layout.fillWidth: true
            }
        }

        // Command History
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            radius: 8
            color: Qt.lighter(theme.backgroundLight, 1.1)
            visible: advancedOutputCard.commandHistory.length > 0

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                Text {
                    text: "History:"
                    color: theme.textSecondary
                    font.pixelSize: 11
                    font.bold: true
                }

                Repeater {
                    model: Math.min(advancedOutputCard.commandHistory.length, 4)

                    Rectangle {
                        Layout.preferredWidth: 30
                        Layout.preferredHeight: 30
                        radius: 6
                        color: getCommandColor(advancedOutputCard.commandHistory[index].command)
                        opacity: 0.8

                        Text {
                            anchors.centerIn: parent
                            text: getCommandIcon(advancedOutputCard.commandHistory[index].command)
                            font.pixelSize: 12
                            color: "white"
                        }

                        ToolTip.text: advancedOutputCard.commandHistory[index].command +
                                    " (" + Math.round(advancedOutputCard.commandHistory[index].confidence * 100) + "%)"
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "+" + Math.max(0, advancedOutputCard.commandHistory.length - 4)
                    color: theme.textTertiary
                    font.pixelSize: 10
                    visible: advancedOutputCard.commandHistory.length > 4
                }
            }
        }
    }

    // Helper Functions
    function getCommandColor(command) {
        switch(command) {
            case "LEFT": return "#2196F3"
            case "RIGHT": return "#4CAF50"
            case "UP": return "#FF9800"
            case "DOWN": return "#F44336"
            case "SELECT": return "#9C27B0"
            case "NEUTRAL": return "#757575"
            case "START": return "#00E676"
            case "STOP": return "#F44336"
            case "HOME": return "#FF4081"
            default: return "#607D8B"
        }
    }

    function getCommandIcon(command) {
        switch(command) {
            case "LEFT": return "⬅️"
            case "RIGHT": return "➡️"
            case "UP": return "⬆️"
            case "DOWN": return "⬇️"
            case "SELECT": return "✅"
            case "START": return "🚀"
            case "STOP": return "⏹️"
            case "HOME": return "🏠"
            case "NEUTRAL": return "⏸️"
            default: return "❓"
        }
    }

    function getConfidenceLevel(confidence) {
        if (confidence >= 0.9) return "EXCELLENT"
        if (confidence >= 0.7) return "HIGH"
        if (confidence >= 0.5) return "MEDIUM"
        if (confidence >= 0.3) return "LOW"
        return "VERY LOW"
    }

    function getConfidenceColor(confidence) {
        if (confidence >= 0.9) return "#4CAF50"
        if (confidence >= 0.7) return "#8BC34A"
        if (confidence >= 0.5) return "#FFC107"
        if (confidence >= 0.3) return "#FF9800"
        return "#F44336"
    }

    function getPerformanceColor(time) {
        if (time < 100) return "#4CAF50"
        if (time < 200) return "#FFC107"
        if (time < 300) return "#FF9800"
        return "#F44336"
    }

    // Public API Methods
    function setCommand(newCommand, newConfidence, newPredictionTime) {
        var oldCommand = advancedOutputCard.command
        advancedOutputCard.command = newCommand
        advancedOutputCard.confidence = newConfidence || 0
        advancedOutputCard.predictionTime = newPredictionTime || 0

        // Add to history
        addToHistory(newCommand, newConfidence)

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

    function addToHistory(command, confidence) {
        advancedOutputCard.commandHistory.unshift({
            command: command,
            confidence: confidence,
            timestamp: new Date()
        })

        if (advancedOutputCard.commandHistory.length > maxHistoryLength) {
            advancedOutputCard.commandHistory.pop()
        }

        advancedOutputCard.commandCount++
        advancedOutputCard.lastCommand = command
    }

    function clearHistory() {
        advancedOutputCard.commandHistory = []
        advancedOutputCard.commandCount = 0
    }

    function setActive(active) {
        advancedOutputCard.isActive = active
    }

    function setParadigm(newParadigm) {
        advancedOutputCard.paradigm = newParadigm
    }

    function setInformationTransferRate(itr) {
        advancedOutputCard.informationTransferRate = itr
    }

    // Simulate command for demonstration
    function simulateCommand() {
        var commands = ["LEFT", "RIGHT", "UP", "DOWN", "SELECT", "NEUTRAL"]
        var randomCommand = commands[Math.floor(Math.random() * commands.length)]
        var randomConfidence = Math.random() * 0.3 + 0.6 // 0.6 - 0.9
        var randomTime = Math.floor(Math.random() * 100) + 50 // 50 - 150ms

        setCommand(randomCommand, randomConfidence, randomTime)
        setInformationTransferRate(15 + Math.random() * 20) // 15-35 bits/min
    }

    // Auto-simulation for demo
    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            if (advancedOutputCard.isActive) {
                simulateCommand()
            }
        }
    }

    Component.onCompleted: {
        console.log("Advanced BCI Output Card initialized")
        // Initialize with neutral state
        setCommand("NEUTRAL", 0.1, 0)
    }
}
