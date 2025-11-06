import QtQuick
import QtQuick.Layouts

Rectangle {
    id: statusPanel
    
    height: 80
    radius: 8
    color: "#1A1A2E"
    border.color: "#333344"
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 20
        
        StatusIndicator {
            label: "EEG SYSTEM"
            value: "Connected"
            status: "online"
            icon: "📶"
            Layout.fillWidth: true
        }
        
        StatusIndicator {
            label: "DATA STORAGE"
            value: "2.3 GB Free"
            status: "normal"
            icon: "💾"
            Layout.fillWidth: true
        }
        
        StatusIndicator {
            label: "PROCESSING"
            value: "24% Load"
            status: "optimal"
            icon: "⚡"
            Layout.fillWidth: true
        }
        
        StatusIndicator {
            label: "NETWORK"
            value: "Stable"
            status: "online"
            icon: "🔗"
            Layout.fillWidth: true
        }
    }
}