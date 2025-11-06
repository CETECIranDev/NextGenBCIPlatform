// qml/common/MaterialButton.qml
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects  // برای Qt 6

Rectangle {
    id: materialButton

    property string text: ""
    property string tooltip: ""
    property int elevation: 1
    property color buttonColor: theme.primary
    property bool highlighted: false

    width: 40
    height: 40
    radius: theme.radius.round
    color: highlighted ? buttonColor : theme.backgroundCard

    // سایه
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: elevation
        radius: elevation * 2
        samples: (elevation * 2) * 2 + 1
        color: "#20000000"
    }

    // آیکون/متن
    Text {
        anchors.centerIn: parent
        text: materialButton.text
        color: highlighted ? theme.textInverted : theme.textPrimary
        font.pixelSize: 16
    }

    // افکت‌ها
    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: materialButton
                elevation: 2
                scale: 1.1
            }
        },
        State {
            name: "pressed"
            when: mouseArea.pressed
            PropertyChanges {
                target: materialButton
                elevation: 0
                scale: 0.95
                color: highlighted ? Qt.darker(buttonColor, 1.2) : Qt.darker(theme.backgroundCard, 1.1)
            }
        }
    ]

    transitions: Transition {
        PropertyAnimation {
            properties: "scale, elevation, color"
            duration: theme.animation.fast
            easing.type: Easing.OutCubic
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: materialButton.clicked()
    }

    ToolTip {
        text: materialButton.tooltip
        delay: 500
        visible: mouseArea.containsMouse && materialButton.tooltip !== ""
    }

    signal clicked()
}
