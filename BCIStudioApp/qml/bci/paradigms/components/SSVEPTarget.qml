import QtQuick
import QtQuick.Layouts

// SSVEP Target Component
Rectangle {
    id: ssvepTarget
    
    property real frequency: 10
    property bool isActive: false
    property bool isFocused: false
    property real stimulationDuration: 5
    
    radius: 12
    color: theme.surface
    border.color: isFocused ? "#00BFA5" : theme.border
    border.width: isFocused ? 3 : 1
    
    // Flickering animation
    SequentialAnimation on color {
        running: isActive
        loops: Animation.Infinite
        
        ColorAnimation {
            from: theme.surface
            to: "#E0F2F1"
            duration: 1000 / (frequency * 2) // Convert Hz to duration
        }
        
        ColorAnimation {
            from: "#E0F2F1"
            to: theme.surface
            duration: 1000 / (frequency * 2)
        }
    }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 8
        
        Text {
            text: frequency + " Hz"
            color: ssvepTarget.isActive ? "#00BFA5" : theme.textPrimary
            font.bold: true
            font.pixelSize: 16
            font.family: "Segoe UI"
            Layout.alignment: Qt.AlignHCenter
        }
        
        Text {
            text: "SSVEP Target"
            color: theme.textSecondary
            font.pixelSize: 12
            font.family: "Segoe UI"
            Layout.alignment: Qt.AlignHCenter
        }
        
        // Visual flicker indicator
        Rectangle {
            width: 20
            height: 4
            radius: 2
            color: ssvepTarget.isActive ? "#00BFA5" : theme.textTertiary
            Layout.alignment: Qt.AlignHCenter
            
            SequentialAnimation on opacity {
                running: ssvepTarget.isActive
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 0.3; duration: 1000 / (frequency * 2) }
                NumberAnimation { from: 0.3; to: 1.0; duration: 1000 / (frequency * 2) }
            }
        }
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: ssvepTarget.clicked()
    }
    
    signal clicked()
}

