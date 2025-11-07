import QtQuick
import QtQuick.Layouts

Rectangle {
    id: distributionBar
    height: 28
    radius: 6
    color: "transparent"

    property string label: ""
    property int count: 0
    property int total: 0
    property color barColor: theme.primary
    property real percentage: total > 0 ? (count / total) * 100 : 0

    RowLayout {
        anchors.fill: parent
        spacing: 8

        Text {
            text: label
            color: theme.textPrimary
            font.bold: true
            font.pixelSize: 10
            Layout.preferredWidth: 50
        }

        // Progress bar
        Rectangle {
            Layout.fillWidth: true
            height: 6
            radius: 3
            color: Qt.rgba(barColor.r, barColor.g, barColor.b, 0.2)

            Rectangle {
                width: parent.width * (percentage / 100)
                height: parent.height
                radius: 3
                color: barColor
                
                Behavior on width {
                    NumberAnimation { duration: 500; easing.type: Easing.OutCubic }
                }
            }
        }

        Text {
            text: count
            color: barColor
            font.bold: true
            font.pixelSize: 11
            Layout.preferredWidth: 20
        }
    }
}