import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
// MetricTile.qml

Rectangle {
    height: 80
    radius: 12

    property string metricTitle: ""
    property var metricValue: 0
    property string metricUnit: ""
    property string metricIcon: ""
    property color tileColor: theme.primary
    property string valueTrend: ""

    color: Qt.rgba(tileColor.r, tileColor.g, tileColor.b, 0.1)
    border.color: Qt.rgba(tileColor.r, tileColor.g, tileColor.b, 0.2)
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 4

        RowLayout {
            spacing: 8

            Text {
                text: metricIcon
                font.pixelSize: 16
                color: tileColor
            }

            Text {
                text: metricTitle
                color: theme.textSecondary
                font.pixelSize: 11
                font.bold: true
                Layout.fillWidth: true
            }
        }

        RowLayout {
            spacing: 4

            Text {
                text: metricValue
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 20
            }

            Text {
                text: metricUnit
                color: theme.textSecondary
                font.pixelSize: 12
                visible: metricUnit !== ""
            }

            Text {
                text: valueTrend
                color: tileColor
                font.bold: true
                font.pixelSize: 10
                visible: valueTrend !== ""
            }
        }
    }
}
