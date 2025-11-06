import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: controlPanel
    
    property color accentColor: "#7C4DFF"
    
    width: 320
    color: theme.backgroundSecondary
    border.color: theme.border
    border.width: 1
    
    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        
        // Panel Header
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: controlPanel.accentColor
            
            Text {
                text: "🧠 Control Panel"
                color: "white"
                font.bold: true
                font.pixelSize: 16
                font.family: "Segoe UI"
                anchors.centerIn: parent
            }
        }
        
        // Scrollable Content
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            ColumnLayout {
                width: controlPanel.width
                spacing: 16
                anchors.margins: 16
                
                // Experiment Controls
                ControlSection {
                    title: "Experiment Controls"
                    icon: "⚡"
                    
                    ColumnLayout {
                        spacing: 8
                        width: parent.width
                        
                        MaterialButton {
                            text: "🎬 Start Experiment"
                            buttonColor: "#00C853"
                            elevation: 2
                            Layout.fillWidth: true
                        }
                        
                        MaterialButton {
                            text: "⏸️ Pause"
                            buttonColor: theme.warning
                            elevation: 1
                            Layout.fillWidth: true
                        }
                        
                        MaterialButton {
                            text: "⏹️ Stop"
                            buttonColor: theme.error
                            elevation: 1
                            Layout.fillWidth: true
                        }
                    }
                }
                
                // Parameters
                ControlSection {
                    title: "Parameters"
                    icon: "📊"
                    Layout.fillWidth: true
                    
                    GridLayout {
                        columns: 2
                        columnSpacing: 12
                        rowSpacing: 8
                        width: parent.width
                        
                        Text { text: "Duration:"; color: theme.textSecondary; font.pixelSize: 12 }
                        Text { text: "05:00"; color: theme.textPrimary; font.bold: true; font.pixelSize: 12 }
                        
                        Text { text: "Trials:"; color: theme.textSecondary; font.pixelSize: 12 }
                        Text { text: "40/120"; color: theme.textPrimary; font.bold: true; font.pixelSize: 12 }
                        
                        Text { text: "Accuracy:"; color: theme.textSecondary; font.pixelSize: 12 }
                        Text { text: "92%"; color: "#00C853"; font.bold: true; font.pixelSize: 12 }
                        
                        Text { text: "Signal Quality:"; color: theme.textSecondary; font.pixelSize: 12 }
                        Text { text: "Excellent"; color: "#00C853"; font.bold: true; font.pixelSize: 12 }
                    }
                }
                
                // Quick Settings
                ControlSection {
                    title: "Quick Settings"
                    icon: "🎛️"
                    Layout.fillWidth: true
                    
                    ColumnLayout {
                        spacing: 8
                        width: parent.width
                        
                        CheckBox {
                            text: "Real-time Feedback"
                            checked: true
                        }
                        
                        CheckBox {
                            text: "Sound Effects"
                            checked: false
                        }
                        
                        CheckBox {
                            text: "Auto Save Data"
                            checked: true
                        }
                    }
                }
            }
        }
    }
}

