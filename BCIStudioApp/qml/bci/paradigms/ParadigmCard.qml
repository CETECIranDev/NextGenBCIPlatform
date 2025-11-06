import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "../../common"
Rectangle {
    id: paradigmCard

    property string title: ""
    property string icon: ""
    property string description: ""
    property string stats: ""
    property color color: "#7C4DFF"
    property string paradigmType: ""

    signal selected(string paradigmType)

    width: 320
    height: 200
    radius: 16
    color: theme.backgroundCard
    border.color: mouseArea.containsMouse ? theme.primary : theme.border
    border.width: mouseArea.containsMouse ? 2 : 1

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 4
        radius: 12
        samples: 25
        color: "#20000000"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            clickAnimation.start()
            selected(paradigmType)
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 12

        // Header
        RowLayout {
            spacing: 12

            Rectangle {
                width: 48
                height: 48
                radius: 12
                color: paradigmCard.color

                Text {
                    text: icon
                    font.pixelSize: 20
                    color: "white"
                    anchors.centerIn: parent
                }
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                Text {
                    text: title
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 18
                    Layout.fillWidth: true
                }

                Text {
                    text: stats
                    color: theme.textSecondary
                    font.pixelSize: 12
                    Layout.fillWidth: true
                }
            }

            MaterialButton {
                text: "▶"
                buttonColor: theme.surface
                textColor: theme.primary
                rounded: true
                elevation: 0
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32
            }
        }

        // Description
        Text {
            text: description
            color: theme.textSecondary
            font.pixelSize: 14
            wrapMode: Text.Wrap
            lineHeight: 1.4
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // Footer with tags
        RowLayout {
            spacing: 8

            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: paradigmCard.color
            }

            Text {
                text: getParadigmTag(paradigmType)
                color: theme.textSecondary
                font.pixelSize: 11
                font.bold: true
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "⚡ Active"
                color: theme.success
                font.pixelSize: 11
                font.bold: true
                visible: paradigmType === "p300" || paradigmType === "ssvep"
            }
        }
    }

    // Animation
    SequentialAnimation {
        id: clickAnimation
        PropertyAnimation {
            target: paradigmCard
            property: "scale"
            from: 1.0
            to: 0.95
            duration: 100
        }
        PropertyAnimation {
            target: paradigmCard
            property: "scale"
            from: 0.95
            to: 1.0
            duration: 100
        }
    }

    function getParadigmTag(type) {
        switch(type) {
            case "p300": return "VISUAL ERP"
            case "ssvep": return "STEADY-STATE"
            case "motor_imagery": return "MOTOR CORTEX"
            case "erp": return "COGNITIVE ERP"
            default: return "CUSTOM"
        }
    }
}
