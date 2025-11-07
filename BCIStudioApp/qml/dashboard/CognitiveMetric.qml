import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects  // برای Qt 6

// CognitiveMetric.qml
Rectangle {
    height: 60
    radius: 8

    property string title: ""
    property real value: 0
    // /property color color: theme.primary
    property string icon: ""

    color: Qt.rgba(color.r, color.g, color.b, 0.1)
    border.color: Qt.rgba(color.r, color.g, color.b, 0.2)
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Text {
            text: icon
            font.pixelSize: 16
            color: color
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true

            Text {
                text: title
                color: theme.textSecondary
                font.pixelSize: 10
                font.bold: true
            }

            Text {
                text: Math.round(value) + "%"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 14
            }
        }

        // Circular progress
        Rectangle {
            width: 24
            height: 24
            radius: 12
            color: "transparent"
            border.color: color
            border.width: 2

            Text {
                anchors.centerIn: parent
                text: Math.round(value)
                color: color
                font.bold: true
                font.pixelSize: 9
            }
        }
    }
}
