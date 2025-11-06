// AdvancedSystemStatusCard.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

DashboardCard {
    id: advancedStatusCard
    title: "BCI System Status"
    icon: "🔌"
    subtitle: "Real-time Device Monitoring"

    // Properties
    property bool isConnected: false
    property bool isConnecting: false
    property real batteryLevel: 75
    property string sessionTime: "01:24:36"
    property real signalQuality: 88
    property string deviceName: "NeuroHeadset Pro"
    property string deviceType: "EEG Headset - 16 Channels"
    property string firmwareVersion: "v2.1.4"
    property int samplingRate: 256
    property int activeChannels: 16
    property real dataThroughput: 4.2 // MB/s
    property real latency: 12.5 // ms

    // Computed properties
    property string connectionStatus: {
        if (isConnecting) return "connecting"
        return isConnected ? "connected" : "disconnected"
    }

    property string connectionStatusText: {
        if (isConnecting) return "Connecting to device..."
        return isConnected ? "Device Connected" : "Device Disconnected"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        // Header Status Section
        Rectangle {
            Layout.fillWidth: true
            height: 60
            radius: 8
            color: getOverallStatusColor()
            opacity: 0.1
            border.color: getOverallStatusColor()
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5

                RowLayout {
                    Layout.fillWidth: true

                    StatusIndicator {
                        status: advancedStatusCard.connectionStatus
                        text: advancedStatusCard.connectionStatusText
                        pulseAnimation: advancedStatusCard.isConnecting
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "🔋 " + Math.round(advancedStatusCard.batteryLevel) + "%"
                        color: getBatteryColor(advancedStatusCard.batteryLevel)
                        font.pixelSize: 12
                        font.bold: true
                    }
                }

                // Signal Quality with trend
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "Signal Quality:"
                        color: theme.textSecondary
                        font.pixelSize: 11
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 6
                        radius: 3
                        color: theme.backgroundLight

                        Rectangle {
                            width: parent.width * (advancedStatusCard.signalQuality / 100)
                            height: parent.height
                            radius: 3
                            color: getQualityColor(advancedStatusCard.signalQuality)

                            Behavior on width {
                                NumberAnimation { duration: 800; easing.type: Easing.OutCubic }
                            }
                        }
                    }

                    Text {
                        text: Math.round(advancedStatusCard.signalQuality) + "%"
                        color: getQualityColor(advancedStatusCard.signalQuality)
                        font.pixelSize: 11
                        font.bold: true
                        Layout.preferredWidth: 35
                    }
                }
            }
        }

        // Device Information Grid
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 8
            columnSpacing: 15

            InfoItem {
                label: "Device Name"
                value: advancedStatusCard.deviceName
                icon: "🎧"
                Layout.fillWidth: true
            }

            InfoItem {
                label: "Device Type"
                value: advancedStatusCard.deviceType
                icon: "📋"
                Layout.fillWidth: true
            }

            InfoItem {
                label: "Firmware"
                value: advancedStatusCard.firmwareVersion
                icon: "💾"
                Layout.fillWidth: true
            }

            InfoItem {
                label: "Session Time"
                value: advancedStatusCard.sessionTime
                icon: "⏱️"
                Layout.fillWidth: true
            }

            InfoItem {
                label: "Sampling Rate"
                value: advancedStatusCard.samplingRate + " Hz"
                icon: "📊"
                Layout.fillWidth: true
            }

            InfoItem {
                label: "Active Channels"
                value: advancedStatusCard.activeChannels + " / 16"
                icon: "🔢"
                Layout.fillWidth: true
            }

            InfoItem {
                label: "Data Throughput"
                value: advancedStatusCard.dataThroughput.toFixed(1) + " MB/s"
                icon: "⚡"
                Layout.fillWidth: true
            }

            InfoItem {
                label: "Latency"
                value: advancedStatusCard.latency.toFixed(1) + " ms"
                icon: "⏰"
                Layout.fillWidth: true
            }
        }

        // Connection Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Button {
                id: connectButton
                text: getConnectButtonText()
                Layout.fillWidth: true
                enabled: !advancedStatusCard.isConnecting
                onClicked: toggleConnection()

                contentItem: RowLayout {
                    spacing: 8
                    Text {
                        text: getConnectButtonIcon()
                        font.pixelSize: 14
                    }
                    Text {
                        text: connectButton.text
                        color: theme.textPrimary
                        font.pixelSize: 12
                        font.bold: true
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                }

                background: Rectangle {
                    radius: 6
                    color: getConnectButtonColor()
                }
            }

            Button {
                text: "⚙️"
                Layout.preferredWidth: 40
                ToolTip.text: "Device Settings"
                onClicked: openDeviceSettings()

                background: Rectangle {
                    radius: 6
                    color: theme.primary
                }
            }

            Button {
                text: "🔄"
                Layout.preferredWidth: 40
                ToolTip.text: "Refresh Status"
                onClicked: refreshStatus()

                background: Rectangle {
                    radius: 6
                    color: theme.backgroundLight
                }
            }
        }
    }

    // Functions
    function getOverallStatusColor() {
        if (advancedStatusCard.isConnecting) return "#FF9800"
        if (!advancedStatusCard.isConnected) return "#F44336"
        if (advancedStatusCard.signalQuality < 60) return "#FFC107"
        if (advancedStatusCard.batteryLevel < 20) return "#FF9800"
        return "#4CAF50"
    }

    function getConnectButtonText() {
        if (advancedStatusCard.isConnecting) return "Connecting..."
        return advancedStatusCard.isConnected ? "Disconnect" : "Connect Device"
    }

    function getConnectButtonIcon() {
        if (advancedStatusCard.isConnecting) return "⏳"
        return advancedStatusCard.isConnected ? "🔌" : "🔗"
    }

    function getConnectButtonColor() {
        if (advancedStatusCard.isConnecting) return "#FF9800"
        return advancedStatusCard.isConnected ? "#4CAF50" : "#2196F3"
    }

    function getQualityColor(quality) {
        if (quality >= 80) return "#4CAF50"
        if (quality >= 60) return "#FFC107"
        if (quality >= 40) return "#FF9800"
        return "#F44336"
    }

    function getBatteryColor(level) {
        if (level >= 60) return "#4CAF50"
        if (level >= 30) return "#FFC107"
        if (level >= 15) return "#FF9800"
        return "#F44336"
    }

    function toggleConnection() {
        if (advancedStatusCard.isConnected) {
            disconnectDevice()
        } else {
            connectDevice()
        }
    }

    function connectDevice() {
        advancedStatusCard.isConnecting = true
        console.log("Attempting to connect to device...")

        // Simulate connection process
        connectionTimer.start()
    }

    function disconnectDevice() {
        advancedStatusCard.isConnected = false
        advancedStatusCard.isConnecting = false
        console.log("Device disconnected")

        // Reset metrics on disconnect
        advancedStatusCard.signalQuality = 0
        advancedStatusCard.dataThroughput = 0
        advancedStatusCard.latency = 0
    }

    function refreshStatus() {
        console.log("Refreshing device status...")
        // Simulate status refresh
        advancedStatusCard.signalQuality = Math.max(0, Math.min(100,
            advancedStatusCard.signalQuality + (Math.random() * 10 - 5)))
        advancedStatusCard.batteryLevel = Math.max(0,
            advancedStatusCard.batteryLevel - 0.1)
    }

    function openDeviceSettings() {
        console.log("Opening device settings...")
        // Implement device settings dialog
    }

    // Timer for simulating connection process
    Timer {
        id: connectionTimer
        interval: 3000
        onTriggered: {
            advancedStatusCard.isConnecting = false
            advancedStatusCard.isConnected = true
            console.log("Device connected successfully")

            // Initialize metrics on connection
            advancedStatusCard.signalQuality = 85 + Math.random() * 10
            advancedStatusCard.dataThroughput = 3.5 + Math.random() * 2
            advancedStatusCard.latency = 10 + Math.random() * 10
        }
    }

    // Timer for updating session time when connected
    Timer {
        interval: 1000
        running: advancedStatusCard.isConnected
        repeat: true
        onTriggered: {
            // Update session time logic would go here
        }
    }

    // Simulate real-time data changes
    Timer {
        interval: 2000
        running: advancedStatusCard.isConnected
        repeat: true
        onTriggered: {
            // Simulate small changes in metrics
            advancedStatusCard.signalQuality = Math.max(50, Math.min(100,
                advancedStatusCard.signalQuality + (Math.random() * 6 - 3)))
            advancedStatusCard.batteryLevel = Math.max(0,
                advancedStatusCard.batteryLevel - 0.05)
            advancedStatusCard.dataThroughput = 3 + Math.random() * 3
            advancedStatusCard.latency = 8 + Math.random() * 8
        }
    }
}
