import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
// CommandChip.qml

Rectangle {
    width: 80
    height: 60
    radius: 12

    property string chipCommand: ""
    property real chipConfidence: 0
    property var chipTimestamp: new Date()

    color: getCommandColorForChip(chipCommand)

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 2

        Text {
            text: getCommandIconForChip(chipCommand)
            font.pixelSize: 16
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: chipCommand
            color: "white"
            font.bold: true
            font.pixelSize: 10
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: Math.round(chipConfidence * 100) + "%"
            color: Qt.rgba(1, 1, 1, 0.8)
            font.pixelSize: 8
            Layout.alignment: Qt.AlignHCenter
        }
    }

    function getCommandColorForChip(command) {
        const colors = {
            "LEFT": "#2196F3", "RIGHT": "#4CAF50", "UP": "#FF9800",
            "DOWN": "#F44336", "SELECT": "#9C27B0", "NEUTRAL": "#757575"
        }
        return colors[command] || "#607D8B"
    }

    function getCommandIconForChip(command) {
        const icons = {
            "LEFT": "⬅️", "RIGHT": "➡️", "UP": "⬆️", "DOWN": "⬇️",
            "SELECT": "✅", "NEUTRAL": "⏸️"
        }
        return icons[command] || "❓"
    }
}
