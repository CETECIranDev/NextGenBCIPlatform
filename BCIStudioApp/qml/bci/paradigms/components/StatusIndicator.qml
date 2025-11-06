import QtQuick
import QtQuick.Layouts

Rectangle {
    id: statusIndicator
    
    property string label: ""
    property string value: ""
    property string status: "online" // online, warning, error, normal, optimal
    property string icon: ""
    
    height: 50
    radius: 6
    color: "#252540"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 10
        
        Text {
            text: statusIndicator.icon
            font.pixelSize: 16
        }
        
        ColumnLayout {
            spacing: 2
            
            Text {
                text: statusIndicator.label
                color: "#AAAAAA"
                font.pixelSize: 9
                font.bold: true
                font.family: "Segoe UI"
            }
            
            Text {
                text: statusIndicator.value
                color: getStatusColor(statusIndicator.status)
                font.bold: true
                font.pixelSize: 12
                font.family: "Segoe UI"
            }
        }
        
        // Status Dot
        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: getStatusColor(statusIndicator.status)
            
            SequentialAnimation on opacity {
                running: statusIndicator.status === "online" || statusIndicator.status === "optimal"
                loops: Animation.Infinite
                NumberAnimation { from: 0.7; to: 1.0; duration: 1000 }
                NumberAnimation { from: 1.0; to: 0.7; duration: 1000 }
            }
        }
    }
    
    function getStatusColor(status) {
        switch(status) {
            case "online": return "#00C853"
            case "optimal": return "#7C4DFF"
            case "normal": return "#2196F3"
            case "warning": return "#FFA000"
            case "error": return "#F44336"
            default: return "#666677"
        }
    }
}