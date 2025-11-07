import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Rectangle {
    id: themeSwitcher

    property int size: 40
    property string currentTheme: themeManager.currentTheme

    width: size * 2
    height: size
    radius: height / 2
    color: theme.backgroundTertiary
    border.color: theme.border
    border.width: 2

    // Track
    Rectangle {
        id: track
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"

        // Background gradient based on theme
        gradient: Gradient {
            GradientStop {
                position: 0.0;
                color: currentTheme === "dark" ? "#4A4A66" : "#E0E4FF"
            }
            GradientStop {
                position: 1.0;
                color: currentTheme === "dark" ? "#6B6B8C" : "#F0F2FF"
            }
        }
    }

    // Thumb
    Rectangle {
        id: thumb
        x: currentTheme === "dark" ? parent.width - width - 4 : 4
        y: 4
        width: parent.height - 8
        height: width
        radius: width / 2

        gradient: theme.primaryGradient

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 2
            radius: 8
            samples: 17
            color: theme.shadow
        }

        // Icons
        Text {
            anchors.centerIn: parent
            text: currentTheme === "dark" ? "🌙" : "☀️"
            font.pixelSize: parent.height * 0.5
            opacity: 0.9
        }

        Behavior on x {
            NumberAnimation {
                duration: themeManager.transitionDuration
                easing.type: Easing.OutCubic
            }
        }
    }

    // Labels
    Text {
        text: "☀️"
        font.pixelSize: size * 0.3
        color: theme.textTertiary
        anchors {
            left: parent.left
            leftMargin: size * 0.3
            verticalCenter: parent.verticalCenter
        }
        opacity: currentTheme === "light" ? 1.0 : 0.5
    }

    Text {
        text: "🌙"
        font.pixelSize: size * 0.3
        color: theme.textTertiary
        anchors {
            right: parent.right
            rightMargin: size * 0.3
            verticalCenter: parent.verticalCenter
        }
        opacity: currentTheme === "dark" ? 1.0 : 0.5
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: themeManager.toggleTheme()
    }

    // Tooltip
    Rectangle {
        visible: themeSwitcherMouseArea.containsMouse
        width: tooltipText.width + 16
        height: tooltipText.height + 12
        radius: 6
        color: theme.backgroundElevated
        border.color: theme.border
        x: parent.width / 2 - width / 2
        y: -height - 8

        Text {
            id: tooltipText
            text: "Switch to " + (currentTheme === "dark" ? "Light" : "Dark") + " Theme"
            color: theme.textPrimary
            font.pixelSize: 11
            anchors.centerIn: parent
        }
    }

    MouseArea {
        id: themeSwitcherMouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}
