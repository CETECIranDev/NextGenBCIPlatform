import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: metricItem

    // Properties
    property string label: "Metric"
    property string value: "0"
    property string unit: ""
    property color color: theme.textPrimary
    property string icon: ""
    property string trend: "" // "+", "-", "=" یا مقدار عددی
    property string description: ""
    property bool showTrend: true
    property bool compact: false
    property real animationDuration: 500

    // اندازه‌ها
    property real iconSize: compact ? 16 : 20
    property real valueSize: compact ? 14 : 18
    property real labelSize: compact ? 10 : 12

    implicitWidth: compact ? 80 : 120
    implicitHeight: compact ? 40 : 60

    ColumnLayout {
        anchors.fill: parent
        spacing: compact ? 2 : 4

        // ردیف اول: آیکون و عنوان
        RowLayout {
            Layout.fillWidth: true

            // آیکون
            Text {
                id: iconText
                text: metricItem.icon
                font.pixelSize: metricItem.iconSize
                color: metricItem.color
                Layout.alignment: Qt.AlignVCenter
                visible: metricItem.icon !== ""
            }

            // عنوان
            Text {
                id: labelText
                text: metricItem.label
                color: theme.textSecondary
                font.pixelSize: metricItem.labelSize
                elide: Text.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }

            // Trend Indicator
            Text {
                id: trendText
                text: getTrendIcon()
                color: getTrendColor()
                font.pixelSize: metricItem.labelSize - 2
                Layout.alignment: Qt.AlignVCenter
                visible: metricItem.showTrend && metricItem.trend !== ""
            }
        }

        // ردیف دوم: مقدار و واحد
        RowLayout {
            Layout.fillWidth: true

            Text {
                id: valueText
                text: metricItem.value
                color: metricItem.color
                font.bold: true
                font.pixelSize: metricItem.valueSize
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                id: unitText
                text: metricItem.unit
                color: theme.textSecondary
                font.pixelSize: metricItem.valueSize - 4
                Layout.alignment: Qt.AlignVCenter
                visible: metricItem.unit !== ""
            }

            Item { Layout.fillWidth: true } // Spacer
        }

        // ردیف سوم: توضیحات (در حالت غیر compact)
        Text {
            id: descriptionText
            text: metricItem.description
            color: theme.textDisabled
            font.pixelSize: metricItem.labelSize - 2
            elide: Text.ElideRight
            Layout.fillWidth: true
            visible: !metricItem.compact && metricItem.description !== ""
        }
    }

    // توابع کمکی
    function getTrendIcon() {
        if (metricItem.trend.startsWith("+")) return "↗️"
        if (metricItem.trend.startsWith("-")) return "↘️"
        if (metricItem.trend.startsWith("=")) return "➡️"
        return metricItem.trend
    }

    function getTrendColor() {
        if (metricItem.trend.startsWith("+")) return "#4CAF50" // سبز برای افزایش
        if (metricItem.trend.startsWith("-")) return "#F44336" // قرمز برای کاهش
        if (metricItem.trend.startsWith("=")) return "#FF9800" // نارنجی برای ثابت
        return theme.textSecondary
    }

    // Public API
    function setValue(newValue, newUnit, animate) {
        if (animate !== false) {
            // در آینده می‌توان انیمیشن اضافه کرد
            value = newValue
            if (newUnit !== undefined) {
                unit = newUnit
            }
        } else {
            value = newValue
            if (newUnit !== undefined) {
                unit = newUnit
            }
        }
    }

    function setTrend(newTrend) {
        trend = newTrend
    }

    function highlight(color, duration) {
        var originalColor = metricItem.color
        metricItem.color = color || "#FFD700"

        if (duration !== 0) {
            highlightTimer.interval = duration || 1000
            highlightTimer.start()
        }
    }

    Timer {
        id: highlightTimer
        onTriggered: {
            metricItem.color = theme.textPrimary
        }
    }
}
