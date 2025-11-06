import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Card {
    id: signalCard
    title: "Live EEG Signals"
    icon: "📈"

    property var channelData: []
    property int samplingRate: 250
    property bool isPlaying: false
    property int currentTime: 0

    contentHeight: 200

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // Controls
        RowLayout {
            Layout.fillWidth: true

            Button {
                text: signalCard.isPlaying ? "⏸️ Pause" : "▶️ Play"
                onClicked: signalCard.isPlaying = !signalCard.isPlaying
            }

            Text {
                text: "Rate: " + signalCard.samplingRate + " Hz"
                color: theme.textSecondary
                font.pixelSize: 12
            }

            Item { Layout.fillWidth: true }

            ComboBox {
                model: ["All Channels", "Fp1", "Fp2", "C3", "C4", "O1", "O2"]
                currentIndex: 0
                Layout.preferredWidth: 120
            }
        }

        // Signal Canvas
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            border.color: theme.border
            border.width: 1
            radius: 4

            Canvas {
                id: signalCanvas
                anchors.fill: parent
                anchors.margins: 2

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var width = signalCanvas.width
                    var height = signalCanvas.height
                    var centerY = height / 2

                    // Draw grid
                    ctx.strokeStyle = theme.backgroundLight
                    ctx.lineWidth = 0.5

                    // Horizontal lines
                    for (var i = 1; i <= 4; i++) {
                        var y = (height / 5) * i
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y)
                        ctx.stroke()
                    }

                    // Vertical lines (time markers)
                    for (var j = 1; j <= 10; j++) {
                        var x = (width / 10) * j
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x, height)
                        ctx.stroke()
                    }

                    if (signalCard.channelData.length === 0) return

                    // Draw signals for each channel
                    var colors = ["#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4", "#FFEAA7", "#DDA0DD"]

                    signalCard.channelData.forEach(function(channel, index) {
                        if (index >= 3) return // Show max 3 channels

                        ctx.strokeStyle = colors[index % colors.length]
                        ctx.lineWidth = 1.5
                        ctx.beginPath()

                        var data = channel.data || []
                        var yOffset = (index - 1) * (height / 3) // Stack channels

                        for (var k = 0; k < data.length; k++) {
                            var x = (k / data.length) * width
                            var y = centerY + yOffset + (data[k] / 100) * (height / 3)

                            if (k === 0) {
                                ctx.moveTo(x, y)
                            } else {
                                ctx.lineTo(x, y)
                            }
                        }

                        ctx.stroke()

                        // Draw channel label
                        ctx.fillStyle = colors[index % colors.length]
                        ctx.font = "10px Arial"
                        ctx.fillText(channel.name, 5, 15 + (index * 15))
                    })
                }
            }
        }

        // Time indicator
        Text {
            text: "Time: " + (signalCard.currentTime / 1000).toFixed(1) + "s"
            color: theme.textSecondary
            font.pixelSize: 11
            Layout.alignment: Qt.AlignRight
        }
    }

    Timer {
        interval: 50
        running: signalCard.isPlaying
        repeat: true
        onTriggered: {
            signalCard.currentTime += 50
            signalCanvas.requestPaint()
        }
    }

    onChannelDataChanged: signalCanvas.requestPaint()
}
