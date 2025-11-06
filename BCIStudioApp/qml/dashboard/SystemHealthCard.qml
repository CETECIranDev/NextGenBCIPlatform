import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

DashboardCard {
    id: healthCard
    title: "System Health"
    icon: "❤️"

    property real cpuUsage: 0
    property real memoryUsage: 0
    property real diskUsage: 0
    property real gpuUsage: 0
    property real temperature: 0
    property int processCount: 0
    property string systemStatus: "healthy" // "healthy", "warning", "critical"

    //contentHeight: 180

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        // Overall Status
        RowLayout {
            Layout.fillWidth: true

            StatusIndicator {
                status: healthCard.systemStatus
                text: getSystemStatusText()
                Layout.alignment: Qt.AlignVCenter
            }

            Item { Layout.fillWidth: true }

            Text {
                text: healthCard.processCount + " processes"
                color: theme.textSecondary
                font.pixelSize: 12
            }
        }

        // Health Metrics Grid
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            rowSpacing: 10
            columnSpacing: 15

            // CPU Usage
            HealthMetric {
                label: "CPU"
                value: healthCard.cpuUsage
                unit: "%"
                icon: "⚡"
                warningThreshold: 80
                criticalThreshold: 90
                Layout.fillWidth: true
            }

            // Memory Usage
            HealthMetric {
                label: "Memory"
                value: healthCard.memoryUsage
                unit: "%"
                icon: "💾"
                warningThreshold: 85
                criticalThreshold: 95
                Layout.fillWidth: true
            }

            // Disk Usage
            HealthMetric {
                label: "Disk"
                value: healthCard.diskUsage
                unit: "%"
                icon: "💽"
                warningThreshold: 90
                criticalThreshold: 95
                Layout.fillWidth: true
            }

            // GPU Usage
            HealthMetric {
                label: "GPU"
                value: healthCard.gpuUsage
                unit: "%"
                icon: "🎮"
                warningThreshold: 85
                criticalThreshold: 95
                Layout.fillWidth: true
            }
        }

        // Temperature and Controls
        RowLayout {
            Layout.fillWidth: true

            // Temperature
            RowLayout {
                spacing: 5

                Text {
                    text: "🌡️"
                    font.pixelSize: 14
                }

                Text {
                    text: healthCard.temperature + "°C"
                    color: getTemperatureColor(healthCard.temperature)
                    font.pixelSize: 12
                    font.bold: true
                }
            }

            Item { Layout.fillWidth: true }

            // Controls
            Button {
                text: "Refresh"
                onClicked: refreshHealthData()
                Layout.preferredWidth: 80
            }

            Button {
                text: "Details"
                flat: true
                onClicked: showHealthDetails()
                Layout.preferredWidth: 80
            }
        }
    }

    // Health Metric Component
    component HealthMetric: Item {
        property string label: ""
        property real value: 0
        property string unit: "%"
        property string icon: "📊"
        property real warningThreshold: 80
        property real criticalThreshold: 90

        implicitWidth: 120
        implicitHeight: 40

        RowLayout {
            anchors.fill: parent
            spacing: 8

            // Icon
            Text {
                text: parent.parent.icon
                font.pixelSize: 14
                Layout.alignment: Qt.AlignVCenter
            }

            // Label and Value
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: parent.parent.label
                        color: theme.textSecondary
                        font.pixelSize: 11
                        Layout.fillWidth: true
                    }

                    Text {
                        text: Math.round(parent.parent.value) + parent.parent.unit
                        color: getValueColor(parent.parent.value, parent.parent.warningThreshold, parent.parent.criticalThreshold)
                        font.pixelSize: 11
                        font.bold: true
                    }
                }

                // Progress Bar
                Rectangle {
                    Layout.fillWidth: true
                    height: 4
                    radius: 2
                    color: theme.backgroundLight

                    Rectangle {
                        width: parent.width * (parent.parent.value / 100)
                        height: parent.height
                        radius: 2
                        color: getValueColor(parent.parent.value, parent.parent.warningThreshold, parent.parent.criticalThreshold)

                        Behavior on width {
                            NumberAnimation { duration: 500 }
                        }
                    }
                }
            }
        }

        function getValueColor(value, warning, critical) {
            if (value >= critical) return "#F44336"
            if (value >= warning) return "#FF9800"
            return "#4CAF50"
        }
    }

    // Functions
    function getSystemStatusText() {
        switch(healthCard.systemStatus) {
            case "healthy": return "All Systems Normal"
            case "warning": return "System Under Load"
            case "critical": return "Critical Issues Detected"
            default: return "Status Unknown"
        }
    }

    function getTemperatureColor(temp) {
        if (temp >= 80) return "#F44336"
        if (temp >= 70) return "#FF9800"
        if (temp >= 60) return "#FFC107"
        return "#4CAF50"
    }

    function refreshHealthData() {
        console.log("Refreshing system health data...")
        // در اینجا می‌توانید داده‌های واقعی را از سیستم بخوانید
        healthDataTimer.restart()
    }

    function showHealthDetails() {
        console.log("Showing detailed health information...")
        // می‌توانید دیالوگ یا صفحه جزئیات را اینجا باز کنید
    }

    function calculateOverallStatus() {
        var metrics = [cpuUsage, memoryUsage, diskUsage, gpuUsage]
        var criticalCount = metrics.filter(m => m >= 90).length
        var warningCount = metrics.filter(m => m >= 80 && m < 90).length

        if (criticalCount > 0 || temperature >= 85) {
            return "critical"
        } else if (warningCount > 0 || temperature >= 75) {
            return "warning"
        } else {
            return "healthy"
        }
    }

    // تایمر برای شبیه‌سازی داده‌های real-time
    Timer {
        id: healthDataTimer
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            // شبیه‌سازی داده‌های سیستم
            cpuUsage = Math.max(0, Math.min(100, cpuUsage + (Math.random() * 10 - 3)))
            memoryUsage = Math.max(0, Math.min(100, memoryUsage + (Math.random() * 8 - 2)))
            diskUsage = Math.max(0, Math.min(100, diskUsage + (Math.random() * 5 - 1)))
            gpuUsage = Math.max(0, Math.min(100, gpuUsage + (Math.random() * 12 - 4)))
            temperature = Math.max(30, Math.min(95, temperature + (Math.random() * 4 - 1)))
            processCount = Math.max(50, Math.min(300, processCount + (Math.random() * 20 - 10)))

            // محاسبه وضعیت کلی سیستم
            systemStatus = calculateOverallStatus()
        }
    }

    Component.onCompleted: {
        // مقداردهی اولیه
        cpuUsage = 45
        memoryUsage = 65
        diskUsage = 35
        gpuUsage = 25
        temperature = 55
        processCount = 120
        systemStatus = calculateOverallStatus()
    }
}
