import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    id: systemStatusCard
    height: 180
    radius: 16
    color: appTheme.backgroundCard
    border.color: appTheme.border
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Header
        Text {
            text: "System Status"
            color: appTheme.textPrimary
            font.family: robotoBold.name
            font.pixelSize: 20
            Layout.fillWidth: true
        }

        // Status indicators
        GridLayout {
            columns: 2
            rowSpacing: 12
            columnSpacing: 20
            Layout.fillWidth: true
            Layout.fillHeight: true

            StatusIndicator {
                label: "BCI Device"
                status: "connected"
                value: "NeuroScan SynAmps2"
                icon: "📡"
                Layout.fillWidth: true
            }

            StatusIndicator {
                label: "Signal Quality"
                status: "good"
                value: "92%"
                icon: "📊"
                Layout.fillWidth: true
            }

            StatusIndicator {
                label: "CPU Usage"
                status: "normal"
                value: "45%"
                icon: "⚡"
                Layout.fillWidth: true
            }

            StatusIndicator {
                label: "Memory"
                status: "normal"
                value: "1.2/8 GB"
                icon: "💾"
                Layout.fillWidth: true
            }
        }
    }
}
