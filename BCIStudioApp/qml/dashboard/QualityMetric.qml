import QtQuick
import QtQuick.Layouts

Rectangle {
    id: qualityMetric
    height: 40
    radius: 8
    color: Qt.rgba(metricColor.r, metricColor.g, metricColor.b, 0.1)
    border.color: Qt.rgba(metricColor.r, metricColor.g, metricColor.b, 0.3)
    border.width: 1

    property string label: ""
    property string value: ""
    property color metricColor: theme.primary
    property string trend: ""

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true

            Text {
                text: label
                color: theme.textSecondary
                font.pixelSize: 10
                font.bold: true
            }

            Text {
                text: value
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 14
            }
        }

        Text {
            text: trend
            color: trend.startsWith('+') ? "#4CAF50" : trend.startsWith('-') ? "#F44336" : theme.textSecondary
            font.bold: true
            font.pixelSize: 10
        }
    }
}