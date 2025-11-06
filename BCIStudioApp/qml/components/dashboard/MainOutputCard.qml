import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Card {
    id: outputCard
    title: "BCI Output"
    icon: "🎯"

    property string command: "NONE"
    property real confidence: 0
    property int predictionTime: 0
    property bool isActive: false

    contentHeight: 180

    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        // Command Display
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            radius: 8
            color: getCommandColor(outputCard.command)
            border.color: theme.border
            border.width: 2

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 5

                Text {
                    text: getCommandIcon(outputCard.command)
                    font.pixelSize: 24
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: outputCard.command
                    color: "white"
                    font.bold: true
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Confidence: " + Math.round(outputCard.confidence * 100) + "%"
                    color: "white"
                    font.pixelSize: 12
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // Confidence Meter
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 5

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Confidence Level:"
                    color: theme.textSecondary
                    font.pixelSize: 12
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: getConfidenceLevel(outputCard.confidence)
                    color: getConfidenceColor(outputCard.confidence)
                    font.pixelSize: 12
                    font.bold: true
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 10
                radius: 5
                color: theme.backgroundLight

                Rectangle {
                    width: parent.width * outputCard.confidence
                    height: parent.height
                    radius: 5
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#F44336" }
                        GradientStop { position: 0.5; color: "#FF9800" }
                        GradientStop { position: 1.0; color: "#4CAF50" }
                    }

                    Behavior on width {
                        NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                    }
                }
            }
        }

        // Performance Metrics
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 8
            columnSpacing: 15

            MetricItem {
                label: "Prediction Time"
                value: outputCard.predictionTime + "ms"
                color: outputCard.predictionTime < 200 ? "#4CAF50" : "#FF9800"
            }

            MetricItem {
                label: "Status"
                value: outputCard.isActive ? "ACTIVE" : "IDLE"
                color: outputCard.isActive ? "#4CAF50" : "#757575"
            }

            MetricItem {
                label: "Last Update"
                value: "Just now"
                color: theme.textSecondary
            }

            MetricItem {
                label: "Accuracy"
                value: "92.5%"
                color: "#2196F3"
            }
        }
    }

    function getCommandColor(command) {
        switch(command) {
            case "LEFT": return "#2196F3"
            case "RIGHT": return "#4CAF50"
            case "UP": return "#FF9800"
            case "DOWN": return "#F44336"
            case "SELECT": return "#9C27B0"
            default: return "#757575"
        }
    }

    function getCommandIcon(command) {
        switch(command) {
            case "LEFT": return "⬅️"
            case "RIGHT": return "➡️"
            case "UP": return "⬆️"
            case "DOWN": return "⬇️"
            case "SELECT": return "✅"
            default: return "⏸️"
        }
    }

    function getConfidenceLevel(confidence) {
        if (confidence >= 0.9) return "EXCELLENT"
        if (confidence >= 0.7) return "GOOD"
        if (confidence >= 0.5) return "FAIR"
        return "POOR"
    }

    function getConfidenceColor(confidence) {
        if (confidence >= 0.9) return "#4CAF50"
        if (confidence >= 0.7) return "#FF9800"
        if (confidence >= 0.5) return "#FF5722"
        return "#F44336"
    }
}

// کامپوننت متریک
Component {
    id: metricComponent

    ColumnLayout {
        property string label: ""
        property string value: ""
        property color color: "white"

        Text {
            text: parent.label
            color: theme.textSecondary
            font.pixelSize: 10
        }

        Text {
            text: parent.value
            color: parent.color
            font.pixelSize: 12
            font.bold: true
        }
    }
}
