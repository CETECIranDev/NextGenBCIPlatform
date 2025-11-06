import QtQuick
import QtQuick.Layouts

Rectangle {
    id: legendItem

    property string component: ""
    property color itemColor: "#7C4DFF"  // تغییر نام از color به itemColor
    property int latency: 300
    property real amplitude: 5.0

    height: 25
    radius: 4
    color: "#252540"  // این color داخلی Rectangle هست

    RowLayout {
        anchors.fill: parent
        anchors.margins: 4
        spacing: 6

        Rectangle {
            width: 12
            height: 3
            radius: 1.5
            color: legendItem.itemColor  // استفاده از itemColor به جای color
        }

        ColumnLayout {
            spacing: 0

            Text {
                text: legendItem.component
                color: "white"
                font.bold: true
                font.pixelSize: 9
            }

            Text {
                text: legendItem.latency + "ms • " + legendItem.amplitude.toFixed(1) + "µV"
                color: "#AAAAAA"
                font.pixelSize: 8
            }
        }
    }
}
