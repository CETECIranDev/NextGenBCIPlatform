import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: signalVisualizer

    property var frequencies: [8, 10, 12, 14]
    property bool isRunning: false
    property real noiseLevel: 0.1
    property real signalAmplitude: 1.0
    property int samplingRate: 250
    property real timeWindow: 4.0 // seconds

    // Signal data properties
    property var signalData: []
    property var frequencyComponents: ({})
    property var snrValues: ({})

    Rectangle {
        anchors.fill: parent
        color: theme.backgroundCard
        radius: 8

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            // Header
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "🧠 SSVEP Signal Analysis"
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 14
                    font.family: "Segoe UI"
                }

                Item { Layout.fillWidth: true }

                // Signal quality indicator
                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: getSignalQualityColor()

                    SequentialAnimation on scale {
                        running: signalVisualizer.isRunning
                        loops: Animation.Infinite
                        NumberAnimation { from: 1.0; to: 1.5; duration: 1000 }
                        NumberAnimation { from: 1.5; to: 1.0; duration: 1000 }
                    }
                }

                Text {
                    text: "Live"
                    color: signalVisualizer.isRunning ? "#00C853" : theme.textTertiary
                    font.pixelSize: 10
                    font.bold: true
                }
            }

            // Main signal canvas
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: theme.backgroundPrimary
                radius: 4
                border.color: theme.border
                border.width: 1

                Canvas {
                    id: signalCanvas
                    anchors.fill: parent
                    anchors.margins: 8

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()

                        var width = signalCanvas.width
                        var height = signalCanvas.height
                        var centerY = height / 2

                        // Draw grid
                        drawGrid(ctx, width, height)

                        // Draw signal
                        drawSignal(ctx, width, height, centerY)

                        // Draw frequency markers
                        drawFrequencyMarkers(ctx, width, height)

                        // Draw cursor and measurements
                        drawCursor(ctx, width, height, centerY)
                    }

                    function drawGrid(ctx, width, height) {
                        ctx.strokeStyle = theme.border
                        ctx.lineWidth = 0.5
                        ctx.setLineDash([2, 2])

                        // Horizontal grid lines
                        for (var i = 1; i <= 4; i++) {
                            var y = height * i / 5
                            ctx.beginPath()
                            ctx.moveTo(0, y)
                            ctx.lineTo(width, y)
                            ctx.stroke()
                        }

                        // Vertical grid lines (time markers)
                        ctx.setLineDash([])
                        ctx.strokeStyle = theme.border
                        ctx.lineWidth = 1

                        for (var j = 1; j <= 4; j++) {
                            var x = width * j / 5
                            ctx.beginPath()
                            ctx.moveTo(x, 0)
                            ctx.lineTo(x, height)
                            ctx.stroke()

                            // Time labels
                            ctx.fillStyle = theme.textSecondary
                            ctx.font = "9px Segoe UI"
                            ctx.textAlign = "center"
                            ctx.fillText((timeWindow * j / 5).toFixed(1) + "s", x, height - 2)
                        }
                    }

                    function drawSignal(ctx, width, height, centerY) {
                        if (signalVisualizer.signalData.length === 0) return

                        var points = []
                        var amplitudeScale = height * 0.4

                        // Generate or use existing signal data
                        for (var i = 0; i < width; i++) {
                            var t = (i / width) * timeWindow
                            var signalValue = calculateSSVEPSignal(t)
                            points.push({x: i, y: centerY - signalValue * amplitudeScale})
                        }

                        // Draw signal line
                        ctx.strokeStyle = "#00BFA5"
                        ctx.lineWidth = 2
                        ctx.beginPath()

                        for (var j = 0; j < points.length; j++) {
                            if (j === 0) {
                                ctx.moveTo(points[j].x, points[j].y)
                            } else {
                                ctx.lineTo(points[j].x, points[j].y)
                            }
                        }
                        ctx.stroke()

                        // Draw envelope for active frequencies
                        drawSignalEnvelope(ctx, width, height, centerY, amplitudeScale)
                    }

                    function drawSignalEnvelope(ctx, width, height, centerY, amplitudeScale) {
                        if (!signalVisualizer.isRunning) return

                        // Draw envelope for each frequency component
                        signalVisualizer.frequencies.forEach(function(freq, index) {
                            var color = getFrequencyColor(freq)
                            var alpha = signalVisualizer.frequencyComponents[freq] || 0.1

                            ctx.strokeStyle = Qt.rgba(
                                parseInt(color.substring(1, 3), 16) / 255,
                                parseInt(color.substring(3, 5), 16) / 255,
                                parseInt(color.substring(5, 7), 16) / 255,
                                alpha
                            )
                            ctx.lineWidth = 1
                            ctx.setLineDash([3, 3])
                            ctx.beginPath()

                            for (var i = 0; i < width; i++) {
                                var t = (i / width) * timeWindow
                                var envelopeValue = Math.sin(2 * Math.PI * freq * t) * alpha * 0.8
                                var y = centerY - envelopeValue * amplitudeScale

                                if (i === 0) {
                                    ctx.moveTo(i, y)
                                } else {
                                    ctx.lineTo(i, y)
                                }
                            }
                            ctx.stroke()
                        })

                        ctx.setLineDash([])
                    }

                    function drawFrequencyMarkers(ctx, width, height) {
                        var markerHeight = 12

                        signalVisualizer.frequencies.forEach(function(freq, index) {
                            var x = width * (0.1 + 0.2 * index)
                            var color = getFrequencyColor(freq)
                            var amplitude = signalVisualizer.frequencyComponents[freq] || 0

                            // Frequency marker
                            ctx.fillStyle = color
                            ctx.fillRect(x - 1, height - markerHeight, 2, markerHeight)

                            // Frequency label
                            ctx.fillStyle = theme.textPrimary
                            ctx.font = "bold 10px Segoe UI"
                            ctx.textAlign = "center"
                            ctx.fillText(freq + " Hz", x, height - markerHeight - 2)

                            // Amplitude indicator
                            if (amplitude > 0.1) {
                                var indicatorWidth = amplitude * 20
                                ctx.fillStyle = color
                                ctx.fillRect(x - indicatorWidth/2, 4, indicatorWidth, 3)

                                // SNR value
                                var snr = signalVisualizer.snrValues[freq] || 0
                                ctx.fillStyle = theme.textSecondary
                                ctx.font = "9px Segoe UI"
                                ctx.fillText("SNR: " + snr.toFixed(1) + "dB", x, 16)
                            }
                        })
                    }

                    function drawCursor(ctx, width, height, centerY) {
                        if (!cursorArea.containsMouse) return

                        var mouseX = cursorArea.mouseX
                        var t = (mouseX / width) * timeWindow
                        var signalValue = calculateSSVEPSignal(t)

                        // Vertical cursor line
                        ctx.strokeStyle = "#FFFFFF"
                        ctx.lineWidth = 1
                        ctx.setLineDash([2, 2])
                        ctx.beginPath()
                        ctx.moveTo(mouseX, 0)
                        ctx.lineTo(mouseX, height)
                        ctx.stroke()

                        // Measurement point
                        ctx.fillStyle = "#FF6D00"
                        ctx.beginPath()
                        ctx.arc(mouseX, centerY - signalValue * height * 0.4, 3, 0, Math.PI * 2)
                        ctx.fill()

                        // Measurement text
                        ctx.fillStyle = theme.textPrimary
                        ctx.font = "10px Segoe UI"
                        ctx.textAlign = "left"
                        ctx.fillText("t: " + t.toFixed(2) + "s", mouseX + 5, 15)
                        ctx.fillText("A: " + signalValue.toFixed(3), mouseX + 5, 28)

                        ctx.setLineDash([])
                    }
                }

                // Mouse area for cursor interaction
                MouseArea {
                    id: cursorArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.CrossCursor

                    onPositionChanged: {
                        signalCanvas.requestPaint()
                    }
                }
            }

            // Frequency analysis bar
            Rectangle {
                Layout.fillWidth: true
                height: 40
                color: theme.backgroundLight
                radius: 4

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4

                    Repeater {
                        model: signalVisualizer.frequencies

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 2
                            color: theme.backgroundCard

                            property real amplitude: signalVisualizer.frequencyComponents[modelData] || 0
                            property real snr: signalVisualizer.snrValues[modelData] || 0

                            ColumnLayout {
                                anchors.fill: parent
                                spacing: 2

                                // Frequency label
                                Text {
                                    text: modelData + " Hz"
                                    color: theme.textPrimary
                                    font.bold: true
                                    font.pixelSize: 9
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                // Amplitude bar
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 8
                                    radius: 1
                                    color: theme.border

                                    Rectangle {
                                        width: parent.width * amplitude
                                        height: parent.height
                                        radius: 1
                                        color: getFrequencyColor(modelData)

                                        Behavior on width {
                                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                                        }
                                    }
                                }

                                // SNR value
                                Text {
                                    text: "SNR: " + snr.toFixed(1)
                                    color: snr > 2 ? "#00C853" : theme.textTertiary
                                    font.pixelSize: 8
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }
                    }
                }
            }

            // Statistics row
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                StatBox {
                    label: "Dominant Freq"
                    value: getDominantFrequency()
                    unit: "Hz"
                    color: "#00BFA5"
                }

                StatBox {
                    label: "Avg SNR"
                    value: getAverageSNR().toFixed(1)
                    unit: "dB"
                    color: "#7C4DFF"
                }

                StatBox {
                    label: "Signal Power"
                    value: getSignalPower().toFixed(1)
                    unit: "μV²"
                    color: "#FF6D00"
                }

                StatBox {
                    label: "Noise Floor"
                    value: (signalVisualizer.noiseLevel * 100).toFixed(0)
                    unit: "%"
                    color: "#9E9E9E"
                }
            }
        }
    }

    // Signal generation and analysis
    function calculateSSVEPSignal(t) {
        var signal = 0
        var noise = (Math.random() - 0.5) * 2 * noiseLevel

        // Generate SSVEP signal with multiple frequency components
        signalVisualizer.frequencies.forEach(function(freq) {
            var amplitude = signalVisualizer.frequencyComponents[freq] || 0.1
            signal += amplitude * Math.sin(2 * Math.PI * freq * t)
        })

        // Add harmonics
        signal += 0.3 * Math.sin(2 * Math.PI * 2 * getDominantFrequency() * t)
        signal += 0.2 * Math.sin(2 * Math.PI * 3 * getDominantFrequency() * t)

        return signal * signalVisualizer.signalAmplitude + noise
    }

    function updateSignalAnalysis() {
        if (!signalVisualizer.isRunning) return

        // Simulate frequency component analysis
        var components = {}
        var snrValues = {}

        signalVisualizer.frequencies.forEach(function(freq) {
            // Simulate varying amplitudes based on "attention"
            var baseAmplitude = 0.3 + 0.3 * Math.sin(Date.now() / 2000 + freq)
            var noise = Math.random() * 0.1

            components[freq] = Math.max(0.1, baseAmplitude + noise)
            snrValues[freq] = 1 + baseAmplitude * 10 + Math.random() * 2
        })

        signalVisualizer.frequencyComponents = components
        signalVisualizer.snrValues = snrValues
    }

    function getDominantFrequency() {
        var maxAmp = 0
        var dominantFreq = signalVisualizer.frequencies[0]

        for (var freq in signalVisualizer.frequencyComponents) {
            if (signalVisualizer.frequencyComponents[freq] > maxAmp) {
                maxAmp = signalVisualizer.frequencyComponents[freq]
                dominantFreq = freq
            }
        }

        return dominantFreq
    }

    function getAverageSNR() {
        var total = 0
        var count = 0

        for (var freq in signalVisualizer.snrValues) {
            total += signalVisualizer.snrValues[freq]
            count++
        }

        return count > 0 ? total / count : 0
    }

    function getSignalPower() {
        var power = 0
        for (var freq in signalVisualizer.frequencyComponents) {
            power += Math.pow(signalVisualizer.frequencyComponents[freq], 2)
        }
        return power * 100
    }

    function getSignalQualityColor() {
        var avgSNR = getAverageSNR()
        if (avgSNR > 5) return "#00C853"
        if (avgSNR > 2) return "#FFD600"
        return "#FF5252"
    }

    function getFrequencyColor(frequency) {
        var colors = ["#7C4DFF", "#00BFA5", "#FF6D00", "#E91E63", "#9C27B0", "#3F51B5"]
        var index = signalVisualizer.frequencies.indexOf(frequency) % colors.length
        return colors[index]
    }

    // Animation timer for real-time updates
    Timer {
        interval: 50 // 20 FPS for smooth animation
        running: true
        repeat: true
        onTriggered: {
            updateSignalAnalysis()
            signalCanvas.requestPaint()
        }
    }

    Component.onCompleted: {
        // Initialize frequency components
        var components = {}
        signalVisualizer.frequencies.forEach(function(freq) {
            components[freq] = 0.1
        })
        signalVisualizer.frequencyComponents = components
    }
}

