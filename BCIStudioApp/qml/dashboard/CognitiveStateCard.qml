import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

DashboardCard {
    id: cognitiveCard
    title: "Cognitive State Analysis"
    icon: "🧠"
    subtitle: "Real-time Brain Activity Monitoring"
    headerColor: "#9C27B0"
    badgeText: "ANALYZING"
    badgeColor: "#FF9800"

    property real attentionLevel: 75
    property real meditationLevel: 60
    property real engagementLevel: 82
    property real mentalWorkload: 45
    property real cognitiveLoad: 55
    property real fatigueLevel: 25

    content: ColumnLayout {
        spacing: 16

        // Brain Wave Visualization
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            radius: 12
            color: "transparent"
            border.color: theme.border

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 15

                // Brain Icon
                Text {
                    text: "🧠"
                    font.pixelSize: 40
                    Layout.alignment: Qt.AlignVCenter
                }

                // Brain Waves
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8

                    Text {
                        text: "Brain Wave Activity"
                        color: theme.textPrimary
                        font.bold: true
                        font.pixelSize: 12
                    }

                    // EEG Signal Visualization
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 6
                        color: "transparent"

                        Canvas {
                            id: eegCanvas
                            anchors.fill: parent
                            anchors.margins: 4

                            property var signalData: []

                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.reset()

                                var width = eegCanvas.width
                                var height = eegCanvas.height

                                // Generate sample EEG signal if empty
                                if (signalData.length === 0) {
                                    for (var i = 0; i < width; i += 2) {
                                        signalData.push(Math.sin(i * 0.1) * 0.5 + Math.random() * 0.3)
                                    }
                                }

                                // Draw EEG signal
                                ctx.strokeStyle = "#9C27B0"
                                ctx.lineWidth = 1.5
                                ctx.beginPath()

                                for (var j = 0; j < signalData.length; j++) {
                                    var x = j
                                    var y = height / 2 + signalData[j] * (height / 2)

                                    if (j === 0) {
                                        ctx.moveTo(x, y)
                                    } else {
                                        ctx.lineTo(x, y)
                                    }
                                }

                                ctx.stroke()

                                // Update signal data (shift and add new point)
                                signalData.shift()
                                signalData.push(Math.sin(Date.now() * 0.01) * 0.5 + Math.random() * 0.3)
                            }

                            Timer {
                                interval: 50
                                running: true
                                repeat: true
                                onTriggered: eegCanvas.requestPaint()
                            }
                        }
                    }
                }
            }
        }

        // Cognitive Metrics
        GridLayout {
            Layout.fillWidth: true
            columns: 3
            rowSpacing: 12
            columnSpacing: 12

            CognitiveMetric {
                title: "Attention"
                value: cognitiveCard.attentionLevel
                color: "#4CAF50"
                icon: "🎯"
                Layout.fillWidth: true
            }

            CognitiveMetric {
                title: "Meditation"
                value: cognitiveCard.meditationLevel
                color: "#2196F3"
                icon: "🧘"
                Layout.fillWidth: true
            }

            CognitiveMetric {
                title: "Engagement"
                value: cognitiveCard.engagementLevel
                color: "#FF9800"
                icon: "⚡"
                Layout.fillWidth: true
            }

            CognitiveMetric {
                title: "Workload"
                value: cognitiveCard.mentalWorkload
                color: "#FF4081"
                icon: "📊"
                Layout.fillWidth: true
            }

            CognitiveMetric {
                title: "Cognitive Load"
                value: cognitiveCard.cognitiveLoad
                color: "#9C27B0"
                icon: "💡"
                Layout.fillWidth: true
            }

            CognitiveMetric {
                title: "Fatigue"
                value: cognitiveCard.fatigueLevel
                color: "#607D8B"
                icon: "😴"
                Layout.fillWidth: true
            }
        }

        // Mental State Summary
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            radius: 8
            color: getOverallStateColor()
            opacity: 0.1
            border.color: getOverallStateColor()
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12

                Text {
                    text: getOverallStateIcon() + " " + getOverallStateText()
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 14
                    Layout.fillWidth: true
                }

                Text {
                    text: "Score: " + Math.round(getOverallScore()) + "%"
                    color: getOverallStateColor()
                    font.bold: true
                    font.pixelSize: 14
                }
            }
        }
    }

    function getOverallScore() {
        var scores = [
            cognitiveCard.attentionLevel,
            cognitiveCard.meditationLevel,
            cognitiveCard.engagementLevel,
            100 - cognitiveCard.mentalWorkload,
            100 - cognitiveCard.cognitiveLoad,
            100 - cognitiveCard.fatigueLevel
        ]
        return scores.reduce((a, b) => a + b, 0) / scores.length
    }

    function getOverallStateColor() {
        var score = getOverallScore()
        if (score >= 80) return "#4CAF50"
        if (score >= 60) return "#FFC107"
        if (score >= 40) return "#FF9800"
        return "#F44336"
    }

    function getOverallStateIcon() {
        var score = getOverallScore()
        if (score >= 80) return "🚀"
        if (score >= 60) return "👍"
        if (score >= 40) return "⚠️"
        return "😴"
    }

    function getOverallStateText() {
        var score = getOverallScore()
        if (score >= 80) return "Optimal Performance"
        if (score >= 60) return "Good Condition"
        if (score >= 40) return "Moderate Load"
        return "High Fatigue"
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            // Simulate cognitive state changes
            cognitiveCard.attentionLevel = Math.max(50, Math.min(95,
                cognitiveCard.attentionLevel + (Math.random() - 0.5) * 10))
            cognitiveCard.meditationLevel = Math.max(40, Math.min(85,
                cognitiveCard.meditationLevel + (Math.random() - 0.5) * 8))
            cognitiveCard.engagementLevel = Math.max(60, Math.min(95,
                cognitiveCard.engagementLevel + (Math.random() - 0.5) * 12))
        }
    }
}
