import QtQuick
import QtQuick.Controls

Rectangle {
    id: themeSwitcher

    property int size: 40
    property string currentTheme: appTheme.currentTheme

    width: size * 2
    height: size
    radius: height / 2
    color: "transparent"
    border.color: theme.border
    border.width: 1

    // Track
    // Rectangle {
    //     anchors.fill: parent
    //     radius: parent.radius
    //     gradient: Gradient {
    //         GradientStop { position: 0.0; color: currentTheme === "dark" ? "#4A4A66" : "#E0E4FF" }
    //         GradientStop { position: 1.0; color: currentTheme === "dark" ? "#6B6B8C" : "#F0F2FF" }
    //     }
    // }

    // Thumb
    Rectangle {
        id: thumb
        x: currentTheme === "dark" ? parent.width - width - 4 : 4
        y: 4
        width: parent.height - 8
        height: width
        radius: width / 2

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#9B77FF" }
            GradientStop { position: 0.5; color: "#7C4DFF" }
            GradientStop { position: 1.0; color: "#6A3CE8" }
        }

        Text {
            anchors.centerIn: parent
            text: currentTheme === "dark" ? "🌙" : "☀️"
            font.pixelSize: parent.height * 0.5
        }

        Behavior on x {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
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
        onClicked: {
            console.log("=== THEME SWITCHER CLICKED ===")
            appTheme.toggleTheme()
        }
    }

    // Binding برای به‌روزرسانی خودکار
    Binding {
        target: themeSwitcher
        property: "currentTheme"
        value: appTheme.currentTheme
    }
}
