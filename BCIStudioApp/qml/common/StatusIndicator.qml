import QtQuick
import QtQuick.Layouts

Rectangle {
    id: statusIndicator

    property string label: ""
    property string value: ""
    property color statColor: "#7C4DFF"
    property string icon: ""

    width: 100
    height: 50
    radius: 6
    color: "#252540"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Text {
            text: statusIndicator.icon
            font.pixelSize: 14
        }

        ColumnLayout {
            spacing: 2

            Text {
                text: statusIndicator.label
                color: "#AAAAAA"
                font.pixelSize: 9
                font.bold: true
            }

            Text {
                text: statusIndicator.value
                color: statusIndicator.statColor
                font.bold: true
                font.pixelSize: 12
            }
        }
    }
}
