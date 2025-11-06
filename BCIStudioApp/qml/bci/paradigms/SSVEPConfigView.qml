import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import QtQuick.Dialogs
import QtQuick.Controls.Material 2.15

Rectangle {
    id: ssvepConfigView
    color: "transparent"
    property var theme


    property var config: ({
        frequencies: [6.0, 7.5, 8.57, 10.0],
        stimulationDuration: 3.0,
        trialCount: 20,
        isi: 1.0,
        screenWidth: 1920,
        screenHeight: 1080,
        flashPattern: "sinusoidal",
        backgroundColor: "#1E1E1E",
        stimulusColor: "#FFFFFF"
    })

    signal configIsChanged(var newConfig)

    ScrollView {
        anchors.fill: parent
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 20
            anchors.margins: 20

            Text {
                text: "SSVEP Configuration"
                font.pixelSize: 24
                font.bold: true
                color: Material.foreground
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10
            }

            // Frequencies Configuration
            Rectangle {
                Layout.fillWidth: true
                height: frequenciesColumn.height + 20
                color: Material.background
                radius: 8
                border.color: Material.accent
                border.width: 1

                ColumnLayout {
                    id: frequenciesColumn
                    width: parent.width - 20
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "Stimulation Frequencies (Hz)"
                        font.pixelSize: 16
                        font.bold: true
                        color: Material.foreground
                    }

                    GridLayout {
                        columns: 2
                        columnSpacing: 10
                        rowSpacing: 10
                        Layout.fillWidth: true

                        Repeater {
                            model: config.frequencies.length

                            delegate: RowLayout {
                                Layout.fillWidth: true

                                Text {
                                    text: "Frequency " + (index + 1) + ":"
                                    color: Material.foreground
                                    Layout.preferredWidth: 100
                                }

                                Slider {
                                    id: freqSlider
                                    from: 5.0
                                    to: 30.0
                                    value: config.frequencies[index]
                                    stepSize: 0.1  // اصلاح: stepSize با S بزرگ
                                    Layout.fillWidth: true

                                    onMoved: {
                                        var newFreqs = config.frequencies.slice()
                                        newFreqs[index] = value
                                        updateConfig({frequencies: newFreqs})
                                    }
                                }

                                Text {
                                    text: freqSlider.value.toFixed(1) + " Hz"
                                    color: Material.foreground
                                    Layout.preferredWidth: 60
                                }
                            }
                        }
                    }
                }
            }

            // Timing Parameters
            Rectangle {
                Layout.fillWidth: true
                height: timingColumn.height + 20
                color: Material.background
                radius: 8
                border.color: Material.accent
                border.width: 1

                ColumnLayout {
                    id: timingColumn
                    width: parent.width - 20
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "Timing Parameters"
                        font.pixelSize: 16
                        font.bold: true
                        color: Material.foreground
                    }

                    // Stimulation Duration
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Stimulation Duration:"
                            color: Material.foreground
                            Layout.preferredWidth: 150
                        }

                        Slider {
                            id: durationSlider
                            from: 1.0
                            to: 10.0
                            value: config.stimulationDuration
                            stepSize: 0.1  // اصلاح: stepSize با S بزرگ
                            Layout.fillWidth: true

                            onMoved: {
                                updateConfig({stimulationDuration: value})
                            }
                        }

                        Text {
                            text: durationSlider.value.toFixed(1) + " s"
                            color: Material.foreground
                            Layout.preferredWidth: 60
                        }
                    }

                    // ISI Duration
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Inter-Stimulus Interval:"
                            color: Material.foreground
                            Layout.preferredWidth: 150
                        }

                        Slider {
                            id: isiSlider
                            from: 0.5
                            to: 3.0
                            value: config.isi
                            stepSize: 0.1  // اصلاح: stepSize با S بزرگ
                            Layout.fillWidth: true

                            onMoved: {
                                updateConfig({isi: value})
                            }
                        }

                        Text {
                            text: isiSlider.value.toFixed(1) + " s"
                            color: Material.foreground
                            Layout.preferredWidth: 60
                        }
                    }

                    // Trial Count
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Trial Count:"
                            color: Material.foreground
                            Layout.preferredWidth: 150
                        }

                        Slider {
                            id: trialSlider
                            from: 5
                            to: 100
                            value: config.trialCount
                            stepSize: 1  // اصلاح: stepSize با S بزرگ
                            Layout.fillWidth: true

                            onMoved: {
                                updateConfig({trialCount: value})
                            }
                        }

                        Text {
                            text: trialSlider.value + " trials"
                            color: Material.foreground
                            Layout.preferredWidth: 80
                        }
                    }
                }
            }

            // Visual Parameters
            Rectangle {
                Layout.fillWidth: true
                height: visualColumn.height + 20
                color: Material.background
                radius: 8
                border.color: Material.accent
                border.width: 1

                ColumnLayout {
                    id: visualColumn
                    width: parent.width - 20
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "Visual Parameters"
                        font.pixelSize: 16
                        font.bold: true
                        color: Material.foreground
                    }

                    // Flash Pattern
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Flash Pattern:"
                            color: Material.foreground
                            Layout.preferredWidth: 100
                        }

                        ComboBox {
                            id: patternCombo
                            model: ["sinusoidal", "square", "sawtooth", "triangle"]
                            currentIndex: model.indexOf(config.flashPattern)
                            Layout.fillWidth: true

                            onActivated: {
                                updateConfig({flashPattern: model[currentIndex]})
                            }
                        }
                    }

                    // Background Color
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Background:"
                            color: Material.foreground
                            Layout.preferredWidth: 100
                        }

                        Rectangle {
                            width: 30
                            height: 30
                            color: config.backgroundColor
                            border.color: Material.foreground
                            border.width: 1

                            MouseArea {
                                anchors.fill: parent
                                onClicked: colorDialog.open()
                            }
                        }

                        Text {
                            text: config.backgroundColor
                            color: Material.foreground
                            Layout.fillWidth: true
                        }
                    }

                    // Stimulus Color
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Stimulus:"
                            color: Material.foreground
                            Layout.preferredWidth: 100
                        }

                        Rectangle {
                            width: 30
                            height: 30
                            color: config.stimulusColor
                            border.color: Material.foreground
                            border.width: 1

                            MouseArea {
                                anchors.fill: parent
                                onClicked: stimulusColorDialog.open()
                            }
                        }

                        Text {
                            text: config.stimulusColor
                            color: Material.foreground
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            // Screen Resolution
            Rectangle {
                Layout.fillWidth: true
                height: screenColumn.height + 20
                color: Material.background
                radius: 8
                border.color: Material.accent
                border.width: 1

                ColumnLayout {
                    id: screenColumn
                    width: parent.width - 20
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "Screen Resolution"
                        font.pixelSize: 16
                        font.bold: true
                        color: Material.foreground
                    }

                    // Screen Width
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Width:"
                            color: Material.foreground
                            Layout.preferredWidth: 80
                        }

                        Slider {
                            id: widthSlider
                            from: 800
                            to: 3840
                            value: config.screenWidth
                            stepSize: 10  // اصلاح: stepSize با S بزرگ
                            Layout.fillWidth: true

                            onMoved: {
                                updateConfig({screenWidth: value})
                            }
                        }

                        Text {
                            text: widthSlider.value + " px"
                            color: Material.foreground
                            Layout.preferredWidth: 80
                        }
                    }

                    // Screen Height
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: "Height:"
                            color: Material.foreground
                            Layout.preferredWidth: 80
                        }

                        Slider {
                            id: heightSlider
                            from: 600
                            to: 2160
                            value: config.screenHeight
                            stepSize: 10  // اصلاح: stepSize با S بزرگ
                            Layout.fillWidth: true

                            onMoved: {
                                updateConfig({screenHeight: value})
                            }
                        }

                        Text {
                            text: heightSlider.value + " px"
                            color: Material.foreground
                            Layout.preferredWidth: 80
                        }
                    }
                }
            }

            // Action Buttons
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Button {
                    text: "Reset to Defaults"
                    Layout.fillWidth: true
                    onClicked: resetToDefaults()
                }

                Button {
                    text: "Save Configuration"
                    Layout.fillWidth: true
                    highlighted: true
                    onClicked: saveConfiguration()
                }
            }
        }
    }

    // Color Dialogs
    ColorDialog {
        id: colorDialog
        title: "Choose Background Color"
        selectedColor: config.backgroundColor

        onAccepted: {
            updateConfig({backgroundColor: selectedColor})
        }
    }

    ColorDialog {
        id: stimulusColorDialog
        title: "Choose Stimulus Color"
        selectedColor: config.stimulusColor

        onAccepted: {
            updateConfig({stimulusColor: selectedColor})
        }
    }

    // Functions
    function updateConfig(newValues) {
        var newConfig = Object.assign({}, config, newValues)
        config = newConfig
        configChanged(newConfig)
    }

    function resetToDefaults() {
        var defaults = {
            frequencies: [6.0, 7.5, 8.57, 10.0],
            stimulationDuration: 3.0,
            trialCount: 20,
            isi: 1.0,
            screenWidth: 1920,
            screenHeight: 1080,
            flashPattern: "sinusoidal",
            backgroundColor: "#1E1E1E",
            stimulusColor: "#FFFFFF"
        }
        config = defaults
        configChanged(defaults)
    }

    function saveConfiguration() {
        console.log("SSVEP Configuration Saved:", JSON.stringify(config, null, 2))
        // در اینجا می‌توانید کد ذخیره‌سازی در فایل یا دیتابیس اضافه کنید
    }

    Component.onCompleted: {
        console.log("SSVEP Configuration View Loaded")
    }
}
