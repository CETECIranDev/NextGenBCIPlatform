// SignalQualityMap.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects  // برای Qt 6


DashboardCard {
    id: advancedQualityMapCard
    title: "EEG Signal Quality Map"
    icon: "🗺️"
    subtitle: "Real-time Electrode Quality Monitoring"

    property var qualityData: generateQualityData()
    property var electrodePositions: standard10_20Positions
    property real overallQuality: calculateOverallQuality()
    property int goodChannelsCount: calculateGoodChannelsCount()
    property bool showInterpolation: true
    property string interpolationType: "bilinear"
    property real updateInterval: 2000

    // Standard 10-20 system electrode positions
    property var standard10_20Positions: [
        { label: "Fp1", x: 0.27, y: 0.15, region: "frontal" },
        { label: "Fp2", x: 0.73, y: 0.15, region: "frontal" },
        { label: "F3", x: 0.33, y: 0.3, region: "frontal" },
        { label: "F4", x: 0.67, y: 0.3, region: "frontal" },
        { label: "C3", x: 0.33, y: 0.5, region: "central" },
        { label: "C4", x: 0.67, y: 0.5, region: "central" },
        { label: "P3", x: 0.33, y: 0.7, region: "parietal" },
        { label: "P4", x: 0.67, y: 0.7, region: "parietal" },
        { label: "O1", x: 0.27, y: 0.85, region: "occipital" },
        { label: "O2", x: 0.73, y: 0.85, region: "occipital" },
        { label: "F7", x: 0.15, y: 0.3, region: "temporal" },
        { label: "F8", x: 0.85, y: 0.3, region: "temporal" },
        { label: "T3", x: 0.15, y: 0.5, region: "temporal" },
        { label: "T4", x: 0.85, y: 0.5, region: "temporal" },
        { label: "T5", x: 0.15, y: 0.7, region: "temporal" },
        { label: "T6", x: 0.85, y: 0.7, region: "temporal" },
        { label: "Fz", x: 0.5, y: 0.3, region: "frontal" },
        { label: "Cz", x: 0.5, y: 0.5, region: "central" },
        { label: "Pz", x: 0.5, y: 0.7, region: "parietal" }
    ]

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        // Header with overall quality
        Rectangle {
            Layout.fillWidth: true
            height: 50
            radius: 8
            color: getOverallQualityColor()
            opacity: 0.1
            border.color: getOverallQualityColor()
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                StatusIndicator {
                    status: getOverallQualityStatus()
                    text: "Overall Quality: " + Math.round(overallQuality) + "%"
                    pulseAnimation: overallQuality < 70
                    Layout.fillWidth: true
                }

                Text {
                    text: "🎯 " + goodChannelsCount + "/" + qualityData.length + " Good"
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 12
                }
            }
        }

        // Legend with interactive controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            Repeater {
                model: [
                    { color: "#4CAF50", label: "Excellent", range: "80-100%" },
                    { color: "#8BC34A", label: "Good", range: "60-80%" },
                    { color: "#FFC107", label: "Fair", range: "40-60%" },
                    { color: "#FF9800", label: "Poor", range: "20-40%" },
                    { color: "#F44336", label: "Bad", range: "0-20%" }
                ]

                ColumnLayout {
                    spacing: 4
                    Layout.alignment: Qt.AlignTop

                    Rectangle {
                        width: 16
                        height: 16
                        radius: 3
                        color: modelData.color
                        Layout.alignment: Qt.AlignHCenter

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            ToolTip.text: modelData.label + " (" + modelData.range + ")"
                        }
                    }

                    Text {
                        text: modelData.label
                        color: theme.textSecondary
                        font.pixelSize: 9
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            Item { Layout.fillWidth: true }

            // Controls
            Button {
                text: showInterpolation ? "🔍 Grid" : "🔍 Smooth"
                onClicked: showInterpolation = !showInterpolation
                ToolTip.text: showInterpolation ? "Show Grid View" : "Show Interpolated View"
            }

            Button {
                text: "🔄"
                onClicked: refreshData()
                ToolTip.text: "Refresh Quality Data"
            }
        }

        // Head Map Container
        Rectangle {
            id: headMapContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            border.color: theme.border
            border.width: 1
            radius: 8
            clip: true

            // Head Map
            Item {
                id: headMap
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height) * 0.9
                height: width

                // Head outline
                Canvas {
                    id: headOutlineCanvas
                    anchors.fill: parent

                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.reset()

                        var width = headOutlineCanvas.width
                        var height = headOutlineCanvas.height
                        var centerX = width / 2
                        var centerY = height / 2
                        var radius = Math.min(width, height) / 2 - 20

                        // Draw head circle
                        ctx.strokeStyle = theme.textPrimary
                        ctx.lineWidth = 3
                        ctx.beginPath()
                        ctx.arc(centerX, centerY, radius, 0, Math.PI * 2)
                        ctx.stroke()

                        // Draw nose
                        ctx.lineWidth = 2
                        ctx.beginPath()
                        ctx.moveTo(centerX, centerY - radius)
                        ctx.lineTo(centerX - 12, centerY - radius + 25)
                        ctx.lineTo(centerX + 12, centerY - radius + 25)
                        ctx.closePath()
                        ctx.stroke()

                        // Draw ears
                        ctx.beginPath()
                        ctx.arc(centerX - radius - 8, centerY, 18, -Math.PI/4, Math.PI/4, false)
                        ctx.stroke()

                        ctx.beginPath()
                        ctx.arc(centerX + radius + 8, centerY, 18, Math.PI*3/4, Math.PI*5/4, false)
                        ctx.stroke()
                    }
                }

                // Electrodes
                Repeater {
                    model: advancedQualityMapCard.qualityData

                    delegate: ElectrodeItem {
                        channel: modelData.channel
                        quality: modelData.quality
                        position: getElectrodePosition(modelData.channel)
                        mapSize: headMap.width
                        showInterpolation: advancedQualityMapCard.showInterpolation
                        impedance: modelData.impedance || 0
                        region: modelData.region || ""

                        onClicked: function(ch, q) {
                            console.log("Electrode selected:", ch, "Quality:", q + "%")
                            highlightRegion(ch)
                        }
                    }
                }
            }
        }

        // Regional Statistics
        GridLayout {
            Layout.fillWidth: true
            columns: 4
            rowSpacing: 8
            columnSpacing: 15

            Text {
                text: "Regional Quality:"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 12
                Layout.columnSpan: 4
            }

            RegionalQualityItem {
                region: "Frontal"
                quality: getRegionalQuality("frontal")
                electrodeCount: getRegionalElectrodeCount("frontal")
                onClicked: highlightRegionalElectrodes("frontal")
                Layout.fillWidth: true
            }
            RegionalQualityItem {
                region: "Central"
                quality: getRegionalQuality("central")
                electrodeCount: getRegionalElectrodeCount("central")
                onClicked: highlightRegionalElectrodes("central")
                Layout.fillWidth: true
            }
            RegionalQualityItem {
                region: "Parietal"
                quality: getRegionalQuality("parietal")
                electrodeCount: getRegionalElectrodeCount("parietal")
                onClicked: highlightRegionalElectrodes("parietal")
                Layout.fillWidth: true
            }
            RegionalQualityItem {
                region: "Occipital"
                quality: getRegionalQuality("occipital")
                electrodeCount: getRegionalElectrodeCount("occipital")
                onClicked: highlightRegionalElectrodes("occipital")
                Layout.fillWidth: true
            }
        }
    }

    // Functions
    function generateQualityData() {
        var data = []
        standard10_20Positions.forEach(function(electrode) {
            data.push({
                channel: electrode.label,
                quality: 70 + Math.random() * 30,
                region: electrode.region,
                impedance: 5 + Math.random() * 10
            })
        })
        return data
    }

    function getElectrodePosition(channel) {
        return electrodePositions.find(function(item) {
            return item.label === channel
        }) || { x: 0.5, y: 0.5 }
    }

    function getQualityColor(quality) {
        if (quality >= 80) return "#4CAF50"
        if (quality >= 60) return "#8BC34A"
        if (quality >= 40) return "#FFC107"
        if (quality >= 20) return "#FF9800"
        return "#F44336"
    }

    function getOverallQualityColor() {
        return getQualityColor(overallQuality)
    }

    function getOverallQualityStatus() {
        if (overallQuality >= 80) return "success"
        if (overallQuality >= 60) return "good"
        if (overallQuality >= 40) return "warning"
        return "error"
    }

    function calculateOverallQuality() {
        if (qualityData.length === 0) return 0
        var total = qualityData.reduce(function(sum, electrode) {
            return sum + (electrode.quality || 0)
        }, 0)
        return total / qualityData.length
    }

    function calculateGoodChannelsCount() {
        return qualityData.filter(function(electrode) {
            return (electrode.quality || 0) >= 60
        }).length
    }

    function getRegionalQuality(region) {
        var regionalElectrodes = qualityData.filter(function(electrode) {
            return electrode.region === region.toLowerCase()
        })
        if (regionalElectrodes.length === 0) return 0

        var total = regionalElectrodes.reduce(function(sum, electrode) {
            return sum + (electrode.quality || 0)
        }, 0)
        return total / regionalElectrodes.length
    }

    function getRegionalElectrodeCount(region) {
        return qualityData.filter(function(electrode) {
            return electrode.region === region.toLowerCase()
        }).length
    }

    function highlightRegion(channel) {
        // Find and highlight the electrode
        for (var i = 0; i < headMap.children.length; i++) {
            var child = headMap.children[i]
            if (child.channel === channel) {
                child.highlight()
                break
            }
        }
    }

    function highlightRegionalElectrodes(region) {
        // Highlight all electrodes in the region
        for (var i = 0; i < headMap.children.length; i++) {
            var child = headMap.children[i]
            if (child.region === region.toLowerCase()) {
                child.highlight()
            }
        }
    }

    function refreshData() {
        // Simulate real-time quality updates
        qualityData.forEach(function(electrode) {
            var change = (Math.random() - 0.5) * 10
            electrode.quality = Math.max(0, Math.min(100, electrode.quality + change))
        })

        overallQuality = calculateOverallQuality()
        goodChannelsCount = calculateGoodChannelsCount()

        headOutlineCanvas.requestPaint()
    }

    // Real-time updates
    Timer {
        interval: updateInterval
        running: true
        repeat: true
        onTriggered: refreshData()
    }

    Component.onCompleted: {
        console.log("Advanced Quality Map initialized with", qualityData.length, "electrodes")
        refreshData()
    }
}
