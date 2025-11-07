import QtQuick
import QtQuick.Layouts

Rectangle {
    id: distributionPill
    height: 24
    radius: 12
    color: Qt.rgba(pillColor.r, pillColor.g, pillColor.b, 0.1)
    border.color: Qt.rgba(pillColor.r, pillColor.g, pillColor.b, 0.3)
    border.width: 1

    property string label: ""
    property int count: 0
    property int total: 0
    property color pillColor: theme.primary

    RowLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 6

        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: pillColor
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: label
            color: theme.textPrimary
            font.bold: true
            font.pixelSize: 9
            Layout.fillWidth: true
        }

        Text {
            text: count
            color: pillColor
            font.bold: true
            font.pixelSize: 10
        }
    }
}