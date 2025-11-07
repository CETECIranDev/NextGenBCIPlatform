// PerformanceMetricsCard.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

DashboardCard {
    id: performanceCard
    title: "Performance Metrics"
    icon: "📊"
    subtitle: "Real-time BCI System Performance"
    headerColor: "#2196F3"
    badgeText: "LIVE"
    badgeColor: "#4CAF50"

    property real classificationAccuracy: 92.5
    property real processingLatency: 45
    property real dataThroughput: 1250
    property real systemReliability: 98.2
    property int activeUsers: 3
    property real cpuUsage: 35.7

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // Main Metrics Grid
        GridLayout {
            Layout.fillWidth: true
            columns: 3
            rowSpacing: 12
            columnSpacing: 12

            MetricGauge {
                title: "Accuracy"
                value: performanceCard.classificationAccuracy
                unit: "%"
                color: "#4CAF50"
                icon: "🎯"
                trend: "+2.1%"
                Layout.fillWidth: true
            }

            MetricGauge {
                title: "Latency"
                value: performanceCard.processingLatency
                unit: "ms"
                color: "#FF9800"
                icon: "⚡"
                trend: "-5ms"
                Layout.fillWidth: true
            }

            MetricGauge {
                title: "Throughput"
                value: performanceCard.dataThroughput
                unit: "Hz"
                color: "#9C27B0"
                icon: "📈"
                trend: "+150Hz"
                Layout.fillWidth: true
            }

            MetricGauge {
                title: "Reliability"
                value: performanceCard.systemReliability
                unit: "%"
                color: "#00BCD4"
                icon: "🛡️"
                trend: "+0.5%"
                Layout.fillWidth: true
            }

            MetricGauge {
                title: "Active Users"
                value: performanceCard.activeUsers
                unit: ""
                color: "#FF4081"
                icon: "👥"
                Layout.fillWidth: true
            }

            MetricGauge {
                title: "CPU Usage"
                value: performanceCard.cpuUsage
                unit: "%"
                color: "#607D8B"
                icon: "💻"
                Layout.fillWidth: true
            }
        }

        // Performance Trends Chart
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            radius: 8
            color: theme.backgroundLight
            border.color: theme.border

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Text {
                    text: "Performance Trends (Last 24h)"
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 12
                }

                // Simple trend chart
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Canvas {
                        id: trendCanvas
                        anchors.fill: parent

                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.reset()

                            var width = trendCanvas.width
                            var height = trendCanvas.height

                            // Draw grid
                            ctx.strokeStyle = theme.border
                            ctx.lineWidth = 0.5
                            ctx.setLineDash([2, 2])

                            // Horizontal lines
                            for (var i = 1; i <= 3; i++) {
                                var y = (height / 4) * i
                                ctx.beginPath()
                                ctx.moveTo(0, y)
                                ctx.lineTo(width, y)
                                ctx.stroke()
                            }

                            ctx.setLineDash([])

                            // Draw trend line
                            var data = [85, 88, 90, 87, 92, 91, 92.5]
                            ctx.strokeStyle = "#2196F3"
                            ctx.lineWidth = 2
                            ctx.beginPath()

                            for (var j = 0; j < data.length; j++) {
                                var x = (width / (data.length - 1)) * j
                                var dataY = height - (data[j] / 100) * height * 0.8

                                if (j === 0) {
                                    ctx.moveTo(x, dataY)
                                } else {
                                    ctx.lineTo(x, dataY)
                                }

                                // Draw data points
                                ctx.fillStyle = "#2196F3"
                                ctx.beginPath()
                                ctx.arc(x, dataY, 3, 0, Math.PI * 2)
                                ctx.fill()
                            }

                            ctx.stroke()
                        }
                    }
                }
            }
        }
    }
    Component.onCompleted: {
            // مطمئن شویم که کارت خالی نیست
            setEmptyState(false)
        }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            // Simulate real-time data updates
            performanceCard.classificationAccuracy = Math.max(85, Math.min(98,
                performanceCard.classificationAccuracy + (Math.random() - 0.5) * 2))
            performanceCard.processingLatency = Math.max(30, Math.min(80,
                performanceCard.processingLatency + (Math.random() - 0.5) * 10))
            performanceCard.dataThroughput = Math.max(1000, Math.min(1500,
                performanceCard.dataThroughput + (Math.random() - 0.5) * 100))
            trendCanvas.requestPaint()
        }
    }
}
