import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Card {
    id: gaugesCard
    title: "Cognitive Metrics"
    icon: "🧠"

    property real attention: 0
    property real meditation: 0
    property real fatigue: 0
    property real engagement: 0

    contentHeight: 200

    GridLayout {
        anchors.fill: parent
        columns: 2
        rowSpacing: 15
        columnSpacing: 15

        CognitiveGauge {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            label: "Attention"
            value: gaugesCard.attention
            color: "#4CAF50"
            icon: "🎯"
        }

        CognitiveGauge {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            label: "Meditation"
            value: gaugesCard.meditation
            color: "#2196F3"
            icon: "🧘"
        }

        CognitiveGauge {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            label: "Engagement"
            value: gaugesCard.engagement
            color: "#FF9800"
            icon: "⚡"
        }

        CognitiveGauge {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            label: "Fatigue"
            value: gaugesCard.fatigue
            color: "#9C27B0"
            icon: "😴"
            inverse: true
        }
    }
}

// کامپوننت داخلی برای هر گیج
Component {
    id: gaugeComponent

    Item {
        property string label: ""
        property real value: 0
        property color color: "blue"
        property string icon: ""
        property bool inverse: false

        ColumnLayout {
            anchors.fill: parent
            spacing: 5

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: parent.parent.icon
                    font.pixelSize: 16
                }

                Text {
                    text: parent.parent.label
                    color: theme.textSecondary
                    font.pixelSize: 12
                    font.bold: true
                    Layout.fillWidth: true
                }

                Text {
                    text: Math.round(parent.parent.value) + "%"
                    color: theme.textPrimary
                    font.pixelSize: 12
                    font.bold: true
                }
            }

            // Gauge Bar
            Rectangle {
                Layout.fillWidth: true
                height: 8
                radius: 4
                color: theme.backgroundLight

                Rectangle {
                    width: parent.width * (parent.parent.value / 100)
                    height: parent.height
                    radius: 4
                    color: parent.parent.color

                    Behavior on width {
                        NumberAnimation { duration: 800; easing.type: Easing.OutCubic }
                    }
                }
            }

            // Trend indicator (simplified)
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: getTrendText()
                    color: getTrendColor()
                    font.pixelSize: 10
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: getLevelText(parent.parent.value)
                    color: getLevelColor(parent.parent.value)
                    font.pixelSize: 10
                    font.bold: true
                }
            }
        }

        function getTrendText() {
            // Simulated trend
            var trends = ["↗️ Improving", "➡️ Stable", "↘️ Declining"]
            return trends[Math.floor(Math.random() * trends.length)]
        }

        function getTrendColor() {
            return theme.textSecondary
        }

        function getLevelText(value) {
            if (value >= 80) return "HIGH"
            if (value >= 60) return "MEDIUM"
            if (value >= 40) return "LOW"
            return "VERY LOW"
        }

        function getLevelColor(value) {
            if (value >= 80) return "#4CAF50"
            if (value >= 60) return "#FF9800"
            if (value >= 40) return "#FF5722"
            return "#F44336"
        }
    }
}
