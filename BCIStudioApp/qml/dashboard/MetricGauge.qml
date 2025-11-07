import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Rectangle {
    height: 80
    radius: 8

    property string title: ""
    property real value: 0
    property string unit: ""
    property color color: theme.primary
    property string icon: ""
    property string trend: ""

    color: Qt.rgba(color.r, color.g, color.b, 0.1)
    border.color: Qt.rgba(color.r, color.g, color.b, 0.3)
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4

        RowLayout {
            spacing: 6

            Text {
                text: icon
                font.pixelSize: 14
                color: color
            }

            Text {
                text: title
                color: theme.textSecondary
                font.pixelSize: 10
                font.bold: true
                Layout.fillWidth: true
            }

            Text {
                text: trend
                color: color
                font.bold: true
                font.pixelSize: 9
                visible: trend !== ""
            }
        }

        RowLayout {
            spacing: 4

            Text {
                text: value.toFixed(1)
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 16
            }

            Text {
                text: unit
                color: theme.textSecondary
                font.pixelSize: 12
            }
        }

        // Progress bar
        Rectangle {
            Layout.fillWidth: true
            height: 4
            radius: 2
            color: theme.backgroundLight

            Rectangle {
                width: parent.width * (value / 100)
                height: parent.height
                radius: parent.radius
                color: color

                Behavior on width {
                    NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                }
            }
        }
    }
}