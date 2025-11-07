// SignalQualityMap.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

DashboardCard {
    id: qualityMapCard
    title: "🧠 EEG Signal Quality Map"
    subtitle: "Real-time Electrode Quality Monitoring & Analysis"
    headerColor: "#7C4DFF"
    collapsible: false
    showActions: true
    badgeText: "LIVE"
    badgeColor: "#FF4081"
    cornerRadius: 20
    elevation: 12

    actionButtons: [
        {icon: "⛶", action: "fullscreen", tooltip: "Fullscreen View"},
        {icon: "🏷️", action: "labels", tooltip: "Toggle Labels"},
        {icon: "🔥", action: "heatmap", tooltip: "Toggle Heat Map"},
        {icon: "🔄", action: "refresh", tooltip: "Refresh Data"}
    ]


    // Properties با مقدار پیش‌فرض
    property var qualityData: []
    property var electrodePositions: []
    property real overallQuality: 0
    property int goodChannelsCount: 0
    property bool showLabels: true
    property bool showHeatMap: true
    property real headMapScale: 1.0
    property string selectedRegion: ""
    property real updateInterval: 2000
    property bool autoRefresh: true

    // Standard 10-20 system positions
    property var standard10_20Positions: [
        { label: "Fp1", x: 0.3, y: 0.18, region: "frontal" },
        { label: "Fp2", x: 0.7, y: 0.18, region: "frontal" },
        { label: "F3", x: 0.25, y: 0.35, region: "frontal" },
        { label: "F4", x: 0.75, y: 0.35, region: "frontal" },
        { label: "C3", x: 0.25, y: 0.5, region: "central" },
        { label: "C4", x: 0.75, y: 0.5, region: "central" },
        { label: "P3", x: 0.25, y: 0.65, region: "parietal" },
        { label: "P4", x: 0.75, y: 0.65, region: "parietal" },
        { label: "O1", x: 0.3, y: 0.82, region: "occipital" },
        { label: "O2", x: 0.7, y: 0.82, region: "occipital" },
        { label: "F7", x: 0.12, y: 0.35, region: "temporal" },
        { label: "F8", x: 0.88, y: 0.35, region: "temporal" },
        { label: "T3", x: 0.12, y: 0.5, region: "temporal" },
        { label: "T4", x: 0.88, y: 0.5, region: "temporal" },
        { label: "T5", x: 0.12, y: 0.65, region: "temporal" },
        { label: "T6", x: 0.88, y: 0.65, region: "temporal" },
        { label: "Fz", x: 0.5, y: 0.3, region: "frontal" },
        { label: "Cz", x: 0.5, y: 0.5, region: "central" },
        { label: "Pz", x: 0.5, y: 0.7, region: "parietal" }
    ]

    property var qualityColors: {
        "excellent": "#4CAF50",
        "good": "#8BC34A",
        "fair": "#FFC107",
        "poor": "#FF9800",
        "bad": "#F44336"
    }

    property var regionalData: ({
        frontal: { quality: 0, count: 0, color: "#2196F3" },
        central: { quality: 0, count: 0, color: "#4CAF50" },
        parietal: { quality: 0, count: 0, color: "#FF9800" },
        occipital: { quality: 0, count: 0, color: "#9C27B0" },
        temporal: { quality: 0, count: 0, color: "#607D8B" }
    })

    onActionTriggered: function(action) {
        switch(action) {
            case "fullscreen":
                console.log("Entering fullscreen mode")
                break
            case "labels":
                showLabels = !showLabels
                break
            case "heatmap":
                showHeatMap = !showHeatMap
                break
            case "refresh":
                refreshData()
                break
        }
    }

    // Main Content
    content: Item {
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Quick Stats Bar
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 20

                    // Overall Quality
                    QualityMetricCompact {
                        label: "OVERALL QUALITY"
                        value: Math.round(overallQuality) + "%"
                        color: getOverallQualityColor()
                        trend: "+2.1%"
                        Layout.preferredWidth: 180
                    }

                    // Good Channels - با بررسی length
                    QualityMetricCompact {
                        label: "GOOD CHANNELS"
                        value: goodChannelsCount + "/" + (qualityData ? qualityData.length : 0)
                        color: "#4CAF50"
                        trend: "+1"
                        Layout.preferredWidth: 160
                    }

                    // Avg Impedance
                    QualityMetricCompact {
                        label: "AVG IMPEDANCE"
                        value: calculateAvgImpedance().toFixed(1) + "kΩ"
                        color: "#2196F3"
                        trend: "-0.3kΩ"
                        Layout.preferredWidth: 160
                    }

                    Item { Layout.fillWidth: true }

                    // Auto-refresh Toggle
                    RowLayout {
                        spacing: 10
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            text: "AUTO REFRESH"
                            color: theme.textSecondary
                            font.pixelSize: 11
                            font.bold: true
                        }

                        Rectangle {
                            width: 40
                            height: 20
                            radius: 10
                            color: autoRefresh ? "#4CAF50" : theme.backgroundLight
                            border.color: theme.border
                            border.width: 1

                            Rectangle {
                                x: autoRefresh ? parent.width - width - 2 : 2
                                y: 2
                                width: 16
                                height: 16
                                radius: 8
                                color: "white"

                                Behavior on x {
                                    NumberAnimation { duration: 200 }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: autoRefresh = !autoRefresh
                            }
                        }
                    }
                }
            }

            // Main Visualization Area
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: 10

                RowLayout {
                    anchors.fill: parent
                    spacing: 15

                    // Head Map Container - 75% عرض
                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width * 0.75

                        Rectangle {
                            id: headMapContainer
                            anchors.fill: parent
                            color: "transparent"
                            radius: 16

                            // Head Map Visualization
                            AdvancedHeadMap {
                                id: advancedHeadMap
                                anchors.fill: parent
                                qualityData: qualityMapCard.qualityData
                                electrodePositions: qualityMapCard.electrodePositions
                                showHeatMap: qualityMapCard.showHeatMap
                                showLabels: qualityMapCard.showLabels
                                scale: qualityMapCard.headMapScale
                                selectedRegion: qualityMapCard.selectedRegion

                                onElectrodeSelected: function(channel, quality) {
                                    showElectrodeDetails(channel, quality)
                                }

                                onRegionSelected: function(region) {
                                    qualityMapCard.selectedRegion = region
                                }
                            }

                            // Map Controls Overlay
                            ColumnLayout {
                                anchors.top: parent.top
                                anchors.right: parent.right
                                anchors.margins: 15
                                spacing: 8

                                MapControlButtonEnterprise {
                                    icon: "🔍"
                                    tooltip: "Zoom In"
                                    onClicked: headMapScale = Math.min(2.0, headMapScale + 0.1)
                                }

                                MapControlButtonEnterprise {
                                    icon: "🔍"
                                    tooltip: "Zoom Out"
                                    onClicked: headMapScale = Math.max(0.5, headMapScale - 0.1)
                                }

                                MapControlButtonEnterprise {
                                    icon: showHeatMap ? "🔥" : "◻️"
                                    tooltip: showHeatMap ? "Hide Heat Map" : "Show Heat Map"
                                    onClicked: showHeatMap = !showHeatMap
                                }

                                MapControlButtonEnterprise {
                                    icon: showLabels ? "🏷️" : "🔤"
                                    tooltip: showLabels ? "Hide Labels" : "Show Labels"
                                    onClicked: showLabels = !showLabels
                                }
                            }

                            // Scale Indicator
                            Rectangle {
                                anchors.bottom: parent.bottom
                                anchors.left: parent.left
                                anchors.margins: 15
                                width: 60
                                height: 25
                                radius: 12
                                color: Qt.rgba(0, 0, 0, 0.7)

                                Text {
                                    anchors.centerIn: parent
                                    text: Math.round(headMapScale * 100) + "%"
                                    color: "white"
                                    font.bold: true
                                    font.pixelSize: 11
                                }
                            }
                        }
                    }

                    // Side Panel - 25% عرض
                    Item {
                        Layout.fillHeight: true
                        Layout.preferredWidth: parent.width * 0.25

                        ColumnLayout {
                            anchors.fill: parent
                            spacing: 12

                            // Quality Distribution - با بررسی length
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 200
                                radius: 12
                                color: "transparent"
                                border.color: theme.glassBorder
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 8

                                    Text {
                                        text: "QUALITY DISTRIBUTION"
                                        color: theme.textPrimary
                                        font.bold: true
                                        font.pixelSize: 13
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        spacing: 6

                                        QualityDistributionBar {
                                            label: "Excellent"
                                            count: getQualityCount(80, 100)
                                            total: qualityData ? qualityData.length : 0
                                            color: "#4CAF50"
                                            Layout.fillWidth: true
                                        }

                                        QualityDistributionBar {
                                            label: "Good"
                                            count: getQualityCount(60, 79)
                                            total: qualityData ? qualityData.length : 0
                                            color: "#8BC34A"
                                            Layout.fillWidth: true
                                        }

                                        QualityDistributionBar {
                                            label: "Fair"
                                            count: getQualityCount(40, 59)
                                            total: qualityData ? qualityData.length : 0
                                            color: "#FFC107"
                                            Layout.fillWidth: true
                                        }

                                        QualityDistributionBar {
                                            label: "Poor"
                                            count: getQualityCount(20, 39)
                                            total: qualityData ? qualityData.length : 0
                                            color: "#FF9800"
                                            Layout.fillWidth: true
                                        }

                                        QualityDistributionBar {
                                            label: "Bad"
                                            count: getQualityCount(0, 19)
                                            total: qualityData ? qualityData.length : 0
                                            color: "#F44336"
                                            Layout.fillWidth: true
                                        }
                                    }
                                }
                            }

                            // Regional Quality
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 12
                                color: "transparent"
                                border.color: theme.glassBorder
                                border.width: 1

                                ColumnLayout {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 8

                                    Text {
                                        text: "REGIONAL QUALITY"
                                        color: theme.textPrimary
                                        font.bold: true
                                        font.pixelSize: 13
                                        Layout.alignment: Qt.AlignHCenter
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        spacing: 6

                                        Repeater {
                                            model: ["frontal", "central", "parietal", "occipital", "temporal"]

                                            RegionalQualityBar {
                                                region: modelData
                                                quality: regionalData[modelData].quality
                                                electrodeCount: regionalData[modelData].count
                                                customColor: regionalData[modelData].color
                                                Layout.fillWidth: true
                                                Layout.preferredHeight: 28

                                                onClicked: function(region) {
                                                    qualityMapCard.selectedRegion = region
                                                    advancedHeadMap.highlightRegion(region)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // توابع کمکی با بررسی undefined
    function generateQualityData() {
        console.log("🔄 Generating quality data...")
        var data = []
        for (var i = 0; i < standard10_20Positions.length; i++) {
            var electrode = standard10_20Positions[i]
            data.push({
                channel: electrode.label,
                quality: 70 + Math.random() * 30,
                region: electrode.region,
                impedance: 5 + Math.random() * 15,
                noise: Math.random() * 10
            })
        }
        console.log("✅ Generated", data.length, "electrodes")
        return data
    }

    function calculateOverallQuality() {
        if (!qualityData || qualityData.length === 0) {
            console.warn("⚠️ No quality data available")
            return 0
        }
        var total = 0
        for (var i = 0; i < qualityData.length; i++) {
            total += qualityData[i].quality
        }
        return total / qualityData.length
    }

    function calculateGoodChannelsCount() {
        if (!qualityData || qualityData.length === 0) return 0
        var count = 0
        for (var i = 0; i < qualityData.length; i++) {
            if (qualityData[i].quality >= 60) count++
        }
        return count
    }

    function getQualityCount(min, max) {
        if (!qualityData || qualityData.length === 0) return 0
        var count = 0
        for (var i = 0; i < qualityData.length; i++) {
            var quality = qualityData[i].quality
            if (quality >= min && quality <= max) count++
        }
        return count
    }

    function calculateAvgImpedance() {
        if (!qualityData || qualityData.length === 0) return 0
        var total = 0
        for (var i = 0; i < qualityData.length; i++) {
            total += qualityData[i].impedance
        }
        return total / qualityData.length
    }

    function getOverallQualityColor() {
        return getQualityColor(overallQuality)
    }

    function getQualityColor(quality) {
        if (quality >= 80) return "#4CAF50"
        if (quality >= 60) return "#8BC34A"
        if (quality >= 40) return "#FFC107"
        if (quality >= 20) return "#FF9800"
        return "#F44336"
    }

    function refreshData() {
        console.log("🔄 Refreshing signal quality data")
        if (!qualityData || qualityData.length === 0) {
            console.warn("⚠️ No data to refresh")
            return
        }

        for (var i = 0; i < qualityData.length; i++) {
            var electrode = qualityData[i]
            var change = (Math.random() - 0.5) * 8
            electrode.quality = Math.max(0, Math.min(100, electrode.quality + change))
        }
        updateRegionalData()
        overallQuality = calculateOverallQuality()
        goodChannelsCount = calculateGoodChannelsCount()
        console.log("✅ Data refreshed - Overall:", Math.round(overallQuality) + "%")
    }

    function updateRegionalData() {
        console.log("🔄 Updating regional data")
        var regions = ["frontal", "central", "parietal", "occipital", "temporal"]

        // Reset regional data
        for (var i = 0; i < regions.length; i++) {
            var region = regions[i]
            regionalData[region].quality = 0
            regionalData[region].count = 0
        }

        // Calculate new regional data
        if (qualityData && qualityData.length > 0) {
            for (var j = 0; j < qualityData.length; j++) {
                var electrode = qualityData[j]
                if (regionalData[electrode.region]) {
                    regionalData[electrode.region].quality += electrode.quality
                    regionalData[electrode.region].count += 1
                }
            }

            // Calculate averages
            for (var k = 0; k < regions.length; k++) {
                var regionName = regions[k]
                if (regionalData[regionName].count > 0) {
                    regionalData[regionName].quality = regionalData[regionName].quality / regionalData[regionName].count
                }
            }
        }
    }

    function showElectrodeDetails(channel, quality) {
        console.log("🔍 Selected electrode:", channel, "Quality:", quality + "%")
    }

    // Initialize data on component completion
    Component.onCompleted: {
        console.log("🧠 Initializing Signal Quality Map...")

        // Initialize electrode positions
        electrodePositions = standard10_20Positions
        console.log("📍 Electrode positions:", electrodePositions.length)

        // Initialize quality data
        qualityData = generateQualityData()
        console.log("📊 Quality data:", qualityData.length, "electrodes")

        // Calculate initial metrics
        updateRegionalData()
        overallQuality = calculateOverallQuality()
        goodChannelsCount = calculateGoodChannelsCount()

        console.log("✅ Signal Quality Map initialized successfully")
        console.log("📈 Initial metrics - Overall:", Math.round(overallQuality) + "%, Good channels:", goodChannelsCount)
    }

    // Auto-refresh timer
    Timer {
        interval: updateInterval
        running: autoRefresh && qualityData && qualityData.length > 0
        repeat: true
        onTriggered: refreshData()
    }
}
