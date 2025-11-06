import QtQuick 2.15
import QtQuick.Controls 2.15
import QtCharts 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: eegVisualizer
    color: "#1E1E1E"
    radius: 8

    // Properties based on your usage
    property bool experimentRunning: false
    property string predictedClass: "rest"

    // Original properties
    property var eegData: []
    property var channels: ["C3", "C4", "Cz", "P3", "P4"]
    property var frequencyBands: {"mu": [8, 12], "beta": [13, 30]}
    property var currentTrialData: []
    property bool isRecording: experimentRunning
    property real timeWindow: 5.0 // seconds

    signal dataPointAdded(var channel, var value, var timestamp)
    signal frequencyBandUpdated(var band, var power)
    signal predictionReceived(string predictedClass)

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 2
        verticalOffset: 2
        radius: 8
        samples: 17
        color: "#20000000"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        // Header with Prediction
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                text: "🧠 Real-time EEG"
                color: "white"
                font.bold: true
                font.pixelSize: 16
                Layout.fillWidth: true
            }

            // Prediction Display
            Rectangle {
                height: 30
                radius: 15
                color: getPredictionColor()

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 5

                    Text {
                        text: "🎯"
                        color: "white"
                        font.pixelSize: 12
                    }

                    Text {
                        text: getPredictionDisplayName()
                        color: "white"
                        font.bold: true
                        font.pixelSize: 11
                    }
                }
            }
        }

        ChartView {
            id: chartView
            Layout.fillWidth: true
            Layout.fillHeight: true
            theme: ChartView.ChartThemeDark
            antialiasing: true
            animationOptions: ChartView.NoAnimation

            ValueAxis {
                id: axisX
                min: 0
                max: timeWindow
                tickCount: 6
                labelFormat: "%.1f s"
            }

            ValueAxis {
                id: axisY
                min: -100
                max: 100
                tickCount: 5
                labelFormat: "%d μV"
            }

            Repeater {
                model: channels

                delegate: LineSeries {
                    id: series
                    name: modelData
                    axisX: axisX
                    axisY: axisY
                    color: getChannelColor(index)
                    width: 1.5

                    function addDataPoint(time, value) {
                        if (series.count > timeWindow * 250) { // 250 Hz sampling
                            series.remove(0)
                        }
                        series.append(time, value)
                    }
                }
            }
        }

        // Bottom Info Bar
        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            // Channel Legend
            Repeater {
                model: channels

                delegate: RowLayout {
                    spacing: 5

                    Rectangle {
                        width: 12
                        height: 12
                        color: getChannelColor(index)
                        radius: 2
                    }

                    Text {
                        text: modelData
                        color: "white"
                        font.pixelSize: 10
                    }
                }
            }

            Item { Layout.fillWidth: true } // Spacer

            // Recording Status
            Rectangle {
                width: 80
                height: 25
                color: isRecording ? "#FF4444" : "#444"
                radius: 12

                RowLayout {
                    anchors.centerIn: parent
                    spacing: 5

                    Rectangle {
                        width: 6
                        height: 6
                        radius: 3
                        color: "white"
                        visible: isRecording

                        SequentialAnimation on opacity {
                            running: isRecording
                            loops: Animation.Infinite
                            NumberAnimation { from: 1.0; to: 0.3; duration: 500 }
                            NumberAnimation { from: 0.3; to: 1.0; duration: 500 }
                        }
                    }

                    Text {
                        text: isRecording ? "REC" : "IDLE"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 10
                    }
                }
            }
        }
    }

    // Frequency Band Visualization
    Rectangle {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        width: 200
        height: 120
        color: "#2D2D2D"
        radius: 6
        border.color: "#444"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 6

            Text {
                text: "📊 Frequency Bands"
                color: "white"
                font.bold: true
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
            }

            Repeater {
                model: ["mu", "beta"]

                delegate: ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: modelData + ":"
                            color: "white"
                            font.pixelSize: 9
                            Layout.fillWidth: true
                        }

                        Text {
                            text: frequencyBands[modelData][0] + "-" + frequencyBands[modelData][1] + "Hz"
                            color: "#AAA"
                            font.pixelSize: 8
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 8
                        color: "#444"
                        radius: 4

                        Rectangle {
                            width: parent.width * getBandPower(modelData)
                            height: parent.height
                            color: getBandColor(modelData)
                            radius: 4
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Power:"
                            color: "#AAA"
                            font.pixelSize: 8
                        }

                        Text {
                            text: (getBandPower(modelData) * 100).toFixed(1)
                            color: "white"
                            font.pixelSize: 8
                            font.bold: true
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignRight
                        }

                        Text {
                            text: "μV²"
                            color: "#AAA"
                            font.pixelSize: 7
                        }
                    }
                }
            }
        }
    }

    // Functions
    function getChannelColor(index) {
        var colors = ["#FF6B6B", "#4ECDC4", "#45B7D1", "#96CEB4", "#FFEAA7"]
        return colors[index % colors.length]
    }

    function getBandColor(band) {
        return band === "mu" ? "#FF6B6B" : "#4ECDC4"
    }

    function getBandPower(band) {
        // Simulate band power that changes based on predicted class
        var basePower = 0.3 + Math.random() * 0.4
        // Enhance mu rhythm for motor imagery
        if (band === "mu" && predictedClass !== "rest") {
            basePower += 0.3
        }
        return Math.min(basePower, 0.95)
    }

    function getPredictionColor() {
        var colors = {
            "rest": "#666666",
            "left_hand": "#4ECDC4",
            "right_hand": "#FF6B6B",
            "both_hands": "#96CEB4",
            "both_feet": "#FFEAA7"
        }
        return colors[predictedClass] || "#666666"
    }

    function getPredictionDisplayName() {
        var names = {
            "rest": "Rest",
            "left_hand": "Left Hand",
            "right_hand": "Right Hand",
            "both_hands": "Both Hands",
            "both_feet": "Both Feet"
        }
        return names[predictedClass] || predictedClass
    }

    function addEEGData(channelData) {
        if (!isRecording) return

        var timestamp = Date.now() / 1000
        for (var i = 0; i < channels.length; i++) {
            var value = channelData[i] || Math.random() * 200 - 100

            // Add class-specific patterns for more realistic visualization
            if (predictedClass === "left_hand" && channels[i] === "C3") {
                value += 30 * Math.sin(timestamp * 2 * Math.PI) // Mu rhythm for left hand
            }
            if (predictedClass === "right_hand" && channels[i] === "C4") {
                value += 30 * Math.sin(timestamp * 2 * Math.PI) // Mu rhythm for right hand
            }

            var series = chartView.series(i)
            if (series) {
                series.addDataPoint(timestamp % timeWindow, value)
            }
            dataPointAdded(channels[i], value, timestamp)
        }

        // Update frequency bands
        updateFrequencyBands(channelData)
    }

    function updateFrequencyBands(channelData) {
        for (var band in frequencyBands) {
            var power = calculateBandPower(channelData, frequencyBands[band])
            frequencyBandUpdated(band, power)
        }
    }

    function calculateBandPower(data, band) {
        // Simulate band power calculation with class-specific enhancements
        var basePower = Math.random() * 80 + 20
        if (band[0] === 8 && band[1] === 12 && predictedClass !== "rest") {
            basePower += 30 // Enhance mu power during motor imagery
        }
        return basePower
    }

    function startRecording() {
        isRecording = true
        clearData()
    }

    function stopRecording() {
        isRecording = false
    }

    function clearData() {
        for (var i = 0; i < chartView.seriesCount; i++) {
            chartView.series(i).clear()
        }
    }

    function setPrediction(newClass) {
        predictedClass = newClass
        predictionReceived(newClass)
    }

    // Simulate EEG data when experiment is running
    Timer {
        id: dataTimer
        interval: 40 // 25 Hz update
        running: isRecording
        repeat: true
        onTriggered: {
            var simulatedData = []
            for (var i = 0; i < channels.length; i++) {
                // Generate realistic EEG data with some noise
                var baseValue = (Math.random() - 0.5) * 50

                // Add class-specific patterns
                if (predictedClass === "left_hand" && channels[i] === "C3") {
                    baseValue += 25 * Math.sin(Date.now() / 500) // Mu rhythm ~10Hz
                }
                if (predictedClass === "right_hand" && channels[i] === "C4") {
                    baseValue += 25 * Math.sin(Date.now() / 500) // Mu rhythm ~10Hz
                }
                if (predictedClass === "both_hands") {
                    if (channels[i] === "C3" || channels[i] === "C4") {
                        baseValue += 20 * Math.sin(Date.now() / 500)
                    }
                }
                if (predictedClass === "both_feet" && channels[i] === "Cz") {
                    baseValue += 15 * Math.sin(Date.now() / 400) // Different frequency
                }

                simulatedData.push(baseValue)
            }
            addEEGData(simulatedData)
        }
    }

    onExperimentRunningChanged: {
        if (experimentRunning) {
            startRecording()
        } else {
            stopRecording()
        }
    }

    onPredictedClassChanged: {
        console.log("Prediction updated:", predictedClass)
    }

    Component.onCompleted: {
        console.log("Motor Imagery EEG Visualizer initialized with", channels.length, "channels")
    }
}
