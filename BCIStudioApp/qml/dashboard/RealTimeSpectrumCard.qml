// RealTimeSpectrumCard.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

DashboardCard {
    id: spectrumCard
    title: "EEG Frequency Spectrum"
    icon: "📡"
    subtitle: "Real-time Brain Wave Analysis"
    headerColor: "#FF9800"
    badgeText: "LIVE"
    badgeColor: "#FF4081"

    property var frequencyBands: [
        {name: "Delta", range: "0.5-4 Hz", value: 25, color: "#FF6B6B"},
        {name: "Theta", range: "4-8 Hz", value: 35, color: "#4ECDC4"},
        {name: "Alpha", range: "8-13 Hz", value: 60, color: "#45B7D1"},
        {name: "Beta", range: "13-30 Hz", value: 45, color: "#96CEB4"},
        {name: "Gamma", range: "30-45 Hz", value: 20, color: "#FFEAA7"}
    ]

    property real dominantFrequency: 10.5
    property string dominantBand: "Alpha"

    content:  ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // Spectrum Visualization
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 150
            radius: 12
            // color: theme.backgroundLight
            color: "transparent"
            border.color: theme.border

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Text {
                    text: "Frequency Spectrum Analysis"
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 12
                }

                // Spectrum Bars
                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8

                    Repeater {
                        model: spectrumCard.frequencyBands

                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: 4

                            // Bar
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 4
                                color: theme.backgroundLight
                                border.color: theme.border

                                Rectangle {
                                    width: parent.width
                                    height: parent.height * (modelData.value / 100)
                                    radius: parent.radius
                                    color: modelData.color
                                    anchors.bottom: parent.bottom

                                    Behavior on height {
                                        NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                                    }
                                }
                            }

                            // Labels
                            ColumnLayout {
                                spacing: 2

                                Text {
                                    text: modelData.name
                                    color: theme.textPrimary
                                    font.bold: true
                                    font.pixelSize: 9
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: modelData.range
                                    color: theme.textSecondary
                                    font.pixelSize: 8
                                    Layout.alignment: Qt.AlignHCenter
                                }

                                Text {
                                    text: modelData.value + "%"
                                    color: modelData.color
                                    font.bold: true
                                    font.pixelSize: 10
                                    Layout.alignment: Qt.AlignHCenter
                                }
                            }
                        }
                    }
                }
            }
        }

        // Dominant Frequency & Band Info
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 12
            columnSpacing: 12

            // Dominant Frequency
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                radius: 8
                color: Qt.rgba(0, 0, 0, 0.05)
                border.color: theme.border

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 4

                    Text {
                        text: "Dominant Frequency"
                        color: theme.textSecondary
                        font.pixelSize: 10
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: spectrumCard.dominantFrequency.toFixed(1) + " Hz"
                        color: theme.textPrimary
                        font.bold: true
                        font.pixelSize: 18
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: spectrumCard.dominantBand + " Band"
                        color: getBandColor(spectrumCard.dominantBand)
                        font.pixelSize: 11
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Band Power Distribution
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 80
                radius: 8
                color: Qt.rgba(0, 0, 0, 0.05)
                border.color: theme.border

                PieChart {
                    id: bandPowerChart
                    anchors.fill: parent
                    anchors.margins: 8
                    data: spectrumCard.frequencyBands
                }
            }
        }

        // Spectrum Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Button {
                text: "🎛️ Auto Scale"
                Layout.fillWidth: true
                onClicked: autoScaleSpectrum()

                background: Rectangle {
                    radius: 6
                    color: theme.backgroundLight
                }
            }

            Button {
                text: "📊 Export"
                Layout.fillWidth: true
                onClicked: exportSpectrumData()

                background: Rectangle {
                    radius: 6
                    color: theme.backgroundLight
                }
            }

            Button {
                text: "🔄 Reset"
                Layout.fillWidth: true
                onClicked: resetSpectrum()

                background: Rectangle {
                    radius: 6
                    color: theme.backgroundLight
                }
            }
        }
    }

    function getBandColor(bandName) {
        var band = spectrumCard.frequencyBands.find(b => b.name === bandName)
        return band ? band.color : theme.textPrimary
    }

    function autoScaleSpectrum() {
        console.log("Auto-scaling spectrum...")
    }

    function exportSpectrumData() {
        console.log("Exporting spectrum data...")
    }

    function resetSpectrum() {
        console.log("Resetting spectrum analysis...")
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            // Simulate spectrum changes
            for (var i = 0; i < spectrumCard.frequencyBands.length; i++) {
                var change = (Math.random() - 0.5) * 15
                spectrumCard.frequencyBands[i].value = Math.max(10, 
                    Math.min(90, spectrumCard.frequencyBands[i].value + change))
            }
            
            // Update dominant band
            var maxBand = spectrumCard.frequencyBands.reduce((max, band) => 
                band.value > max.value ? band : max, spectrumCard.frequencyBands[0])
            spectrumCard.dominantBand = maxBand.name
            spectrumCard.dominantFrequency = getRandomFrequency(maxBand.name)
        }
    }

    function getRandomFrequency(bandName) {
        var ranges = {
            "Delta": [0.5, 4],
            "Theta": [4, 8],
            "Alpha": [8, 13],
            "Beta": [13, 30],
            "Gamma": [30, 45]
        }
        var range = ranges[bandName]
        return range[0] + Math.random() * (range[1] - range[0])
    }
}
