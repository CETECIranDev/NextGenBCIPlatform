import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: toolbar
    
    property string title: ""
    property string subtitle: ""
    property color accentColor: "#7C4DFF"
    
    height: 70
    color: theme.backgroundSecondary
    border.color: theme.border
    border.width: 0
    z: 10
    
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        spacing: 20
        
        // Back button and title
        RowLayout {
            spacing: 16
            Layout.fillWidth: true
            
            MaterialButton {
                text: "←"
                buttonColor: "transparent"
                textColor: theme.textPrimary
                rounded: true
                elevation: 0
                onClicked: backRequested()
            }
            
            ColumnLayout {
                spacing: 2
                
                Text {
                    text: toolbar.title
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 20
                    font.family: "Segoe UI"
                }
                
                Text {
                    text: toolbar.subtitle
                    color: theme.textSecondary
                    font.pixelSize: 12
                    font.family: "Segoe UI"
                }
            }
        }
        
        // Status indicators
        RowLayout {
            spacing: 16
            
            StatusIndicator {
                label: "EEG Signal"
                value: "Excellent"
                statColor: "#00C853"
                icon: "📶"
            }
            
            StatusIndicator {
                label: "Noise Level"
                value: "Low"
                statColor: "#FFD600"
                icon: "🔇"
            }
            
            StatusIndicator {
                label: "Connection"
                value: "Stable"
                statColor: "#00C853"
                icon: "🔗"
            }
        }
        
        // Action buttons
        RowLayout {
            spacing: 8
            
            MaterialButton {
                text: "⏸️ Pause"
                buttonColor: theme.surface
                textColor: theme.primary
                tooltip: "Pause experiment"
            }
            
            MaterialButton {
                text: "⏹️ Stop"
                buttonColor: theme.error
                tooltip: "Stop experiment immediately"
            }
            
            MaterialButton {
                text: "⚙️ Settings"
                buttonColor: theme.surface
                textColor: theme.primary
                tooltip: "Open experiment settings"
            }
        }
    }
    
    signal backRequested()
}

