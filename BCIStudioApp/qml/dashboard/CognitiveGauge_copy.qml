// CognitiveGauge.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: gaugeRoot

    // Properties
    property string label: "Metric"
    property real value: 0 // 0-100
    property color color: "#4CAF50"
    property string icon: "📊"
    property bool inverse: false
    property string unit: "%"
    property bool showValue: true
    property bool showTrend: true
    property real animationDuration: 1000

    // اندازه‌ها
    property real gaugeSize: Math.min(width, height) - 40
    property real strokeWidth: 8
    property real fontSize: 12

    // مقادیر داخلی
    property real animatedValue: 0
    property real previousValue: 0
    property real trend: 0 // -1: decreasing, 0: stable, 1: increasing

    implicitWidth: 120
    implicitHeight: 140

    // انیمیشن مقدار
    NumberAnimation {
        id: valueAnimation
        target: gaugeRoot
        property: "animatedValue"
        duration: gaugeRoot.animationDuration
        easing.type: Easing.OutCubic
    }

    onValueChanged: {
        // محاسبه ترند
        gaugeRoot.trend = value > gaugeRoot.previousValue ? 1 :
                         value < gaugeRoot.previousValue ? -1 : 0
        gaugeRoot.previousValue = value

        // شروع انیمیشن
        valueAnimation.from = gaugeRoot.animatedValue
        valueAnimation.to = gaugeRoot.value
        valueAnimation.start()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        // هدر - آیکون و عنوان
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 6

            Text {
                text: gaugeRoot.icon
                font.pixelSize: 16
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                text: gaugeRoot.label
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: gaugeRoot.fontSize
                elide: Text.ElideRight
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
            }
        }

        // گیج دایره‌ای
        Item {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: gaugeRoot.gaugeSize
            Layout.preferredHeight: gaugeRoot.gaugeSize

            // پس‌زمینه گیج
            Shape {
                id: backgroundGauge
                anchors.fill: parent

                ShapePath {
                    strokeWidth: gaugeRoot.strokeWidth
                    strokeColor: theme.backgroundLight
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"

                    PathAngleArc {
                        centerX: parent.width / 2
                        centerY: parent.height / 2
                        radiusX: parent.width / 2 - gaugeRoot.strokeWidth
                        radiusY: parent.height / 2 - gaugeRoot.strokeWidth
                        startAngle: -90
                        sweepAngle: 360
                    }
                }
            }

            // گیج فعال
            Shape {
                id: activeGauge
                anchors.fill: parent

                ShapePath {
                    strokeWidth: gaugeRoot.strokeWidth
                    strokeColor: gaugeRoot.color
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"

                    PathAngleArc {
                        centerX: parent.width / 2
                        centerY: parent.height / 2
                        radiusX: parent.width / 2 - gaugeRoot.strokeWidth
                        radiusY: parent.height / 2 - gaugeRoot.strokeWidth
                        startAngle: -90
                        sweepAngle: (gaugeRoot.animatedValue / 100) * 360
                    }
                }
            }

            // مقدار در مرکز
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 2

                Text {
                    text: Math.round(gaugeRoot.animatedValue)
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: gaugeRoot.fontSize + 4
                    Layout.alignment: Qt.AlignHCenter
                    visible: gaugeRoot.showValue
                }

                Text {
                    text: gaugeRoot.unit
                    color: theme.textSecondary
                    font.pixelSize: gaugeRoot.fontSize - 2
                    Layout.alignment: Qt.AlignHCenter
                    visible: gaugeRoot.showValue
                }
            }

            // نشانگر ترند
            Text {
                anchors {
                    top: parent.top
                    right: parent.right
                    margins: 2
                }
                text: getTrendIcon()
                color: getTrendColor()
                font.pixelSize: gaugeRoot.fontSize
                visible: gaugeRoot.showTrend && gaugeRoot.trend !== 0
            }
        }

        // وضعیت کیفی
        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter

            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: getQualityColor(gaugeRoot.value)
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                text: getQualityText(gaugeRoot.value)
                color: getQualityColor(gaugeRoot.value)
                font.bold: true
                font.pixelSize: gaugeRoot.fontSize - 2
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    // توابع کمکی
    function getTrendIcon() {
        switch(gaugeRoot.trend) {
            case 1: return "↗️"
            case -1: return "↘️"
            default: return "➡️"
        }
    }

    function getTrendColor() {
        if (gaugeRoot.inverse) {
            return gaugeRoot.trend === -1 ? "#4CAF50" :
                   gaugeRoot.trend === 1 ? "#F44336" : theme.textSecondary
        }
        return gaugeRoot.trend === 1 ? "#4CAF50" :
               gaugeRoot.trend === -1 ? "#F44336" : theme.textSecondary
    }

    function getQualityColor(value) {
        if (gaugeRoot.inverse) {
            // برای مقادیر معکوس (مثل fatigue - هرچه کمتر بهتر)
            if (value <= 20) return "#4CAF50"   // عالی
            if (value <= 40) return "#8BC34A"   // خوب
            if (value <= 60) return "#FFC107"   // متوسط
            if (value <= 80) return "#FF9800"   // ضعیف
            return "#F44336"                    // بسیار ضعیف
        }

        // برای مقادیر عادی (مثل attention - هرچه بیشتر بهتر)
        if (value >= 80) return "#4CAF50"   // عالی
        if (value >= 60) return "#8BC34A"   // خوب
        if (value >= 40) return "#FFC107"   // متوسط
        if (value >= 20) return "#FF9800"   // ضعیف
        return "#F44336"                    // بسیار ضعیف
    }

    function getQualityText(value) {
        if (gaugeRoot.inverse) {
            if (value <= 20) return "EXCELLENT"
            if (value <= 40) return "GOOD"
            if (value <= 60) return "FAIR"
            if (value <= 80) return "POOR"
            return "VERY POOR"
        }

        if (value >= 80) return "EXCELLENT"
        if (value >= 60) return "GOOD"
        if (value >= 40) return "FAIR"
        if (value >= 20) return "POOR"
        return "VERY POOR"
    }

    // تابع برای به‌روزرسانی سریع مقدار
    function setValue(newValue, animate) {
        if (animate === undefined) animate = true

        if (animate) {
            gaugeRoot.value = newValue
        } else {
            gaugeRoot.animatedValue = newValue
            gaugeRoot.value = newValue
            gaugeRoot.previousValue = newValue
        }
    }

    // تابع برای ریست گیج
    function reset() {
        setValue(0, false)
    }
}
