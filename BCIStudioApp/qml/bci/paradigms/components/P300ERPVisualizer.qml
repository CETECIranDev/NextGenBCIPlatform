import QtQuick
import QtQuick.Layouts

Rectangle {
    id: erpVisualizer

    property bool experimentRunning: false

    color: "#1A1A2E"
    radius: 12
    border.color: "#333344"
    border.width: 2

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 8

        Text {
            text: "ERP COMPONENT ANALYSIS"
            color: "white"
            font.bold: true
            font.pixelSize: 12
        }

        // ERP Chart Area
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#0F0F1A"
            radius: 6
            border.color: "#252540"
            border.width: 1

            Canvas {
                id: erpCanvas
                anchors.fill: parent
                anchors.margins: 10

                property var erpData: []
                property var components: {
                    "N100": { latency: 100, amplitude: -2.5, color: "#2196F3" },
                    "P200": { latency: 200, amplitude: 3.0, color: "#4CAF50" },
                    "N200": { latency: 250, amplitude: -1.5, color: "#FF9800" },
                    "P300": { latency: 300, amplitude: 5.0, color: "#7C4DFF" },
                    "N400": { latency: 400, amplitude: -2.0, color: "#E91E63" }
                }

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var width = erpCanvas.width
                    var height = erpCanvas.height
                    var centerY = height / 2

                    // Draw grid and axes
                    drawGridAndAxes(ctx, width, height, centerY)

                    // Draw ERP waveform
                    drawERPWaveform(ctx, width, height, centerY)

                    // Draw component markers
                    drawComponentMarkers(ctx, width, height, centerY)

                    // Draw stimulus marker
                    drawStimulusMarker(ctx, width, height)
                }

                function drawGridAndAxes(ctx, width, height, centerY) {
                    // Background grid
                    ctx.strokeStyle = "#252540"
                    ctx.lineWidth = 0.5
                    ctx.setLineDash([2, 2])

                    // Vertical lines (time)
                    for (var i = 1; i <= 4; i++) {
                        var x = width * i / 5
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x, height)
                        ctx.stroke()
                    }

                    // Horizontal lines (amplitude)
                    for (var j = 1; j <= 4; j++) {
                        var y = height * j / 5
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y)
                        ctx.stroke()
                    }

                    ctx.setLineDash([])

                    // Axes
                    ctx.strokeStyle = "#666677"
                    ctx.lineWidth = 1

                    // X-axis (time)
                    ctx.beginPath()
                    ctx.moveTo(0, centerY)
                    ctx.lineTo(width, centerY)
                    ctx.stroke()

                    // Y-axis (amplitude)
                    ctx.beginPath()
                    ctx.moveTo(50, 0)
                    ctx.lineTo(50, height)
                    ctx.stroke()

                    // Time labels - استفاده از فونت استاندارد
                    ctx.fillStyle = "#AAAAAA"
                    ctx.font = "9px sans-serif"  // فونت استاندارد
                    for (var t = 0; t <= 500; t += 100) {
                        var x = 50 + (t / 500) * (width - 70)
                        ctx.fillText(t + "ms", x, height - 2)
                    }

                    // Amplitude labels
                    ctx.textAlign = "right"
                    for (var a = -10; a <= 10; a += 5) {
                        var y = centerY - (a / 10) * (height / 2)
                        ctx.fillText(a + "µV", 45, y + 3)
                    }
                    ctx.textAlign = "left"
                }

                function drawERPWaveform(ctx, width, height, centerY) {
                    if (erpData.length === 0) generateERPData()

                    ctx.strokeStyle = "#00BFA5"
                    ctx.lineWidth = 2.5
                    ctx.beginPath()

                    for (var i = 0; i < erpData.length; i++) {
                        var x = 50 + (i / (erpData.length - 1)) * (width - 70)
                        var y = centerY - (erpData[i] / 10) * (height / 2)

                        if (i === 0) {
                            ctx.moveTo(x, y)
                        } else {
                            ctx.lineTo(x, y)
                        }
                    }
                    ctx.stroke()
                }

                function drawComponentMarkers(ctx, width, height, centerY) {
                    for (var comp in components) {
                        var component = components[comp]
                        var x = 50 + (component.latency / 500) * (width - 70)
                        var y = centerY - (component.amplitude / 10) * (height / 2)

                        // Marker point
                        ctx.fillStyle = component.color
                        ctx.beginPath()
                        ctx.arc(x, y, 4, 0, Math.PI * 2)
                        ctx.fill()

                        // Component label with background
                        var labelWidth = ctx.measureText(comp).width
                        ctx.fillStyle = "#1A1A2E"
                        ctx.fillRect(x - labelWidth/2 - 4, y - 20, labelWidth + 8, 14)

                        ctx.fillStyle = component.color
                        ctx.font = "bold 10px sans-serif"  // فونت استاندارد
                        ctx.textAlign = "center"
                        ctx.fillText(comp, x, y - 12)

                        // Amplitude line
                        ctx.strokeStyle = component.color
                        ctx.lineWidth = 1
                        ctx.setLineDash([2, 2])
                        ctx.beginPath()
                        ctx.moveTo(x, centerY)
                        ctx.lineTo(x, y)
                        ctx.stroke()

                        ctx.setLineDash([])
                    }
                }

                function drawStimulusMarker(ctx, width, height) {
                    var centerY = height / 2

                    ctx.strokeStyle = "#FF6D00"
                    ctx.lineWidth = 2
                    ctx.setLineDash([5, 3])

                    var stimulusX = 50
                    ctx.beginPath()
                    ctx.moveTo(stimulusX, 0)
                    ctx.lineTo(stimulusX, height)
                    ctx.stroke()

                    ctx.setLineDash([])

                    ctx.fillStyle = "#FF6D00"
                    ctx.font = "bold 10px sans-serif"  // فونت استاندارد
                    ctx.fillText("Stimulus", stimulusX + 5, 15)
                }

                function generateERPData() {
                    var data = []
                    for (var i = 0; i < 500; i += 5) {
                        var value = 0

                        // Add ERP components
                        for (var comp in components) {
                            var component = components[comp]
                            var gaussian = Math.exp(-Math.pow(i - component.latency, 2) / (2 * Math.pow(25, 2)))
                            value += component.amplitude * gaussian
                        }

                        // Add some noise
                        value += (Math.random() - 0.5) * 0.5
                        data.push(value)
                    }
                    erpData = data
                }

                function updateERP() {
                    // Simulate ERP data changes during experiment
                    if (experimentRunning) {
                        // Enhance P300 component
                        components.P300.amplitude = 5.0 + Math.sin(Date.now() / 1000) * 1.5
                        generateERPData()
                    }
                    requestPaint()
                }
            }
        }

        // Component Legend
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Repeater {
                model: ["N100", "P200", "P300", "N400"]

                LegendItem {
                    component: modelData
                    color: erpCanvas.components[modelData].color
                    latency: erpCanvas.components[modelData].latency
                    amplitude: erpCanvas.components[modelData].amplitude
                    Layout.fillWidth: true
                }
            }
        }
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: erpCanvas.updateERP()
    }
}
