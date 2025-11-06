// AdvancedSpectrumCard.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

DashboardCard {
    id: advancedSpectrumCard
    title: "EEG Frequency Spectrum"
    icon: "📊"
    subtitle: "Real-time Brain Wave Analysis"
    // badgeText: "LIVE"
    // badgeColor: "#9C27B0"

    // Properties
    property var bandData: ({
        "delta": { power: 12.5, range: [0.5, 4], frequency: 2.5, coherence: 0.7 },
        "theta": { power: 8.3, range: [4, 8], frequency: 6.0, coherence: 0.8 },
        "alpha": { power: 15.7, range: [8, 13], frequency: 10.5, coherence: 0.9 },
        "beta": { power: 6.2, range: [13, 30], frequency: 20.0, coherence: 0.6 },
        "gamma": { power: 3.1, range: [30, 45], frequency: 37.5, coherence: 0.5 }
    })

    property var frequencyRange: [0, 45]
    property bool showDominantFrequency: true
    property bool showGrid: true
    property bool showValues: true
    property bool logarithmicScale: false
    property real amplitudeScale: 1.0
    property string displayMode: "bars" // "bars", "line", "area"
    property real updateInterval: 500
    property real peakHoldTime: 3000
    property var peakValues: ({})
    property real dominantFrequency: 0
    property real totalPower: 0

    // Band colors with gradients
    property var bandColors: {
        "delta": {"base": "#FF6B6B", "light": "#FF8A8A", "dark": "#FF5252"},
        "theta": {"base": "#4ECDC4", "light": "#6EDBD4", "dark": "#26A69A"},
        "alpha": {"base": "#45B7D1", "light": "#67C7DE", "dark": "#29B6F6"},
        "beta": {"base": "#96CEB4", "light": "#AEDCC2", "dark": "#81C784"},
        "gamma": {"base": "#FFEAA7", "light": "#FFF1C1", "dark": "#FFD54F"}
    }

    // Signals - با نام‌های منحصربه‌فرد
    signal dominantBandChanged(real frequency, string band)
    signal bandPowerUpdated(string band, real power)
    signal spectrumDataUpdated()

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        // Header Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            // Display Mode Selector
            ButtonGroup { id: displayModeGroup }

            Repeater {
                model: [
                    { mode: "bars", icon: "📊", label: "Bars" },
                    { mode: "line", icon: "📈", label: "Line" },
                    { mode: "area", icon: "🔲", label: "Area" }
                ]

                Button {
                    text: modelData.icon
                    checked: advancedSpectrumCard.displayMode === modelData.mode
                    ButtonGroup.group: displayModeGroup
                    ToolTip.text: modelData.label

                    background: Rectangle {
                        radius: 6
                        color: parent.checked ? theme.primary : "transparent"
                        border.color: parent.checked ? theme.primary : theme.border
                        border.width: 1
                    }

                    onClicked: advancedSpectrumCard.displayMode = modelData.mode
                }
            }

            Item { Layout.fillWidth: true }

            // Scale Controls
            Button {
                text: logarithmicScale ? "📏 Log" : "📏 Linear"
                ToolTip.text: logarithmicScale ? "Linear Scale" : "Logarithmic Scale"
                onClicked: advancedSpectrumCard.logarithmicScale = !advancedSpectrumCard.logarithmicScale

                background: Rectangle {
                    radius: 6
                    color: parent.hovered ? Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1) : "transparent"
                }
            }

            Button {
                text: "🔍+"
                ToolTip.text: "Increase Amplitude"
                onClicked: advancedSpectrumCard.amplitudeScale = Math.min(3.0, advancedSpectrumCard.amplitudeScale + 0.2)
            }

            Button {
                text: "🔍-"
                ToolTip.text: "Decrease Amplitude"
                onClicked: advancedSpectrumCard.amplitudeScale = Math.max(0.5, advancedSpectrumCard.amplitudeScale - 0.2)
            }

            Button {
                text: showGrid ? "⏹️ Grid" : "⏹️ No Grid"
                ToolTip.text: showGrid ? "Hide Grid" : "Show Grid"
                onClicked: advancedSpectrumCard.showGrid = !advancedSpectrumCard.showGrid
            }
        }

        // Spectrum Visualization
        Rectangle {
            id: spectrumContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 8
            color: theme.backgroundLight
            border.color: theme.border
            border.width: 1

            // Advanced Spectrum Canvas
            Canvas {
                id: advancedSpectrumCanvas
                anchors.fill: parent
                anchors.margins: 10
                renderTarget: Canvas.FramebufferObject
                renderStrategy: Canvas.Cooperative

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var width = advancedSpectrumCanvas.width
                    var height = advancedSpectrumCanvas.height
                    var bands = Object.keys(advancedSpectrumCard.bandData)

                    if (bands.length === 0) return

                    // Clear background
                    ctx.fillStyle = "transparent"
                    ctx.fillRect(0, 0, width, height)

                    // Draw grid
                    if (advancedSpectrumCard.showGrid) {
                        drawGrid(ctx, width, height)
                    }

                    // Draw frequency axis
                    drawFrequencyAxis(ctx, width, height)

                    // Draw spectrum based on display mode
                    switch(advancedSpectrumCard.displayMode) {
                        case "bars":
                            drawBarSpectrum(ctx, width, height, bands)
                            break
                        case "line":
                            drawLineSpectrum(ctx, width, height, bands)
                            break
                        case "area":
                            drawAreaSpectrum(ctx, width, height, bands)
                            break
                    }

                    // Draw dominant frequency indicator
                    if (advancedSpectrumCard.showDominantFrequency) {
                        drawDominantFrequency(ctx, width, height, bands)
                    }

                    // Draw peak values
                    if (advancedSpectrumCard.showValues) {
                        drawPeakValues(ctx, width, height, bands)
                    }
                }

                function drawGrid(ctx, width, height) {
                    ctx.strokeStyle = Qt.rgba(0, 0, 0, 0.1)
                    ctx.lineWidth = 0.5
                    ctx.setLineDash([2, 2])

                    // Vertical grid lines
                    for (var i = 1; i <= 9; i++) {
                        var x = (width / 10) * i
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x, height)
                        ctx.stroke()
                    }

                    // Horizontal grid lines
                    for (var j = 1; j <= 4; j++) {
                        var y = (height / 5) * j
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y)
                        ctx.stroke()
                    }

                    ctx.setLineDash([])
                }

                function drawFrequencyAxis(ctx, width, height) {
                    ctx.strokeStyle = theme.textSecondary
                    ctx.lineWidth = 1
                    ctx.fillStyle = theme.textSecondary
                    ctx.font = "9px Arial"

                    // Frequency labels
                    var freqStep = (advancedSpectrumCard.frequencyRange[1] - advancedSpectrumCard.frequencyRange[0]) / 10
                    for (var i = 0; i <= 10; i++) {
                        var freq = advancedSpectrumCard.frequencyRange[0] + (i * freqStep)
                        var x = (width / 10) * i

                        ctx.beginPath()
                        ctx.moveTo(x, height - 5)
                        ctx.lineTo(x, height)
                        ctx.stroke()

                        ctx.textAlign = "center"
                        ctx.fillText(freq.toFixed(0) + "Hz", x, height + 12)
                    }
                }

                function drawBarSpectrum(ctx, width, height, bands) {
                    var barWidth = width / (bands.length * 1.8)
                    var maxPower = getMaxPower()

                    bands.forEach(function(band, index) {
                        var bandInfo = advancedSpectrumCard.bandData[band]
                        if (!bandInfo) return

                        var power = bandInfo.power || 0
                        var normalizedPower = advancedSpectrumCard.logarithmicScale ?
                            Math.log10(power + 1) / Math.log10(maxPower + 1) :
                            power / maxPower

                        var barHeight = Math.min(normalizedPower * (height - 30) * advancedSpectrumCard.amplitudeScale, height - 30)
                        var x = (index * barWidth * 1.8) + (barWidth * 0.4)
                        var y = height - barHeight - 15

                        // Create gradient for bar
                        var gradient = ctx.createLinearGradient(x, y, x, y + barHeight)
                        gradient.addColorStop(0, advancedSpectrumCard.bandColors[band].light)
                        gradient.addColorStop(1, advancedSpectrumCard.bandColors[band].dark)

                        // Draw bar with shadow effect
                        ctx.fillStyle = gradient
                        ctx.fillRect(x, y, barWidth, barHeight)

                        // Draw bar border
                        ctx.strokeStyle = advancedSpectrumCard.bandColors[band].base
                        ctx.lineWidth = 1
                        ctx.strokeRect(x, y, barWidth, barHeight)

                        // Draw band label
                        if (advancedSpectrumCard.showValues) {
                            ctx.fillStyle = theme.textPrimary
                            ctx.font = "bold 10px Arial"
                            ctx.textAlign = "center"
                            ctx.fillText(band.toUpperCase(), x + barWidth/2, height - 2)

                            // Draw power value
                            ctx.fillStyle = theme.textSecondary
                            ctx.font = "9px Arial"
                            ctx.fillText(power.toFixed(1) + "µV²", x + barWidth/2, y - 8)
                        }

                        // Update peak values
                        updatePeakValue(band, power, x + barWidth/2, y)
                    })
                }

                function drawLineSpectrum(ctx, width, height, bands) {
                    var pointSpacing = width / (bands.length - 1)
                    var maxPower = getMaxPower()

                    ctx.strokeStyle = theme.primary
                    ctx.lineWidth = 2
                    ctx.beginPath()

                    bands.forEach(function(band, index) {
                        var bandInfo = advancedSpectrumCard.bandData[band]
                        if (!bandInfo) return

                        var power = bandInfo.power || 0
                        var normalizedPower = advancedSpectrumCard.logarithmicScale ?
                            Math.log10(power + 1) / Math.log10(maxPower + 1) :
                            power / maxPower

                        var y = height - 15 - (normalizedPower * (height - 30) * advancedSpectrumCard.amplitudeScale)
                        var x = index * pointSpacing

                        if (index === 0) {
                            ctx.moveTo(x, y)
                        } else {
                            ctx.lineTo(x, y)
                        }
                    })

                    ctx.stroke()

                    // Draw points
                    bands.forEach(function(band, index) {
                        var bandInfo = advancedSpectrumCard.bandData[band]
                        if (!bandInfo) return

                        var power = bandInfo.power || 0
                        var normalizedPower = advancedSpectrumCard.logarithmicScale ?
                            Math.log10(power + 1) / Math.log10(maxPower + 1) :
                            power / maxPower

                        var y = height - 15 - (normalizedPower * (height - 30) * advancedSpectrumCard.amplitudeScale)
                        var x = index * pointSpacing

                        ctx.fillStyle = advancedSpectrumCard.bandColors[band].base
                        ctx.beginPath()
                        ctx.arc(x, y, 4, 0, Math.PI * 2)
                        ctx.fill()

                        if (advancedSpectrumCard.showValues) {
                            ctx.fillStyle = theme.textSecondary
                            ctx.font = "9px Arial"
                            ctx.textAlign = "center"
                            ctx.fillText(power.toFixed(1), x, y - 10)
                        }
                    })
                }

                function drawAreaSpectrum(ctx, width, height, bands) {
                    var pointSpacing = width / (bands.length - 1)
                    var maxPower = getMaxPower()

                    // Create gradient for area fill
                    var gradient = ctx.createLinearGradient(0, 0, 0, height)
                    gradient.addColorStop(0, Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.3))
                    gradient.addColorStop(1, Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1))

                    ctx.fillStyle = gradient
                    ctx.beginPath()

                    // Start from bottom left
                    ctx.moveTo(0, height - 15)

                    bands.forEach(function(band, index) {
                        var bandInfo = advancedSpectrumCard.bandData[band]
                        if (!bandInfo) return

                        var power = bandInfo.power || 0
                        var normalizedPower = advancedSpectrumCard.logarithmicScale ?
                            Math.log10(power + 1) / Math.log10(maxPower + 1) :
                            power / maxPower

                        var y = height - 15 - (normalizedPower * (height - 30) * advancedSpectrumCard.amplitudeScale)
                        var x = index * pointSpacing

                        ctx.lineTo(x, y)
                    })

                    // Complete the area path
                    ctx.lineTo(width, height - 15)
                    ctx.closePath()
                    ctx.fill()

                    // Draw line on top
                    ctx.strokeStyle = theme.primary
                    ctx.lineWidth = 2
                    ctx.stroke()
                }

                function drawDominantFrequency(ctx, width, height, bands) {
                    var dominantBand = getDominantBand()
                    if (!dominantBand) return

                    var bandIndex = bands.indexOf(dominantBand)
                    var pointSpacing = width / (bands.length - 1)
                    var x = advancedSpectrumCard.displayMode === "bars" ?
                           (bandIndex * (width / bands.length * 1.8) + (width / bands.length * 0.9)) :
                           (bandIndex * pointSpacing)

                    ctx.strokeStyle = "#FF4081"
                    ctx.lineWidth = 2
                    ctx.setLineDash([5, 3])
                    ctx.beginPath()
                    ctx.moveTo(x, 0)
                    ctx.lineTo(x, height)
                    ctx.stroke()
                    ctx.setLineDash([])

                    // Dominant frequency label
                    ctx.fillStyle = "#FF4081"
                    ctx.font = "bold 11px Arial"
                    ctx.textAlign = "center"
                    ctx.fillText("★ " + dominantBand.toUpperCase() + " " +
                                advancedSpectrumCard.bandData[dominantBand].power.toFixed(1) + "µV²",
                                x, 15)
                }

                function drawPeakValues(ctx, width, height, bands) {
                    bands.forEach(function(band) {
                        var peakInfo = advancedSpectrumCard.peakValues[band]
                        if (peakInfo && peakInfo.timestamp > Date.now() - advancedSpectrumCard.peakHoldTime) {
                            ctx.fillStyle = advancedSpectrumCard.bandColors[band].dark
                            ctx.font = "bold 9px Arial"
                            ctx.textAlign = "center"
                            ctx.fillText("PEAK: " + peakInfo.value.toFixed(1), peakInfo.x, peakInfo.y - 20)

                            // Draw peak indicator dot
                            ctx.beginPath()
                            ctx.arc(peakInfo.x, peakInfo.y, 3, 0, Math.PI * 2)
                            ctx.fill()
                        }
                    })
                }

                function getMaxPower() {
                    var maxPower = 0
                    var bands = Object.keys(advancedSpectrumCard.bandData)
                    bands.forEach(function(band) {
                        var power = advancedSpectrumCard.bandData[band].power || 0
                        if (power > maxPower) maxPower = power
                    })
                    return Math.max(maxPower, 1) // Avoid division by zero
                }

                function updatePeakValue(band, power, x, y) {
                    var currentPeak = advancedSpectrumCard.peakValues[band]
                    if (!currentPeak || power > currentPeak.value) {
                        advancedSpectrumCard.peakValues[band] = {
                            value: power,
                            x: x,
                            y: y,
                            timestamp: Date.now()
                        }
                    }
                }
            }

            // Scale indicator
            Text {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 8
                text: advancedSpectrumCard.logarithmicScale ? "Log Scale" : "Linear Scale"
                color: theme.textTertiary
                font.pixelSize: 10
                font.bold: true
            }
        }

        // Band Information Panel
        GridLayout {
            Layout.fillWidth: true
            columns: 5
            rowSpacing: 8
            columnSpacing: 8

            Repeater {
                model: Object.keys(advancedSpectrumCard.bandData)

                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: 6
                    color: Qt.rgba(
                        advancedSpectrumCard.bandColors[modelData].base.r,
                        advancedSpectrumCard.bandColors[modelData].base.g,
                        advancedSpectrumCard.bandColors[modelData].base.b,
                        0.1
                    )
                    border.color: advancedSpectrumCard.bandColors[modelData].base
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 2

                        Text {
                            text: modelData.toUpperCase()
                            color: advancedSpectrumCard.bandColors[modelData].base
                            font.bold: true
                            font.pixelSize: 10
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: (advancedSpectrumCard.bandData[modelData].power || 0).toFixed(1) + " µV²"
                            color: theme.textPrimary
                            font.pixelSize: 9
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: advancedSpectrumCard.bandData[modelData].range[0] + "-" +
                                  advancedSpectrumCard.bandData[modelData].range[1] + "Hz"
                            color: theme.textSecondary
                            font.pixelSize: 8
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    // Coherence indicator
                    Rectangle {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 4
                        width: 6
                        height: 6
                        radius: 3
                        color: {
                            var coherence = advancedSpectrumCard.bandData[modelData].coherence || 0
                            return coherence > 0.7 ? "#4CAF50" : coherence > 0.4 ? "#FFC107" : "#F44336"
                        }
                        ToolTip.text: "Coherence: " + (advancedSpectrumCard.bandData[modelData].coherence || 0).toFixed(2)
                    }
                }
            }
        }

        // Footer Statistics
        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Text {
                text: "Total Power: " + advancedSpectrumCard.totalPower.toFixed(1) + " µV²"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 11
            }

            Text {
                text: "Dominant: " + (getDominantBand() || "N/A") + " (" + advancedSpectrumCard.dominantFrequency.toFixed(1) + "Hz)"
                color: "#FF4081"
                font.bold: true
                font.pixelSize: 11
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "Scale: " + advancedSpectrumCard.amplitudeScale.toFixed(1) + "x"
                color: theme.textSecondary
                font.pixelSize: 10
            }
        }
    }

    // Helper Functions
    function getDominantBand() {
        var bands = Object.keys(bandData)
        if (bands.length === 0) return null

        var dominantBand = bands[0]
        var maxPower = bandData[dominantBand].power || 0

        bands.forEach(function(band) {
            var power = bandData[band].power || 0
            if (power > maxPower) {
                maxPower = power
                dominantBand = band
            }
        })

        // Update dominant frequency
        var dominantFreq = bandData[dominantBand].frequency || 0
        if (dominantFreq !== dominantFrequency) {
            dominantFrequency = dominantFreq
            dominantBandChanged(dominantFreq, dominantBand)
        }

        return dominantBand
    }

    function calculateTotalPower() {
        var total = 0
        var bands = Object.keys(bandData)
        bands.forEach(function(band) {
            total += bandData[band].power || 0
        })
        return total
    }

    // Public API Methods
    function setBandPower(band, power, coherence) {
        if (bandData[band]) {
            bandData[band].power = power
            if (coherence !== undefined) {
                bandData[band].coherence = coherence
            }
            bandPowerUpdated(band, power)
            updateSpectrum()
        }
    }

    function updateBandData(newBandData) {
        bandData = newBandData
        updateSpectrum()
    }

    function updateSpectrum() {
        totalPower = calculateTotalPower()
        getDominantBand() // This will update dominantFrequency
        advancedSpectrumCanvas.requestPaint()
        spectrumDataUpdated()
    }

    function resetPeaks() {
        peakValues = {}
    }

    function simulateData() {
        var bands = Object.keys(bandData)
        bands.forEach(function(band) {
            var change = (Math.random() - 0.5) * 3
            var newPower = Math.max(0, (bandData[band].power || 0) + change)
            var newCoherence = Math.max(0, Math.min(1, (bandData[band].coherence || 0.5) + (Math.random() - 0.5) * 0.1))

            setBandPower(band, newPower, newCoherence)
        })
    }

    // Auto-update timer
    Timer {
        interval: advancedSpectrumCard.updateInterval
        running: true
        repeat: true
        onTriggered: advancedSpectrumCard.simulateData()
    }

    // Peak hold timer
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: advancedSpectrumCanvas.requestPaint()
    }

    Component.onCompleted: {
        console.log("Advanced Spectrum Analyzer initialized")
        updateSpectrum()
    }
}
