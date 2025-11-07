import QtQuick
import QtQuick.Layouts

Rectangle {
    id: qualityMetric
    height: 50
    radius: 10
    color: "transparent"
    border.color: Qt.rgba(metricColor.r, metricColor.g, metricColor.b, 0.3)
    border.width: 1

    property string label: ""
    property string value: ""
    property color metricColor: theme.primary
    property string trend: ""

    RowLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8

        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true

            Text {
                text: label
                color: theme.textSecondary
                font.pixelSize: 10
                font.bold: true
                font.capitalization: Font.AllUppercase
            }

            Text {
                text: value
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 16
            }
        }

        Text {
            text: trend
            color: trend.startsWith('+') ? "#4CAF50" : trend.startsWith('-') ? "#F44336" : theme.textSecondary
            font.bold: true
            font.pixelSize: 11
        }
    }
}