import QtQuick
import Qt5Compat.GraphicalEffects

Rectangle {
    id: glassButton
    width: 120
    height: 36
    radius: theme.radius.md
    color: "transparent"

    property string text: "Button"
    property string icon: "✨"
    property color backgroundColor: theme.primary
    property bool glowing: true

    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.lighter(backgroundColor, 1.2) }
        GradientStop { position: 1.0; color: backgroundColor }
    }

    layer.enabled: true
    layer.effect: DropShadow {
        color: theme.glow
        radius: glowing ? 12 : 8
        samples: 25
        spread: 0.1
    }

    Row {
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: glassButton.icon
            font.pixelSize: 12
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: glassButton.text
            color: "white"
            font.pixelSize: theme.typography.body2.size
            font.weight: Font.Medium
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true

        onEntered: {
            glassButton.scale = 1.02
        }

        onExited: {
            glassButton.scale = 1.0
        }

        onClicked: glassButton.clicked()
    }

    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    signal clicked()
}
