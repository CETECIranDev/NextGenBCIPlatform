import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

DashboardCard {
    id: gaugesCard
    title: "Cognitive Metrics"
    icon: "🧠"

    subtitle: "Real-time monitoring"
    badgeText: "Live"
    collapsible: true
    expanded: false


    property real attention: 0
    property real meditation: 0
    property real fatigue: 0
    property real engagement: 0

    //contentHeight: 200

    content : GridLayout {
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
            unit: "%"
        }

        CognitiveGauge {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            label: "Meditation"
            value: gaugesCard.meditation
            color: "#2196F3"
            icon: "🧘"
            unit: "%"
        }

        CognitiveGauge {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            label: "Engagement"
            value: gaugesCard.engagement
            color: "#FF9800"
            icon: "⚡"
            unit: "%"
        }

        CognitiveGauge {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            label: "Fatigue"
            value: gaugesCard.fatigue
            color: "#9C27B0"
            icon: "😴"
            unit: "%"
            inverse: true
        }
    }

    // تایمر برای شبیه‌سازی داده‌های real-time (اختیاری)
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            // شبیه‌سازی تغییرات داده‌ها
            attention = Math.max(0, Math.min(100, attention + (Math.random() * 10 - 5)))
            meditation = Math.max(0, Math.min(100, meditation + (Math.random() * 8 - 4)))
            engagement = Math.max(0, Math.min(100, engagement + (Math.random() * 12 - 6)))
            fatigue = Math.max(0, Math.min(100, fatigue + (Math.random() * 6 - 3)))
        }
    }

    Component.onCompleted: {
        // مقداردهی اولیه
        attention = 75
        meditation = 60
        engagement = 80
        fatigue = 25
    }
}
