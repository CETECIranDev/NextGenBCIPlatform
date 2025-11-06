import QtQuick
import QtQuick.Layouts

Rectangle {
    id: cueVisualization
    
    property string currentCue: "Rest"
    property bool experimentRunning: false
    property real trialProgress: 0
    
    color: "#1A1A2E"
    radius: 12
    border.color: "#333344"
    border.width: 2
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        
        Text {
            text: "CUE VISUALIZATION"
            color: "white"
            font.bold: true
            font.pixelSize: 14
            font.family: "Segoe UI"
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Main Cue Display
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#0F0F1A"
            radius: 8
            border.color: "#252540"
            border.width: 1
            
            // Cue Content based on current cue
            Loader {
                anchors.fill: parent
                sourceComponent: getCueComponent(cueVisualization.currentCue)
            }
            
            // Progress Ring
            Rectangle {
                anchors.fill: parent
                anchors.margins: 10
                color: "transparent"
                border.color: "#FF6D00"
                border.width: 3
                radius: width / 2
                opacity: cueVisualization.experimentRunning ? 0.3 : 0
                
                RotationAnimation on rotation {
                    running: cueVisualization.experimentRunning
                    from: 0
                    to: 360
                    duration: 2000
                    loops: Animation.Infinite
                }
            }
        }
        
        // Trial Progress
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            Text {
                text: "TRIAL PROGRESS"
                color: "#AAAAAA"
                font.pixelSize: 11
                font.family: "Segoe UI"
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 6
                radius: 3
                color: "#333344"
                
                Rectangle {
                    width: parent.width * cueVisualization.trialProgress
                    height: parent.height
                    radius: 3
                    color: "#FF6D00"
                    
                    Behavior on width {
                        NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                    }
                }
            }
            
            Text {
                text: Math.floor(cueVisualization.trialProgress * 100) + "%"
                color: "#FF6D00"
                font.bold: true
                font.pixelSize: 11
                font.family: "Segoe UI"
            }
        }
    }
    
    function getCueComponent(cue) {
        switch(cue) {
            case "Left Hand": return leftHandCueComponent
            case "Right Hand": return rightHandCueComponent
            case "Both Hands": return bothHandsCueComponent
            case "Feet": return feetCueComponent
            case "Tongue": return tongueCueComponent
            default: return restCueComponent
        }
    }
    
    // Cue Components
    Component {
        id: leftHandCueComponent
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 15
            
            Text {
                text: "👈"
                font.pixelSize: 60
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "IMAGINE LEFT HAND MOVEMENT"
                color: "#2196F3"
                font.bold: true
                font.pixelSize: 16
                font.family: "Segoe UI"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
    
    Component {
        id: rightHandCueComponent
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 15
            
            Text {
                text: "👉"
                font.pixelSize: 60
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "IMAGINE RIGHT HAND MOVEMENT"
                color: "#4CAF50"
                font.bold: true
                font.pixelSize: 16
                font.family: "Segoe UI"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
    
    Component {
        id: bothHandsCueComponent
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 15
            
            Text {
                text: "👐"
                font.pixelSize: 60
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "IMAGINE BOTH HANDS MOVEMENT"
                color: "#FF9800"
                font.bold: true
                font.pixelSize: 16
                font.family: "Segoe UI"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
    
    Component {
        id: feetCueComponent
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 15
            
            Text {
                text: "👣"
                font.pixelSize: 60
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "IMAGINE FEET MOVEMENT"
                color: "#9C27B0"
                font.bold: true
                font.pixelSize: 16
                font.family: "Segoe UI"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
    
    Component {
        id: tongueCueComponent
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 15
            
            Text {
                text: "👅"
                font.pixelSize: 60
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "IMAGINE TONGUE MOVEMENT"
                color: "#E91E63"
                font.bold: true
                font.pixelSize: 16
                font.family: "Segoe UI"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
    
    Component {
        id: restCueComponent
        
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 15
            
            Text {
                text: "🧘"
                font.pixelSize: 60
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: "REST STATE - RELAX"
                color: "#666677"
                font.bold: true
                font.pixelSize: 16
                font.family: "Segoe UI"
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}