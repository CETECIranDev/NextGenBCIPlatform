import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Card {
    id: statusCard
    title: "System Status"
    icon: "🔌"

    property bool isConnected: false
    property real batteryLevel: 0
    property string sessionTime: "00:00:00"
    property real signalQuality: 0
    property string deviceName: "Unknown Device"

    contentHeight: 150

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        // Status Row
        RowLayout {
            Layout.fillWidth: true

            StatusIndicator {
                status: statusCard.isConnected ? "connected" : "disconnected"
                text: statusCard.isConnected ? "Connected" : "Disconnected"
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "🔋 " + Math.round(statusCard.batteryLevel) + "%"
                color: theme.textSecondary
                font.pixelSize: 12
            }
        }

        // Device Info
        Text {
            text: statusCard.deviceName
            color: theme.textPrimary
            font.bold: true
            font.pixelSize: 14
            Layout.fillWidth: true
        }

        // Session Time
        Text {
            text: "⏱️ Session: " + statusCard.sessionTime
            color: theme.textSecondary
            font.pixelSize: 12
            Layout.fillWidth: true
        }

        // Signal Quality Bar
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: "Signal Quality:"
                    color: theme.textSecondary
                    font.pixelSize: 11
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: Math.round(statusCard.signalQuality) + "%"
                    color: getQualityColor(statusCard.signalQuality)
                    font.pixelSize: 11
                    font.bold: true
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 6
                radius: 3
                color: theme.backgroundLight

                Rectangle {
                    width: parent.width * (statusCard.signalQuality / 100)
                    height: parent.height
                    radius: 3
                    color: getQualityColor(statusCard.signalQuality)

                    Behavior on width {
                        NumberAnimation { duration: 500 }
                    }
                }
            }
        }

        // Connection Controls
        RowLayout {
            Layout.fillWidth: true

            Button {
                text: statusCard.isConnected ? "Disconnect" : "Connect"
                Layout.fillWidth: true
                onClicked: {
                    // Emit connection toggle signal
                    console.log("Connection toggle requested")
                }
            }

            Button {
                text: "Refresh"
                Layout.preferredWidth: 80
                flat: true
                onClicked: {
                    console.log("Refresh status requested")
                }
            }
        }
    }

    function getQualityColor(quality) {
        if (quality >= 80) return "#4CAF50"
        if (quality >= 60) return "#FF9800"
        return "#F44336"
    }
}
