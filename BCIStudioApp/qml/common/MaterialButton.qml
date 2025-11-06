import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Button {
    id: materialButton

    property color buttonColor: theme.primary
    property color textColor: "white"
    property real elevation: 2
    property bool rounded: false
    property string tooltip: ""
    property bool isHighlighted: false
    property color highlightColor: theme.primary
    property color normalColor: theme.surface
    property color highlightedTextColor: "white"
    property color normalTextColor: theme.textPrimary
    property bool showRipple: true

    background: Rectangle {
        id: bg
        radius: rounded ? height / 2 : 8
        color: getBackgroundColor()
        border.width: materialButton.isHighlighted ? 2 : 1
        border.color: materialButton.isHighlighted ? highlightColor : theme.border

        layer.enabled: elevation > 0 && !materialButton.down
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: elevation
            radius: elevation * 3
            samples: (radius * 2) + 1
            color: materialButton.isHighlighted ? "#60" + highlightColor.toString().substring(1) : "#20000000"
        }

        // Smooth color transitions
        Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        Behavior on border.color {
            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        // Ripple effect for highlighted state
        Rectangle {
            id: highlightGlow
            anchors.fill: parent
            radius: parent.radius
            color: highlightColor
            opacity: materialButton.isHighlighted ? 0.1 : 0
            visible: materialButton.isHighlighted

            Behavior on opacity {
                NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
            }
        }

        // Ripple effect on click
        Rectangle {
            id: ripple
            width: 0
            height: 0
            radius: width / 2
            color: Qt.rgba(1, 1, 1, 0.3)
            x: materialButton.width / 2
            y: materialButton.height / 2
            visible: false
        }
    }

    contentItem: Text {
        text: materialButton.text
        color: materialButton.isHighlighted ? highlightedTextColor : normalTextColor
        font.bold: true
        font.pixelSize: 14
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        Behavior on color {
            ColorAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
    }

    padding: 12
    leftPadding: 20
    rightPadding: 20

    // Ripple animation
    onPressed: {
        if (showRipple) {
            ripple.x = mouseX
            ripple.y = mouseY
            ripple.visible = true
            rippleAnim.start()
        }
    }

    ParallelAnimation {
        id: rippleAnim
        NumberAnimation {
            target: ripple
            property: "width"
            from: 0
            to: materialButton.width * 2
            duration: 600
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: ripple
            property: "height"
            from: 0
            to: materialButton.width * 2
            duration: 600
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: ripple
            property: "opacity"
            from: 0.3
            to: 0
            duration: 600
            easing.type: Easing.OutCubic
        }
    }

    function getBackgroundColor() {
        if (materialButton.down) {
            return Qt.darker(materialButton.isHighlighted ? highlightColor : normalColor, 1.2)
        } else if (materialButton.hovered) {
            return Qt.darker(materialButton.isHighlighted ? highlightColor : normalColor, 1.1)
        } else {
            return materialButton.isHighlighted ? highlightColor : normalColor
        }
    }

    // Tooltip implementation (same as before)
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.NoButton
        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor

        property var tooltipItem: null

        onEntered: {
            if (materialButton.tooltip && !materialButton.down) {
                tooltipTimer.start()
            }
        }

        onExited: {
            tooltipTimer.stop()
            if (tooltipItem) {
                tooltipItem.destroy()
                tooltipItem = null
            }
        }

        Timer {
            id: tooltipTimer
            interval: 500
            onTriggered: {
                if (!tooltipItem) {
                    tooltipItem = tooltipComp.createObject(materialButton.parent, {
                        text: materialButton.tooltip,
                        x: materialButton.x + (materialButton.width - 100) / 2,
                        y: materialButton.y - 40
                    })
                }
            }
        }
    }

    Component {
        id: tooltipComp

        Rectangle {
            id: tooltipRect
            width: Math.min(200, tooltipText.contentWidth + 20)
            height: tooltipText.contentHeight + 12
            radius: 6
            color: "#E0E0E0"
            opacity: 0
            z: 1000

            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 2
                radius: 8
                samples: 17
                color: "#40000000"
            }

            Text {
                id: tooltipText
                text: parent.parent.tooltip
                color: "#212121"
                font.pixelSize: 12
                font.bold: true
                anchors.centerIn: parent
                wrapMode: Text.Wrap
                width: parent.width - 16
                horizontalAlignment: Text.AlignHCenter
            }

            NumberAnimation on opacity {
                from: 0
                to: 0.95
                duration: 200
                running: true
            }

            Timer {
                interval: 3000
                running: true
                onTriggered: destroyAnim.start()
            }

            SequentialAnimation {
                id: destroyAnim
                NumberAnimation {
                    target: tooltipRect
                    property: "opacity"
                    to: 0
                    duration: 200
                }
                ScriptAction {
                    script: tooltipRect.destroy()
                }
            }
        }
    }
}
