import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

DashboardCard {
    id: advancedSignalCard
    title: "Live EEG Signals"
    icon: "📈"
    subtitle: "Real-time Brain Signal Visualization"

    // Properties
    property int samplingRate: 250
    property bool isPlaying: false
    property int currentTime: 0
    property real timeWindow: 5.0 // seconds of data to display
    property real amplitudeScale: 1.0
    property int visibleChannels: 6
    property bool showGrid: true
    property bool showChannelLabels: true
    property bool autoScale: true

    // Signal processing properties
    property real noiseThreshold: 0.1
    property bool applyFilter: true
    property string filterType: "bandpass"
    property real filterLowCut: 1.0
    property real filterHighCut: 40.0

    // Channel data with real-time simulation
    property var channelData: generateChannelData()
    property var channelColors: ["#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4", "#FFEAA7", "#DDA0DD", "#FFA726", "#7E57C2"]
    property var channelNames: ["Fp1", "Fp2", "C3", "C4", "O1", "O2", "T3", "T4"]

    // Performance optimization
    property int dataPointsPerChannel: Math.floor(samplingRate * timeWindow)
    property real updateInterval: 1000 / 60 // 60 FPS

    content: ColumnLayout {
        id: mainLayout
        spacing: 12

        // Control Panel
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            // Play/Pause controls
            Button {
                text: advancedSignalCard.isPlaying ? "⏸️ Pause" : "▶️ Play"
                onClicked: advancedSignalCard.isPlaying = !advancedSignalCard.isPlaying

                background: Rectangle {
                    radius: 6
                    color: advancedSignalCard.isPlaying ? "#4CAF50" : "#2196F3"
                }
            }

            // Recording indicator
            StatusIndicator {
                status: advancedSignalCard.isPlaying ? "recording" : "paused"
                text: advancedSignalCard.isPlaying ? "Recording" : "Paused"
                pulseAnimation: advancedSignalCard.isPlaying
            }

            Item { Layout.fillWidth: true }

            // Sampling rate selector
            ComboBox {
                model: [125, 250, 500, 1000]
                currentIndex: 1
                onCurrentValueChanged: advancedSignalCard.samplingRate = currentValue
                Layout.preferredWidth: 100

                ToolTip.text: "Sampling Rate"
            }

            // Channel selector
            ComboBox {
                model: ["All Channels", "Frontal", "Central", "Occipital", "Temporal"]
                currentIndex: 0
                Layout.preferredWidth: 120

                ToolTip.text: "Channel Group"
            }

            // Scale controls
            Button {
                text: "🔍+"
                onClicked: advancedSignalCard.amplitudeScale = Math.min(3.0, advancedSignalCard.amplitudeScale + 0.2)
                ToolTip.text: "Increase Amplitude"
            }

            Button {
                text: "🔍-"
                onClicked: advancedSignalCard.amplitudeScale = Math.max(0.2, advancedSignalCard.amplitudeScale - 0.2)
                ToolTip.text: "Decrease Amplitude"
            }

            Button {
                text: advancedSignalCard.showGrid ? "📊" : "📈"
                onClicked: advancedSignalCard.showGrid = !advancedSignalCard.showGrid
                ToolTip.text: advancedSignalCard.showGrid ? "Hide Grid" : "Show Grid"
            }
        }

        // Signal Visualization Area
        Rectangle {
            id: signalContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            border.color: theme.border
            border.width: 1
            radius: 6

            // Signal Canvas
            Canvas {
                id: signalCanvas
                anchors.fill: parent
                anchors.margins: 8

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()

                    var width = signalCanvas.width
                    var height = signalCanvas.height
                    var channelHeight = height / advancedSignalCard.visibleChannels

                    // Clear background
                    ctx.fillStyle = "transparent"
                    ctx.fillRect(0, 0, width, height)

                    // Draw grid if enabled
                    if (advancedSignalCard.showGrid) {
                        drawGrid(ctx, width, height, channelHeight)
                    }

                    // Draw signals for each visible channel
                    for (var i = 0; i < Math.min(advancedSignalCard.visibleChannels, advancedSignalCard.channelData.length); i++) {
                        var channelY = i * channelHeight
                        drawChannelSignal(ctx, i, channelY, channelHeight, width)
                    }

                    // Draw time cursor
                    drawTimeCursor(ctx, width, height)
                }

                function drawGrid(ctx, width, height, channelHeight) {
                    ctx.strokeStyle = theme.backgroundLight
                    ctx.lineWidth = 0.3
                    ctx.setLineDash([2, 2])

                    // Horizontal grid lines for each channel
                    for (var i = 0; i <= advancedSignalCard.visibleChannels; i++) {
                        var y = i * channelHeight
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y)
                        ctx.stroke()
                    }

                    // Vertical time grid
                    var timeStep = 0.5 // seconds
                    var pixelsPerSecond = width / advancedSignalCard.timeWindow

                    for (var t = 0; t <= advancedSignalCard.timeWindow; t += timeStep) {
                        var x = (t / advancedSignalCard.timeWindow) * width
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x, height)
                        ctx.stroke()
                    }

                    ctx.setLineDash([])
                }

                function drawChannelSignal(ctx, channelIndex, channelY, channelHeight, width) {
                    var channel = advancedSignalCard.channelData[channelIndex]
                    if (!channel || !channel.data) return

                    var data = channel.data
                    var color = advancedSignalCard.channelColors[channelIndex % advancedSignalCard.channelColors.length]
                    var centerY = channelY + channelHeight / 2
                    var amplitude = channelHeight * 0.4 * advancedSignalCard.amplitudeScale

                    ctx.strokeStyle = color
                    ctx.lineWidth = 1.2
                    ctx.beginPath()

                    for (var i = 0; i < data.length; i++) {
                        var x = (i / (data.length - 1)) * width
                        var y = centerY - (data[i] * amplitude)

                        if (i === 0) {
                            ctx.moveTo(x, y)
                        } else {
                            ctx.lineTo(x, y)
                        }
                    }

                    ctx.stroke()

                    // Draw channel label
                    if (advancedSignalCard.showChannelLabels) {
                        ctx.fillStyle = color
                        ctx.font = "bold 10px Arial"
                        ctx.fillText(advancedSignalCard.channelNames[channelIndex], 5, channelY + 15)

                        // Draw channel scale
                        ctx.fillStyle = theme.textTertiary
                        ctx.font = "8px Arial"
                        ctx.fillText("±100µV", width - 40, channelY + 15)
                    }
                }

                function drawTimeCursor(ctx, width, height) {
                    var progress = (advancedSignalCard.currentTime % (advancedSignalCard.timeWindow * 1000)) / (advancedSignalCard.timeWindow * 1000)
                    var cursorX = progress * width

                    ctx.strokeStyle = "#FF4081"
                    ctx.lineWidth = 1
                    ctx.setLineDash([5, 3])
                    ctx.beginPath()
                    ctx.moveTo(cursorX, 0)
                    ctx.lineTo(cursorX, height)
                    ctx.stroke()
                    ctx.setLineDash([])
                }
            }

            // Channel selector overlay
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    console.log("Signal area clicked at:", mouseX, mouseY)
                }
            }
        }

        // Status and Metrics Bar
        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Text {
                text: "⏱️ Time: " + (advancedSignalCard.currentTime / 1000).toFixed(1) + "s"
                color: theme.textSecondary
                font.pixelSize: 11
            }

            Text {
                text: "📊 Scale: " + advancedSignalCard.amplitudeScale.toFixed(1) + "x"
                color: theme.textSecondary
                font.pixelSize: 11
            }

            Text {
                text: "🎛️ Channels: " + advancedSignalCard.visibleChannels
                color: theme.textSecondary
                font.pixelSize: 11
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "⚡ FPS: " + Math.round(fpsCounter.fps)
                color: theme.textSecondary
                font.pixelSize: 11
            }

            // Signal quality indicator
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: getOverallSignalQualityColor()

                ToolTip.text: "Overall Signal Quality: " + Math.round(calculateOverallSignalQuality()) + "%"
            }
        }
    }

    // FPS Counter for performance monitoring
    FpsCounter {
        id: fpsCounter
    }

    // Real-time data simulation
    Timer {
        id: dataUpdateTimer
        interval: advancedSignalCard.updateInterval
        running: advancedSignalCard.isPlaying
        repeat: true
        onTriggered: {
            advancedSignalCard.currentTime += advancedSignalCard.updateInterval
            updateChannelData()
            signalCanvas.requestPaint()
            fpsCounter.tick()
        }
    }

    // Function to generate realistic EEG channel data
    function generateChannelData() {
        var channels = []
        var dataPoints = Math.floor(advancedSignalCard.samplingRate * advancedSignalCard.timeWindow)
        for (var i = 0; i < 8; i++) {
            var initialData = []
            for (var j = 0; j < dataPoints; j++) {
                initialData.push(0)
            }
            channels.push({
                name: channelNames[i],
                data: initialData,
                quality: 95 - Math.random() * 10,
                noiseLevel: Math.random() * 0.1
            })
        }
        return channels
    }

    // Update channel data with realistic EEG simulation
    function updateChannelData() {
        for (var i = 0; i < channelData.length; i++) {
            var channel = channelData[i]
            var newDataPoint = generateEEGDataPoint(i, advancedSignalCard.currentTime)

            channel.data.shift()
            channel.data.push(newDataPoint)

            if (Math.random() < 0.01) {
                channel.quality = Math.max(50, Math.min(100, channel.quality + (Math.random() - 0.5) * 10))
            }
        }
    }

    // Generate realistic EEG data point with multiple frequency components
    function generateEEGDataPoint(channelIndex, time) {
        var t = time / 1000.0

        // Base frequencies for EEG bands
        var delta = 0.5 * Math.sin(2 * Math.PI * 2 * t)
        var theta = 0.3 * Math.sin(2 * Math.PI * 6 * t)
        var alpha = 0.4 * Math.sin(2 * Math.PI * 10 * t)
        var beta = 0.2 * Math.sin(2 * Math.PI * 20 * t)
        var gamma = 0.1 * Math.sin(2 * Math.PI * 40 * t)

        // Channel-specific characteristics
        var channelFactor = 1.0
        if (channelNames[channelIndex].includes('O')) {
            alpha *= 1.5
        } else if (channelNames[channelIndex].includes('C')) {
            beta *= 1.3
        }

        // Add some random noise
        var noise = (Math.random() - 0.5) * 0.1 * channelData[channelIndex].noiseLevel

        // Combine components
        var value = delta + theta + alpha + beta + gamma + noise

        // Occasionally add blink artifacts (for frontal channels)
        if (channelIndex < 2 && Math.random() < 0.002) {
            value += (Math.random() - 0.5) * 2.0
        }

        return Math.max(-1, Math.min(1, value))
    }

    // Calculate overall signal quality
    function calculateOverallSignalQuality() {
        var totalQuality = 0
        for (var i = 0; i < channelData.length; i++) {
            totalQuality += channelData[i].quality
        }
        return totalQuality / channelData.length
    }

    function getOverallSignalQualityColor() {
        var quality = calculateOverallSignalQuality()
        if (quality >= 80) return "#4CAF50"
        if (quality >= 60) return "#FFC107"
        return "#F44336"
    }

    // Public API methods
    function startRecording() {
        advancedSignalCard.isPlaying = true
        console.log("EEG recording started")
    }

    function stopRecording() {
        advancedSignalCard.isPlaying = false
        console.log("EEG recording stopped")
    }

    function clearSignals() {
        advancedSignalCard.channelData = generateChannelData()
        advancedSignalCard.currentTime = 0
        signalCanvas.requestPaint()
    }

    function setVisibleChannels(count) {
        advancedSignalCard.visibleChannels = Math.max(1, Math.min(8, count))
    }

    // Initialize component
    Component.onCompleted: {
        console.log("Advanced EEG Signal Viewer initialized")
        console.log("Data points per channel:", dataPointsPerChannel)
        console.log("Update interval:", updateInterval, "ms")

        // Initialize with some data
        for (var i = 0; i < 100; i++) {
            updateChannelData()
        }
    }
}
