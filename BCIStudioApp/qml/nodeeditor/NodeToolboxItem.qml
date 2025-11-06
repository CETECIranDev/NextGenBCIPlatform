import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: toolboxItem
    height: 80
    radius: 8
    color: theme.backgroundCard
    border.color: theme.border
    border.width: 1

    property string nodeType: ""
    property string nodeName: "Node"
    property string nodeIcon: "⚙️"
    property string nodeDescription: "Description"
    property string nodeCategory: "General"
    property color nodeColor: theme.primary

    signal dragStarted(var mouse)

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: undefined // We'll handle drag manually
        cursorShape: Qt.PointingHandCursor

        onPressed: {
            // Create drag image
            toolboxItem.dragStarted(mouse)
        }

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: theme.primary
            opacity: parent.pressed ? 0.1 : parent.containsMouse ? 0.05 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 4

        // Header
        Row {
            width: parent.width
            spacing: 8

            // Icon
            Rectangle {
                width: 32
                height: 32
                radius: 6
                color: toolboxItem.nodeColor
                opacity: 0.9

                Text {
                    text: toolboxItem.nodeIcon
                    font.pixelSize: 14
                    anchors.centerIn: parent
                }
            }

            // Text content
            Column {
                width: parent.width - 48
                spacing: 2

                Text {
                    text: toolboxItem.nodeName
                    color: theme.textPrimary
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    font.bold: true
                    elide: Text.ElideRight
                    width: parent.width
                }

                Text {
                    text: toolboxItem.nodeDescription
                    color: theme.textSecondary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    width: parent.width
                    lineHeight: 1.2
                }
            }
        }

        // Footer with category
        Text {
            text: toolboxItem.nodeCategory
            color: theme.textTertiary
            font.family: "Segoe UI"
            font.pixelSize: 8
            font.bold: true
        }
    }

    // Tooltip
    ToolTip {
        visible: dragArea.containsMouse && !dragArea.pressed
        delay: 500
        text: toolboxItem.nodeName + "\n" + toolboxItem.nodeDescription + "\n\nCategory: " + toolboxItem.nodeCategory
    }
}
