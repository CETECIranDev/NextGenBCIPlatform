// qml/core/ThemeSwitcher.qml
import QtQuick
import QtQuick.Controls

Item {
    id: themeSwitcher
    
    property string currentTheme: appTheme.currentTheme
    property real size: 40
    
    width: size
    height: size
    
    Rectangle {
        id: switchBackground
        anchors.fill: parent
        radius: width / 2
        color: theme.backgroundCard
        border.color: theme.border
        border.width: 1
        
        gradient: theme.currentTheme === "dark" ? darkGradient : lightGradient
        
        Gradient {
            id: darkGradient
            GradientStop { position: 0.0; color: Qt.lighter(theme.backgroundCard, 1.2) }
            GradientStop { position: 1.0; color: theme.backgroundCard }
        }
        
        Gradient {
            id: lightGradient
            GradientStop { position: 0.0; color: Qt.darker(theme.backgroundCard, 1.1) }
            GradientStop { position: 1.0; color: theme.backgroundCard }
        }
    }
    
    // آیکون
    Text {
        id: themeIcon
        anchors.centerIn: parent
        text: appTheme.currentTheme === "dark" ? "🌙" : "☀️"
        font.pixelSize: parent.size * 0.5
        color: theme.textPrimary
    }
    
    // افکت hover
    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: switchBackground
                scale: 1.1
            }
        },
        State {
            name: "pressed" 
            when: mouseArea.pressed
            PropertyChanges {
                target: switchBackground
                scale: 0.95
            }
        }
    ]
    
    transitions: Transition {
        PropertyAnimation {
            properties: "scale"
            duration: 200
            easing.type: Easing.OutCubic
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            appTheme.toggleTheme()
            // افکت کلیک
            clickAnimation.start()
        }
    }
    
    SequentialAnimation {
        id: clickAnimation
        PropertyAnimation {
            target: themeIcon
            property: "scale"
            from: 1.0
            to: 0.7
            duration: 100
        }
        PropertyAnimation {
            target: themeIcon  
            property: "scale"
            from: 0.7
            to: 1.0
            duration: 100
        }
    }
    
    ToolTip {
        text: appTheme.currentTheme === "dark" ? "Switch to Light Mode" : "Switch to Dark Mode"
        delay: 500
    }
}
