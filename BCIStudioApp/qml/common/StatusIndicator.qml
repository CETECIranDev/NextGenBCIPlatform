import QtQuick
import QtQuick.Layouts

Item {
    id: statusIndicator
    width: 80
    height: 36
    
    property string label: "STATUS"
    property string value: "100%"
	property color statColor: "#7C4DFF"
    property string status: "success" // success, warning, error, processing
    property string icon: "⚡"
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 2
        
        Row {
            spacing: 4
            Layout.alignment: Qt.AlignHCenter
            
            Text {
                text: statusIndicator.icon
                font.pixelSize: 10
                color: getStatusColor()
            }
            
            Text {
                text: statusIndicator.label
                font.pixelSize: 9
                font.weight: Font.Medium
                color: theme.textTertiary
                font.letterSpacing: 0.5
            }
        }
        
        Text {
            text: statusIndicator.value
            font.pixelSize: 11
            font.weight: Font.Bold
            color: getStatusColor()
            Layout.alignment: Qt.AlignHCenter
        }
    }
    
    function getStatusColor() {
        switch(status) {
            case "success": return theme.success
            case "warning": return theme.warning
            case "error": return theme.error
            case "processing": return theme.info
            default: return theme.textSecondary
        }
    }
}