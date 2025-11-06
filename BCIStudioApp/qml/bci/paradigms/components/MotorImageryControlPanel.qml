import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: controlPanel
    color: Material.background
    radius: 12
    border.color: Material.accent
    border.width: 1

    // Properties based on your usage
    property bool experimentRunning: false
    property int currentTrial: 0
    property int totalTrials: 0
    property real accuracy: 0.0
    property string currentCue: "rest"

    // Signals based on your usage
    signal startExperiment()
    signal pauseExperiment()
    signal stopExperiment()
    signal backRequested()

    // Additional properties for enhanced functionality
    property var experimentState: experimentRunning ? "running" : "idle"
    property var cues: ["rest", "left_hand", "right_hand", "both_hands", "both_feet"]
    property var cueDisplayNames: {
        "rest": "🔄 Rest",
        "left_hand": "👈 Left Hand",
        "right_hand": "👉 Right Hand",
        "both_hands": "👐 Both Hands",
        "both_feet": "🦶 Both Feet"
    }

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
            text: "🧠 Motor Imagery Control"
            font.pixelSize: 20
            font.bold: true
            color: Material.foreground
            Layout.alignment: Qt.AlignHCenter
        }

        // Experiment Status
        Rectangle {
            Layout.fillWidth: true
            height: 80
            color: getStatusColor()
            radius: 8

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4

                Text {
                    text: getStatusText()
                    color: "white"
                    font.pixelSize: 16
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Trial: " + currentTrial + " / " + totalTrials
                    color: "white"
                    font.pixelSize: 12
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Accuracy: " + (accuracy * 100).toFixed(1) + "%"
                    color: "white"
                    font.pixelSize: 12
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // Current Cue Display
        Rectangle {
            Layout.fillWidth: true
            height: 70
            color: Material.surface
            radius: 8
            border.color: Material.accent
            border.width: 2

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: "🎯 Current Cue"
                    color: Material.foreground
                    font.pixelSize: 12
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: cueDisplayNames[currentCue] || currentCue
                    color: getCueColor(currentCue)
                    font.pixelSize: 18
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // Progress Section
        GroupBox {
            title: "📊 Progress"
            Layout.fillWidth: true

            background: Rectangle {
                color: Material.background
                radius: 6
                border.color: Material.accent
            }

            ColumnLayout {
                width: parent.width
                spacing: 8

                // Progress Bar
                ProgressBar {
                    id: progressBar
                    Layout.fillWidth: true
                    value: totalTrials > 0 ? currentTrial / totalTrials : 0
                    visible: totalTrials > 0

                    background: Rectangle {
                        color: Material.surface
                        radius: 3
                    }

                    contentItem: Rectangle {
                        color: Material.Green
                        radius: 3
                    }
                }

                // Progress Text
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Progress:"
                        color: Material.foreground
                        font.pixelSize: 12
                    }

                    Text {
                        text: totalTrials > 0 ? ((currentTrial / totalTrials) * 100).toFixed(1) + "%" : "0%"
                        color: Material.foreground
                        font.pixelSize: 12
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignRight
                    }
                }

                // Trials Info
                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "Trials:"
                        color: Material.foreground
                        font.pixelSize: 12
                    }

                    Text {
                        text: currentTrial + " / " + totalTrials
                        color: Material.foreground
                        font.pixelSize: 12
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignRight
                    }
                }
            }
        }

        // Control Buttons
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            // Start/Pause Button
            Button {
                id: startPauseButton
                text: experimentRunning ? "⏸️ Pause Experiment" : "▶️ Start Experiment"
                Layout.fillWidth: true
                Material.background: experimentRunning ? Material.Orange : Material.Green
                Material.foreground: "white"
                font.pixelSize: 14
                font.bold: true

                onClicked: {
                    if (experimentRunning) {
                        pauseExperiment()
                    } else {
                        startExperiment()
                    }
                }
            }

            // Stop Button
            Button {
                text: "⏹️ Stop Experiment"
                Layout.fillWidth: true
                Material.background: Material.Red
                Material.foreground: "white"
                font.pixelSize: 14
                font.bold: true
                enabled: experimentRunning

                onClicked: {
                    stopExperiment()
                }
            }

            // Back Button
            Button {
                text: "⬅️ Back to Main"
                Layout.fillWidth: true
                Material.background: Material.BlueGrey
                Material.foreground: "white"
                font.pixelSize: 14

                onClicked: {
                    backRequested()
                }
            }
        }

        // Quick Actions
        GroupBox {
            title: "⚡ Quick Actions"
            Layout.fillWidth: true

            background: Rectangle {
                color: Material.background
                radius: 6
                border.color: Material.accent
            }

            GridLayout {
                columns: 2
                rowSpacing: 8
                columnSpacing: 8
                width: parent.width

                Button {
                    text: "🔄 Calibrate"
                    Layout.fillWidth: true
                    Material.background: Material.Blue
                    Material.foreground: "white"

                    onClicked: {
                        console.log("Calibration requested")
                        // You can add calibration logic here
                    }
                }

                Button {
                    text: "💾 Save Data"
                    Layout.fillWidth: true
                    Material.background: Material.Purple
                    Material.foreground: "white"

                    onClicked: {
                        console.log("Data save requested")
                        // You can add data saving logic here
                    }
                }

                Button {
                    text: "📊 Show Results"
                    Layout.fillWidth: true
                    Material.background: Material.Teal
                    Material.foreground: "white"

                    onClicked: {
                        console.log("Show results requested")
                        // You can add results display logic here
                    }
                }

                Button {
                    text: "⚙️ Settings"
                    Layout.fillWidth: true
                    Material.background: Material.DeepOrange
                    Material.foreground: "white"

                    onClicked: {
                        console.log("Settings requested")
                        // You can add settings logic here
                    }
                }
            }
        }

        // Cue Preview
        GroupBox {
            title: "👀 Cue Preview"
            Layout.fillWidth: true
            visible: !experimentRunning

            background: Rectangle {
                color: Material.background
                radius: 6
                border.color: Material.accent
            }

            Flow {
                width: parent.width
                spacing: 8

                Repeater {
                    model: cues

                    delegate: Rectangle {
                        width: 60
                        height: 40
                        color: currentCue === modelData ? Material.accent : Material.surface
                        radius: 6
                        border.color: Material.accent

                        Text {
                            text: getCueIcon(modelData)
                            font.pixelSize: 16
                            anchors.centerIn: parent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                // For preview only - doesn't change actual experiment cue
                                console.log("Preview cue:", modelData)
                            }
                        }
                    }
                }
            }
        }
    }

    // Functions
    function getStatusColor() {
        if (experimentRunning) {
            return Material.Green
        } else if (currentTrial > 0 && currentTrial < totalTrials) {
            return Material.Orange
        } else if (currentTrial >= totalTrials && totalTrials > 0) {
            return Material.Purple
        } else {
            return Material.Grey
        }
    }

    function getStatusText() {
        if (experimentRunning) {
            return "▶️ Experiment Running"
        } else if (currentTrial > 0 && currentTrial < totalTrials) {
            return "⏸️ Experiment Paused"
        } else if (currentTrial >= totalTrials && totalTrials > 0) {
            return "🏁 Experiment Completed"
        } else {
            return "⏸️ Ready to Start"
        }
    }

    function getCueColor(cue) {
        var colors = {
            "rest": Material.BlueGrey,
            "left_hand": Material.Blue,
            "right_hand": Material.Red,
            "both_hands": Material.Green,
            "both_feet": Material.Orange
        }
        return colors[cue] || Material.foreground
    }

    function getCueIcon(cue) {
        var icons = {
            "rest": "🔄",
            "left_hand": "👈",
            "right_hand": "👉",
            "both_hands": "👐",
            "both_feet": "🦶"
        }
        return icons[cue] || "❓"
    }

    function updateProgress(trial, total) {
        currentTrial = trial
        totalTrials = total
    }

    function setExperimentRunning(running) {
        experimentRunning = running
    }

    function setCurrentCue(cue) {
        currentCue = cue
    }

    function setAccuracy(acc) {
        accuracy = acc
    }

    function reset() {
        experimentRunning = false
        currentTrial = 0
        totalTrials = 0
        accuracy = 0.0
        currentCue = "rest"
    }

    Component.onCompleted: {
        console.log("Motor Imagery Control Panel initialized")
        console.log("Available cues:", cues)
    }
}
