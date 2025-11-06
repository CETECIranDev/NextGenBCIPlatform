// AdvancedCognitiveMetricsCard.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

DashboardCard {
    id: advancedCognitiveCard
    title: "Cognitive State Analysis"
    icon: "🧠"
    subtitle: "Real-time Brain Performance Metrics"

    property real attention: 75
    property real meditation: 60
    property real engagement: 80
    property real fatigue: 25
    property real cognitiveLoad: 45
    property real mentalWorkload: 55

    // وضعیت کلی سیستم
    property string overallStatus: getOverallStatus()

    // تاریخچه داده‌ها برای ترند
    property var history: []
    property int maxHistoryLength: 10

    // محاسبه وضعیت کلی
    function getOverallStatus() {
        var scores = [
            attention,
            meditation, 
            engagement,
            100 - fatigue, // معکوس برای خستگی
            (100 - cognitiveLoad) * 0.8,
            (100 - mentalWorkload) * 0.8
        ]
        
        var avg = scores.reduce((a, b) => a + b, 0) / scores.length
        
        if (avg >= 80) return {text: "OPTIMAL", color: "#4CAF50", icon: "🚀"}
        if (avg >= 65) return {text: "GOOD", color: "#8BC34A", icon: "👍"}
        if (avg >= 50) return {text: "MODERATE", color: "#FFC107", icon: "⚡"}
        if (avg >= 35) return {text: "ATTENTION", color: "#FF9800", icon: "⚠️"}
        return {text: "CRITICAL", color: "#F44336", icon: "🚨"}
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 15

        // هدر وضعیت کلی
        Rectangle {
            Layout.fillWidth: true
            height: 40
            radius: 8
            color: overallStatus.color
            opacity: 0.1
            border.color: overallStatus.color
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                Text {
                    text: overallStatus.icon
                    font.pixelSize: 16
                }

                Text {
                    text: "Overall Status: " + overallStatus.text
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 13
                    Layout.fillWidth: true
                }

                Text {
                    text: {
                        var scores = [attention, meditation, engagement, 100-fatigue]
                        return Math.round(scores.reduce((a, b) => a + b, 0) / scores.length) + "%"
                    }
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 13
                }
            }
        }

        // شبکه گیج‌های اصلی
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: advancedCognitiveCard.width > 400 ? 3 : 2
            rowSpacing: 12
            columnSpacing: 12

            CognitiveGauge {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                label: "Attention"
                value: advancedCognitiveCard.attention
                color: "#4CAF50"
                icon: "🎯"
                unit: "%"
                showTrend: true
            }

            CognitiveGauge {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                label: "Meditation"
                value: advancedCognitiveCard.meditation
                color: "#2196F3"
                icon: "🧘"
                unit: "%"
                showTrend: true
            }

            CognitiveGauge {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                label: "Engagement"
                value: advancedCognitiveCard.engagement
                color: "#FF9800"
                icon: "⚡"
                unit: "%"
                showTrend: true
            }

            CognitiveGauge {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                label: "Fatigue"
                value: advancedCognitiveCard.fatigue
                color: "#9C27B0"
                icon: "😴"
                unit: "%"
                inverse: true
                showTrend: true
            }

            CognitiveGauge {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                label: "Cognitive Load"
                value: advancedCognitiveCard.cognitiveLoad
                color: "#607D8B"
                icon: "💡"
                unit: "%"
                inverse: true
                showTrend: true
            }

            CognitiveGauge {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                label: "Workload"
                value: advancedCognitiveCard.mentalWorkload
                color: "#795548"
                icon: "📊"
                unit: "%"
                inverse: true
                showTrend: true
            }
        }

        // نوار وضعیت پایین
        RowLayout {
            Layout.fillWidth: true
            height: 20
            spacing: 10

            Repeater {
                model: [
                    {color: "#4CAF50", label: "Optimal"},
                    {color: "#8BC34A", label: "Good"}, 
                    {color: "#FFC107", label: "Moderate"},
                    {color: "#FF9800", label: "Attention"},
                    {color: "#F44336", label: "Critical"}
                ]

                RowLayout {
                    spacing: 4

                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: modelData.color
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Text {
                        text: modelData.label
                        color: theme.textSecondary
                        font.pixelSize: 9
                    }
                }
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "Last update: " + Qt.formatTime(new Date(), "hh:mm:ss")
                color: theme.textTertiary
                font.pixelSize: 9
            }
        }
    }

    // مدیریت تاریخچه داده‌ها
    function addToHistory(data) {
        history.push({
            timestamp: new Date(),
            attention: data.attention,
            meditation: data.meditation,
            engagement: data.engagement,
            fatigue: data.fatigue,
            cognitiveLoad: data.cognitiveLoad,
            mentalWorkload: data.mentalWorkload
        })

        if (history.length > maxHistoryLength) {
            history.shift()
        }
    }

    // تایمر برای شبیه‌سازی داده‌های real-time
    Timer {
        id: dataSimulator
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            var newData = {
                attention: simulateValue(attention, 75, 8),
                meditation: simulateValue(meditation, 65, 6),
                engagement: simulateValue(engagement, 80, 10),
                fatigue: simulateValue(fatigue, 25, 5),
                cognitiveLoad: simulateValue(cognitiveLoad, 45, 7),
                mentalWorkload: simulateValue(mentalWorkload, 55, 8)
            }

            attention = newData.attention
            meditation = newData.meditation
            engagement = newData.engagement
            fatigue = newData.fatigue
            cognitiveLoad = newData.cognitiveLoad
            mentalWorkload = newData.mentalWorkload

            addToHistory(newData)
            overallStatus = getOverallStatus()
        }

        function simulateValue(current, target, variability) {
            var randomChange = (Math.random() * variability * 2) - variability
            var drift = (target - current) * 0.15
            var newValue = current + randomChange + drift
            return Math.max(0, Math.min(100, Math.round(newValue * 10) / 10))
        }
    }

    // Tooltip پیشرفته
    ToolTip {
        id: advancedTooltip
        delay: 1000
        
        contentItem: ColumnLayout {
            spacing: 8
            
            Text {
                text: "🧠 Cognitive State Analysis"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 14
                Layout.alignment: Qt.AlignHCenter
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.divider
            }
            
            GridLayout {
                columns: 2
                columnSpacing: 15
                rowSpacing: 5
                
                Text { text: "Attention:"; color: theme.textSecondary; font.pixelSize: 11 }
                Text { text: attention + "%"; color: theme.textPrimary; font.pixelSize: 11 }
                
                Text { text: "Meditation:"; color: theme.textSecondary; font.pixelSize: 11 }
                Text { text: meditation + "%"; color: theme.textPrimary; font.pixelSize: 11 }
                
                Text { text: "Engagement:"; color: theme.textSecondary; font.pixelSize: 11 }
                Text { text: engagement + "%"; color: theme.textPrimary; font.pixelSize: 11 }
                
                Text { text: "Fatigue:"; color: theme.textSecondary; font.pixelSize: 11 }
                Text { text: fatigue + "%"; color: theme.textPrimary; font.pixelSize: 11 }
                
                Text { text: "Cognitive Load:"; color: theme.textSecondary; font.pixelSize: 11 }
                Text { text: cognitiveLoad + "%"; color: theme.textPrimary; font.pixelSize: 11 }
                
                Text { text: "Mental Workload:"; color: theme.textSecondary; font.pixelSize: 11 }
                Text { text: mentalWorkload + "%"; color: theme.textPrimary; font.pixelSize: 11 }
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.divider
            }
            
            Text {
                text: "Overall: " + overallStatus.text
                color: overallStatus.color
                font.bold: true
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: advancedTooltip.visible = true
        onExited: advancedTooltip.visible = false
        cursorShape: Qt.PointingHandCursor
    }

    Component.onCompleted: {
        // مقداردهی اولیه تاریخچه
        var initialData = {
            attention: attention,
            meditation: meditation,
            engagement: engagement,
            fatigue: fatigue,
            cognitiveLoad: cognitiveLoad,
            mentalWorkload: mentalWorkload
        }
        for (let i = 0; i < maxHistoryLength; i++) {
            addToHistory(initialData)
        }
    }
}