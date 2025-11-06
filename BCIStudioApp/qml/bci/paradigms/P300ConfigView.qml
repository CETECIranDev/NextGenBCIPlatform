import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../../common"

Rectangle {
    id: p300Config

    property var config: ({})
    property var theme
    property bool isActive: false

    width: parent.width
    height: 600
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        spacing: 24

        // Header
        RowLayout {
            spacing: 16

            MaterialButton {
                text: "←"
                buttonColor: theme.surface
                textColor: theme.primary
                rounded: true
                elevation: 1
                onClicked: backRequested()
            }

            Text {
                text: "🔤 P300 Speller Configuration"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 24
                Layout.fillWidth: true
            }

            MaterialButton {
                text: isActive ? "⏹️ Stop" : "▶ Start"
                buttonColor: isActive ? theme.error : theme.success
                elevation: 2
                onClicked: toggleExperiment()
            }
        }

        // Main Content
        RowLayout {
            spacing: 24
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Left Panel - Configuration
            ColumnLayout {
                Layout.preferredWidth: 400
                Layout.fillHeight: true
                spacing: 16

                // Grid Settings
                MaterialCard {
                    title: "📐 Grid Settings"
                    icon: "🔲"
                    headerColor: "#7C4DFF"
                    Layout.fillWidth: true

                    ColumnLayout {
                        width: parent.width
                        spacing: 16

                        RowLayout {
                            Text {
                                text: "Grid Size"
                                color: theme.textPrimary
                                font.bold: true
                                font.pixelSize: 14
                                Layout.fillWidth: true
                            }

                            RowLayout {
                                spacing: 8

                                MaterialTextField {
                                    label: "Rows"
                                    text: config.rows || "6"
                                    Layout.preferredWidth: 80
                                    onTextChanged: config.rows = parseInt(text) || 6
                                }

                                Text {
                                    text: "×"
                                    color: theme.textSecondary
                                    font.pixelSize: 16
                                }

                                MaterialTextField {
                                    label: "Columns"
                                    text: config.cols || "6"
                                    Layout.preferredWidth: 80
                                    onTextChanged: config.cols = parseInt(text) || 6
                                }
                            }
                        }

                        Slider {
                            id: sizeSlider
                            from: 3
                            to: 8
                            value: config.rows || 6
                            stepSize: 1
                            onValueChanged: {
                                config.rows = value
                                config.cols = value
                            }
                            Layout.fillWidth: true
                        }
                    }
                }

                // Timing Settings
                MaterialCard {
                    title: "⏱️ Timing"
                    icon: "⚡"
                    headerColor: "#00BFA5"
                    Layout.fillWidth: true

                    GridLayout {
                        columns: 2
                        columnSpacing: 16
                        rowSpacing: 12
                        width: parent.width

                        Text { text: "Stimulus Duration"; color: theme.textSecondary; font.pixelSize: 12 }
                        MaterialTextField {
                            text: config.stimulusDuration || "100"
                            placeholderText: "ms"
                            onTextChanged: config.stimulusDuration = parseInt(text) || 100
                        }

                        Text { text: "ISI Duration"; color: theme.textSecondary; font.pixelSize: 12 }
                        MaterialTextField {
                            text: config.isiDuration || "200"
                            placeholderText: "ms"
                            onTextChanged: config.isiDuration = parseInt(text) || 200
                        }

                        Text { text: "Trials/Character"; color: theme.textSecondary; font.pixelSize: 12 }
                        MaterialTextField {
                            text: config.trialsPerChar || "10"
                            onTextChanged: config.trialsPerChar = parseInt(text) || 10
                        }
                    }
                }

                // Character Set
                MaterialCard {
                    title: "🔤 Characters"
                    icon: "📝"
                    headerColor: "#FF6D00"
                    Layout.fillWidth: true

                    MaterialTextField {
                        label: "Character Set"
                        text: config.charSet || "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                        onTextChanged: config.charSet = text
                        Layout.fillWidth: true
                    }
                }
            }

            // Right Panel - Preview and Visualization
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 16

                // Live Preview
                MaterialCard {
                    title: "👁️ Live Preview"
                    icon: "🔍"
                    headerColor: "#2962FF"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 300

                    Rectangle {
                        width: parent.width
                        height: 200
                        color: theme.backgroundLight
                        radius: 8

                        // P300 Grid Preview
                        Grid {
                            anchors.centerIn: parent
                            columns: config.cols || 6
                            spacing: 4

                            Repeater {
                                model: (config.rows || 6) * (config.cols || 6)

                                Rectangle {
                                    width: 30
                                    height: 30
                                    radius: 4
                                    color: index % (config.cols || 6) === Math.floor(Math.random() * (config.cols || 6)) ?
                                           "#7C4DFF" : theme.surface
                                    border.color: theme.border

                                    Text {
                                        text: String.fromCharCode(65 + (index % 26))
                                        color: index % (config.cols || 6) === Math.floor(Math.random() * (config.cols || 6)) ?
                                               "white" : theme.textPrimary
                                        font.pixelSize: 12
                                        font.bold: true
                                        anchors.centerIn: parent
                                    }

                                    SequentialAnimation on opacity {
                                        running: true
                                        loops: Animation.Infinite
                                        PropertyAnimation { to: 0.3; duration: 500 }
                                        PropertyAnimation { to: 1.0; duration: 500 }
                                        paused: !isActive
                                    }
                                }
                            }
                        }
                    }
                }

                // Statistics
                MaterialCard {
                    title: "📊 Statistics"
                    icon: "📈"
                    headerColor: "#9C27B0"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120

                    RowLayout {
                        anchors.fill: parent
                        spacing: 16

                        StatItem {
                            label: "Total Characters"
                            value: "36"
                            color: "#7C4DFF"
                        }

                        StatItem {
                            label: "Trial Duration"
                            value: "3.0s"
                            color: "#00BFA5"
                        }

                        StatItem {
                            label: "Accuracy"
                            value: "92%"
                            color: "#FF6D00"
                        }

                        StatItem {
                            label: "Signal Quality"
                            value: "Excellent"
                            color: "#2962FF"
                        }
                    }
                }

                // Quick Actions
                RowLayout {
                    spacing: 12
                    Layout.fillWidth: true

                    MaterialButton {
                        text: "🎬 Preview Sequence"
                        buttonColor: theme.surface
                        textColor: theme.primary
                        Layout.fillWidth: true
                        onClicked: previewSequence()
                    }

                    MaterialButton {
                        text: "💾 Save Preset"
                        buttonColor: theme.surface
                        textColor: theme.primary
                        Layout.fillWidth: true
                        onClicked: savePreset()
                    }

                    MaterialButton {
                        text: "📤 Export"
                        buttonColor: theme.surface
                        textColor: theme.primary
                        Layout.fillWidth: true
                        onClicked: exportConfig()
                    }
                }
            }
        }
    }

    signal backRequested()

    function toggleExperiment() {
        isActive = !isActive
        if (isActive) {
            console.log("Starting P300 experiment with config:", config)
        } else {
            console.log("Stopping P300 experiment")
        }
    }

    function previewSequence() {
        console.log("Previewing P300 sequence")
    }

    function savePreset() {
        console.log("Saving P300 preset")
    }

    function exportConfig() {
        console.log("Exporting P300 configuration")
    }
}

