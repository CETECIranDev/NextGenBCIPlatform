import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Card {
    id: spectrumCard
    title: "Frequency Spectrum"
    icon: "📊"

    property var bandData: ({})
    property var frequencyRange: [0, 45]
    property bool showDominantFrequency: true

    contentHeight: 200

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // Controls
        RowLayout {
            Layout.fillWidth: true

            Button {
                text: "Refresh"
                onClicked: spectrumCanvas.requestPaint()
            }

            CheckBox {
                text: "Show Dominant"
                checked: spectrumCard.showDominantFrequency
                onCheckedChanged: spectrumCard.showDominantFrequency = checked
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "Range: " + spectrumCard.frequencyRange[0] + "-" + spectrumCard.frequencyRange[1] + "Hz"
                color: theme.textSecondary
                font.pixelSize: 12
            }
        }

        // Spectrum Canvas
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            border.color: theme.border
            border.width: 1
            radius: 4

            Canvas {
                id: spectrumCanvas
                anchors.fill: parent
                anchors.margins: 5

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var width = spectrumCanvas.width
                    var height = spectrumCanvas.height
                    var bands = Object.keys(spectrumCard.bandData)

                    if (bands.length === 0) return

                    // Draw grid
                    ctx.strokeStyle = theme.backgroundLight
                    ctx.lineWidth = 0.5

                    // Vertical lines (frequency markers)
                    for (var i = 1; i <= 10; i++) {
                        var x = (width / 10) * i
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x, height)
                        ctx.stroke()
                    }

                    // Horizontal lines (amplitude markers)
                    for (var j = 1; j <= 4; j++) {
                        var y = (height / 5) * j
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y)
                        ctx.stroke()
                    }

                    // Draw spectrum bars
                    var bandColors = {
                        "delta": "#FF6B6B",
                        "theta": "#4ECDC4",
                        "alpha": "#45B7D1",
                        "beta": "#96CEB4",
                        "gamma": "#FFEAA7"
                    }

                    var barWidth = width / (bands.length * 1.5)
                    var maxPower = 50 // Normalization factor

                    bands.forEach(function(band, index) {
                        var bandInfo = spectrumCard.bandData[band]
                        if (!bandInfo) return

                        var power = bandInfo.power || 0
                        var normalizedPower = Math.min(power / maxPower, 1)
                        var barHeight = normalizedPower * (height - 20)

                        var x = (index * barWidth * 1.5) + (barWidth / 2)
                        var y = height - barHeight - 10

                        // Draw bar
                        ctx.fillStyle = bandColors[band] || "#757575"
                        ctx.fillRect(x, y, barWidth, barHeight)

                        // Draw band label
                        ctx.fillStyle = theme.textPrimary
                        ctx.font = "10px Arial"
                        ctx.textAlign = "center"
                        ctx.fillText(band.toUpperCase(), x + barWidth/2, height - 2)

                        // Draw power value
                        ctx.fillStyle = theme.textSecondary
                        ctx.font = "9px Arial"
                        ctx.fillText(power.toFixed(1), x + barWidth/2, y - 5)

                        // Draw frequency range
                        ctx.fillStyle = theme.textSecondary
                        ctx.font = "8px Arial"
                        var rangeText = bandInfo.range[0] + "-" + bandInfo.range[1] + "Hz"
                        ctx.fillText(rangeText, x + barWidth/2, y - 18)
                    });

                    // Draw dominant frequency line
                    if (spectrumCard.showDominantFrequency) {
                        var dominantBand = getDominantBand()
                        if (dominantBand) {
                            var dominantIndex = bands.indexOf(dominantBand)
                            var lineX = (dominantIndex * barWidth * 1.5) + barWidth

                            ctx.strokeStyle = "#FF4081"
                            ctx.lineWidth = 2
                            ctx.setLineDash([5, 3])
                            ctx.beginPath()
                            ctx.moveTo(lineX, 0)
                            ctx.lineTo(lineX, height)
                            ctx.stroke()
                            ctx.setLineDash([])

                            // Dominant frequency label
                            ctx.fillStyle = "#FF4081"
                            ctx.font = "bold 10px Arial"
                            ctx.textAlign = "center"
                            ctx.fillText("Dominant: " + dominantBand.toUpperCase(), lineX, 15)
                        }
                    }
                }
            }
        }

        // Band Legend
        Flow {
            Layout.fillWidth: true
            spacing: 10

            Repeater {
                model: Object.keys(spectrumCard.bandData)

                RowLayout {
                    spacing: 5

                    Rectangle {
                        width: 12
                        height: 12
                        radius: 2
                        color: getBandColor(modelData)
                    }

                    Text {
                        text: modelData.toUpperCase() + ": " +
                              (spectrumCard.bandData[modelData].power || 0).toFixed(1)
                        color: theme.textSecondary
                        font.pixelSize: 10
                    }
                }
            }
        }
    }

    function getBandColor(band) {
        var colors = {
            "delta": "#FF6B6B",
            "theta": "#4ECDC4",
            "alpha": "#45B7D1",
            "beta": "#96CEB4",
            "gamma": "#FFEAA7"
        }
        return colors[band] || "#757575"
    }

    function getDominantBand() {
        var bands = Object.keys(spectrumCard.bandData)
        if (bands.length === 0) return null

        var dominantBand = bands[0]
        var maxPower = spectrumCard.bandData[dominantBand].power || 0

        bands.forEach(function(band) {
            var power = spectrumCard.bandData[band].power || 0
            if (power > maxPower) {
                maxPower = power
                dominantBand = band
            }
        })

        return dominantBand
    }

    onBandDataChanged: spectrumCanvas.requestPaint()

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: spectrumCanvas.requestPaint()
    }
}
