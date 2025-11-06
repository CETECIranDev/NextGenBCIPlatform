import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: motorImageryConfig

    property var config: ({})
    property var theme

    width: parent.width
    height: 500
    color: theme.backgroundCard
    radius: theme.radius.lg

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        Text {
            text: "💪 Motor Imagery Configuration"
            color: theme.textPrimary
            font.bold: true
            font.pixelSize: theme.typography.h4.size
        }

        GridLayout {
            columns: 2
            columnSpacing: 20
            rowSpacing: 15
            Layout.fillWidth: true

            Text { text: "Trial Duration:"; color: theme.textSecondary }
            RowLayout {
                SpinBox {
                    id: trialDurationSpin
                    from: 2
                    to: 10
                    value: config.trialDuration || 4
                    onValueChanged: config.trialDuration = value
                    Layout.fillWidth: true
                }
                Text { text: "s"; color: theme.textSecondary; Layout.rightMargin: 10 }
            }

            Text { text: "Rest Duration:"; color: theme.textSecondary }
            RowLayout {
                SpinBox {
                    id: restDurationSpin
                    from: 1
                    to: 5
                    value: config.restDuration || 2
                    onValueChanged: config.restDuration = value
                    Layout.fillWidth: true
                }
                Text { text: "s"; color: theme.textSecondary; Layout.rightMargin: 10 }
            }

            Text { text: "Number of Trials:"; color: theme.textSecondary }
            SpinBox {
                from: 10
                to: 200
                value: config.numTrials || 40
                onValueChanged: config.numTrials = value
            }

            Text { text: "Cue Type:"; color: theme.textSecondary }
            ComboBox {
                model: ["Arrow", "Text", "Hand Image", "Custom"]
                currentIndex: config.cueType || 0
                onCurrentIndexChanged: config.cueType = currentIndex
                Layout.fillWidth: true
            }
        }

        // Movement classes
        Rectangle {
            Layout.fillWidth: true
            height: 120
            color: theme.backgroundLight
            radius: theme.radius.md

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: "Movement Classes"
                    color: theme.textPrimary
                    font.bold: true
                }

                Flow {
                    Layout.fillWidth: true
                    spacing: 10

                    Repeater {
                        model: ["Left Hand", "Right Hand", "Both Hands", "Feet", "Tongue"]

                        CheckBox {
                            text: modelData
                            checked: config.classes ? config.classes.includes(modelData) : (index < 2)
                            onCheckedChanged: {
                                if (!config.classes) config.classes = []
                                if (checked && !config.classes.includes(modelData)) {
                                    config.classes.push(modelData)
                                } else if (!checked) {
                                    config.classes = config.classes.filter(cls => cls !== modelData)
                                }
                            }
                        }
                    }
                }
            }
        }

        // Feedback settings
        Rectangle {
            Layout.fillWidth: true
            height: 100
            color: theme.backgroundLight
            radius: theme.radius.md

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: "Feedback Settings"
                    color: theme.textPrimary
                    font.bold: true
                }

                RowLayout {
                    CheckBox {
                        text: "Real-time Feedback"
                        checked: config.realtimeFeedback || false
                        onCheckedChanged: config.realtimeFeedback = checked
                    }

                    CheckBox {
                        text: "Visual Feedback"
                        checked: config.visualFeedback || true
                        onCheckedChanged: config.visualFeedback = checked
                    }

                    CheckBox {
                        text: "Auditory Feedback"
                        checked: config.auditoryFeedback || false
                        onCheckedChanged: config.auditoryFeedback = checked
                    }
                }
            }
        }

        Button {
            text: "🎬 Preview Cue Sequence"
            onClicked: previewCues()
            Layout.alignment: Qt.AlignHCenter
        }
    }

    function previewCues() {
        console.log("Preview Motor Imagery cues for classes:", config.classes)
    }
}
