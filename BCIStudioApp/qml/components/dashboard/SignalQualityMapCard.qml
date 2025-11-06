import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Card {
    id: qualityMapCard
    title: "Signal Quality Map"
    icon: "🗺️"

    property var qualityData: []
    property var electrodePositions: []

    contentHeight: 300

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // Legend
        RowLayout {
            Layout.fillWidth: true

            Repeater {
                model: [
                    { color: "#4CAF50", label: "Excellent (80-100%)" },
                    { color: "#8BC34A", label: "Good (60-80%)" },
                    { color: "#FFC107", label: "Fair (40-60%)" },
                    { color: "#FF9800", label: "Poor (20-40%)" },
                    { color: "#F44336", label: "Bad (0-20%)" }
                ]

                RowLayout {
                    spacing: 5

                    Rectangle {
                        width: 12
                        height: 12
                        radius: 2
                        color: modelData.color
                    }

                    Text {
                        text: modelData.label
                        color: theme.textSecondary
                        font.pixelSize: 10
                    }
                }
            }
        }

        // Head Map
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            border.color: theme.border
            border.width: 1
            radius: 8

            Canvas {
                id: headCanvas
                anchors.fill: parent
                anchors.margins: 10

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var width = headCanvas.width
                    var height = headCanvas.height
                    var centerX = width / 2
                    var centerY = height / 2
                    var radius = Math.min(width, height) / 2 - 10

                    // Draw head circle
                    ctx.strokeStyle = theme.textSecondary
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    ctx.arc(centerX, centerY, radius, 0, Math.PI * 2)
                    ctx.stroke()

                    // Draw nose
                    ctx.beginPath()
                    ctx.moveTo(centerX, centerY - radius)
                    ctx.lineTo(centerX - 10, centerY - radius + 20)
                    ctx.lineTo(centerX + 10, centerY - radius + 20)
                    ctx.closePath()
                    ctx.stroke()

                    // Draw ears
                    ctx.beginPath()
                    ctx.arc(centerX - radius - 5, centerY, 15, 0, Math.PI * 2)
                    ctx.stroke()

                    ctx.beginPath()
                    ctx.arc(centerX + radius + 5, centerY, 15, 0, Math.PI * 2)
                    ctx.stroke()

                    // Draw electrodes
                    qualityMapCard.qualityData.forEach(function(electrode, index) {
                        var pos = getElectrodePosition(electrode.channel)
                        if (!pos) return

                        var x = centerX + (pos.x - 0.5) * radius * 1.8
                        var y = centerY + (pos.y - 0.5) * radius * 1.8
                        var electrodeRadius = 15

                        // Draw quality indicator
                        var quality = electrode.quality || 0
                        ctx.fillStyle = getQualityColor(quality)
                        ctx.beginPath()
                        ctx.arc(x, y, electrodeRadius, 0, Math.PI * 2)
                        ctx.fill()

                        // Draw electrode outline
                        ctx.strokeStyle = theme.textPrimary
                        ctx.lineWidth = 1
                        ctx.stroke()

                        // Draw channel label
                        ctx.fillStyle = "white"
                        ctx.font = "bold 10px Arial"
                        ctx.textAlign = "center"
                        ctx.textBaseline = "middle"
                        ctx.fillText(electrode.channel, x, y)

                        // Draw quality percentage
                        ctx.fillStyle = "white"
                        ctx.font = "8px Arial"
                        ctx.fillText(Math.round(quality) + "%", x, y + 15)
                    })
                }
            }
        }

        // Quality Statistics
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Overall Quality: " + getOverallQuality() + "%"
                color: theme.textPrimary
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "Good Channels: " + getGoodChannelsCount() + "/" + qualityMapCard.qualityData.length
                color: theme.textSecondary
                font.pixelSize: 12
            }
        }
    }

    function getElectrodePosition(channel) {
        var pos = qualityMapCard.electrodePositions.find(function(item) {
            return item.label === channel
        })
        return pos || { x: 0.5, y: 0.5 }
    }

    function getQualityColor(quality) {
        if (quality >= 80) return "#4CAF50"
        if (quality >= 60) return "#8BC34A"
        if (quality >= 40) return "#FFC107"
        if (quality >= 20) return "#FF9800"
        return "#F44336"
    }

    function getOverallQuality() {
        if (qualityMapCard.qualityData.length === 0) return 0
        var total = qualityMapCard.qualityData.reduce(function(sum, electrode) {
            return sum + (electrode.quality || 0)
        }, 0)
        return Math.round(total / qualityMapCard.qualityData.length)
    }

    function getGoodChannelsCount() {
        return qualityMapCard.qualityData.filter(function(electrode) {
            return (electrode.quality || 0) >= 60
        }).length
    }

    onQualityDataChanged: headCanvas.requestPaint()
}
