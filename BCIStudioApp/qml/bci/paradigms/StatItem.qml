import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: statusItem

    property string label: ""
    property string value: ""
    property real progress: 0
    // property color color: "#7C4DFF"

    height: 60
    radius: 8
    color: theme.backgroundLight
    Layout.fillWidth: true

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 4

        RowLayout {
            Layout.fillWidth: true

            Text {
                text: statusItem.label
                color: theme.textSecondary
                font.pixelSize: 11
                font.family: "Segoe UI"
                Layout.fillWidth: true
            }

            Text {
                text: statusItem.value
                color: statusItem.color
                font.bold: true
                font.pixelSize: 12
                font.family: "Segoe UI"
            }
        }

        // Progress bar
        Rectangle {
            Layout.fillWidth: true
            height: 4
            radius: 2
            color: theme.border

            Rectangle {
                width: parent.width * statusItem.progress
                height: parent.height
                radius: 2
                color: statusItem.color

                Behavior on width {
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }
            }
        }
    }
}
