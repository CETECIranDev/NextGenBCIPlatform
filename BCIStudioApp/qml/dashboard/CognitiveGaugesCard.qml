import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Rectangle {
    id: gauge

    property string label: "Metric"
    property real value: 50
    property color gaugeColor: "#4CAF50"
    property string icon: "📊"
    property string unit: "%"
    property bool inverse: false

    height: 80
    radius: 12
    color: "transparent"
    border.color: theme.border
    border.width: 1

    // Glass effect background
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        gradient: Gradient {
            GradientStop { position: 0.0; color: theme.backgroundGlass }
            GradientStop { position: 1.0; color: Qt.darker(theme.backgroundGlass, 1.1) }
        }
        opacity: 0.3
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Icon Section
        Rectangle {
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
            radius: 8
            color: gauge.gaugeColor
            opacity: 0.2

            Text {
                text: gauge.icon
                font.pixelSize: 16
                anchors.centerIn: parent
            }

            // Icon glow effect
            Glow {
                anchors.fill: parent
                source: parent
                color: gauge.gaugeColor
                radius: 8
                samples: 16
                spread: 0.2
                opacity: 0.3
            }
        }

        // Content Section
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            // Label
            Text {
                text: gauge.label.toUpperCase()
                color: theme.textSecondary
                font.pixelSize: 10
                font.weight: Font.Bold
                font.letterSpacing: 1
            }

            // Value and progress
            RowLayout {
                Layout.fillWidth: true

                // Value display
                Text {
                    text: Math.round(gauge.value) + gauge.unit
                    color: theme.textPrimary
                    font.pixelSize: 18
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignBottom
                }

                Item { Layout.fillWidth: true }

                // Mini progress indicator
                Text {
                    text: getProgressIcon()
                    font.pixelSize: 12
                    color: getValueColor()
                    Layout.alignment: Qt.AlignBottom
                }
            }

            // Progress bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 6
                radius: 3
                color: theme.backgroundLight

                Rectangle {
                    width: parent.width * (gauge.value / 100)
                    height: parent.height
                    radius: 3
                    color: getValueColor()

                    // Glow effect on progress
                    Glow {
                        anchors.fill: parent
                        source: parent
                        color: getValueColor()
                        radius: 4
                        samples: 9
                        spread: 0.1
                    }

                    Behavior on width {
                        NumberAnimation {
                            duration: 800
                            easing.type: Easing.OutElastic
                            easing.amplitude: 0.5
                        }
                    }
                }
            }
        }
    }

    // Hover effect
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            gauge.scale = 1.02
        }
        onExited: {
            gauge.scale = 1.0
        }
    }

    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    // Helper functions
    function getValueColor() {
        var effectiveValue = gauge.inverse ? 100 - gauge.value : gauge.value

        if (effectiveValue >= 80) return "#4CAF50"
        if (effectiveValue >= 60) return "#FFC107"
        if (effectiveValue >= 40) return "#FF9800"
        return "#F44336"
    }

    function getProgressIcon() {
        var effectiveValue = gauge.inverse ? 100 - gauge.value : gauge.value

        if (effectiveValue >= 80) return "🚀"
        if (effectiveValue >= 60) return "👍"
        if (effectiveValue >= 40) return "⚠️"
        return "😴"
    }

    // Public API
    function setValue(newValue) {
        gauge.value = Math.max(0, Math.min(100, newValue))
    }

    function animateTo(newValue, duration) {
        valueAnimation.to = Math.max(0, Math.min(100, newValue))
        valueAnimation.duration = duration || 1000
        valueAnimation.start()
    }

    NumberAnimation {
        id: valueAnimation
        target: gauge
        property: "value"
        easing.type: Easing.OutCubic
    }
}
