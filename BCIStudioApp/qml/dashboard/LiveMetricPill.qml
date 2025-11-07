import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Rectangle {
    id: metricPill
    width: 140
    height: 70
    radius: 14

    // Properties
    property string icon: "📊"
    property string value: "100%"
    property string label: "Metric"
    property string trend: "+0.0%"
    property color pillColor: theme.primary  // تغییر نام property برای جلوگیری از conflict
    property bool isPositive: trend.startsWith("+")

    // رنگ اصلی کارت - فقط یک بار تنظیم شده
    color: theme.backgroundLight

    // Glass border effect
    border.color: theme.glassBorder
    border.width: 1

    // Shadow effect
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 4
        radius: 12
        samples: 25
        color: theme.shadow
    }

    // Glass overlay
    Rectangle {
        anchors.fill: parent
        radius: 14
        gradient: theme.glassGradient
        opacity: themeManager.glassOpacity * 0.5
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 6

        RowLayout {
            spacing: 10
            Layout.fillWidth: true

            // Icon with glass effect
            Rectangle {
                width: 32
                height: 32
                radius: 8
                color: Qt.rgba(pillColor.r, pillColor.g, pillColor.b, 0.15)  // استفاده از pillColor
                border.color: Qt.rgba(pillColor.r, pillColor.g, pillColor.b, 0.3)  // استفاده از pillColor
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: metricPill.icon
                    font.pixelSize: 14
                    color: pillColor  // استفاده از pillColor
                }
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                Text {
                    text: metricPill.value
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 18
                    font.family: "Segoe UI"
                }

                Text {
                    text: metricPill.label
                    color: theme.textSecondary
                    font.pixelSize: 11
                    font.family: "Segoe UI"
                }
            }
        }

        // Trend indicator
        Rectangle {
            Layout.fillWidth: true
            height: 20
            radius: 10
            color: Qt.rgba(
                isPositive ? theme.success.r : theme.error.r,
                isPositive ? theme.success.g : theme.error.g,
                isPositive ? theme.success.b : theme.error.b,
                0.15
            )
            border.color: Qt.rgba(
                isPositive ? theme.success.r : theme.error.r,
                isPositive ? theme.success.g : theme.error.g,
                isPositive ? theme.success.b : theme.error.b,
                0.3
            )
            border.width: 1

            RowLayout {
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: isPositive ? "↗" : "↘"
                    font.pixelSize: 10
                    color: isPositive ? theme.success : theme.error
                }

                Text {
                    text: metricPill.trend
                    color: isPositive ? theme.success : theme.error
                    font.bold: true
                    font.pixelSize: 10
                }
            }
        }
    }

    // Hover effect - استفاده از PropertyChanges درست
    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse

            PropertyChanges {
                target: metricPill
                color: theme.backgroundElevated  // اینجا فقط مقدار state تغییر می‌کند
                scale: 1.05
            }
        }
    ]

    transitions: Transition {
        NumberAnimation {
            properties: "color, scale"
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
    }

    // Pulse animation for important metrics
    SequentialAnimation on scale {
        running: (value.includes("%") && parseFloat(value) < 80) ||
                (label.toLowerCase().includes("error") && !isPositive)
        loops: Animation.Infinite
        NumberAnimation { to: 1.03; duration: 1000; easing.type: Easing.InOutQuad }
        NumberAnimation { to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
    }

    // تابع helper برای compatibility با کد قدیمی
    function getTrendColor(trend) {
        if (trend.startsWith('+')) return "#4CAF50"
        if (trend.startsWith('-')) return "#F44336"
        return theme.textTertiary
    }
}
