import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: nodeStatusSection
    color: "transparent"

    property var node: null

    ColumnLayout {
        anchors.fill: parent
        spacing: 4

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: "🔄 Status"
                color: theme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 12
                font.bold: true
            }

            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: getStatusColor()
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                text: getStatusText()
                color: getStatusColor()
                font.family: "Segoe UI"
                font.pixelSize: 11
                font.bold: true
                Layout.fillWidth: true
            }
        }
    }

    function getStatusColor() {
        if (!node) return theme.textTertiary
        if (node.enabled === false) return theme.error
        if (node.status === "processing") return theme.warning
        if (node.status === "error") return theme.error
        return theme.success
    }

    function getStatusText() {
        if (!node) return "No node selected"
        if (node.enabled === false) return "Disabled"
        if (node.status === "processing") return "Processing..."
        if (node.status === "error") return "Error"
        if (node.status === "ready") return "Ready"
        return "Active"
    }
}