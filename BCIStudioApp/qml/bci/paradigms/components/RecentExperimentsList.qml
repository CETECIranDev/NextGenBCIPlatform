import QtQuick
import QtQuick.Layouts

Rectangle {
    id: recentExperiments
    
    height: 120
    radius: 8
    color: "#1A1A2E"
    border.color: "#333344"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 8
        
        Text {
            text: "Recent Activity"
            color: "white"
            font.bold: true
            font.pixelSize: 12
            font.family: "Segoe UI"
        }

        RowLayout {
            spacing: 15
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            RecentExperimentItem {
                paradigm: "P300"
                subject: "S001"
                date: "2 hours ago"
                accuracy: "92%"
                Layout.fillWidth: true
            }
            
            RecentExperimentItem {
                paradigm: "SSVEP"
                subject: "S002"
                date: "5 hours ago"
                accuracy: "85%"
                Layout.fillWidth: true
            }
            
            RecentExperimentItem {
                paradigm: "Motor Imagery"
                subject: "S003"
                date: "1 day ago"
                accuracy: "88%"
                Layout.fillWidth: true
            }
            
            RecentExperimentItem {
                paradigm: "ERP"
                subject: "S004"
                date: "2 days ago"
                accuracy: "94%"
                Layout.fillWidth: true
            }
        }
    }
}