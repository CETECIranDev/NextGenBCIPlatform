import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Rectangle {
    id: nodeToolboxCard
    radius: 12
    color: appTheme.backgroundCard
    border.color: appTheme.border
    border.width: 1

    property string nodeType: ""
    property string nodeName: ""
    property string nodeIcon: ""
    property string nodeDescription: ""
    property string nodeCategory: ""
    property color nodeColor: appTheme.primary
    property bool isNew: false
    property bool isFavorite: false

    signal dragStarted(string nodeType, var mouse)
    signal favoriteToggled(string nodeType, bool favorite)

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 2
        radius: 8
        samples: 17
        color: "#10000000"
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // Icon
        Rectangle {
            width: 40
            height: 40
            radius: 8
            color: nodeColor
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: nodeIcon
                font.pixelSize: 16
                color: "white"
                anchors.centerIn: parent
            }

            // New badge
            Rectangle {
                width: 16
                height: 16
                radius: 8
                color: appTheme.accent
                visible: isNew
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: -4

                Text {
                    text: "🆕"
                    font.pixelSize: 8
                    anchors.centerIn: parent
                }
            }
        }

        // Content
        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            RowLayout {
                spacing: 6
                Layout.fillWidth: true

                Text {
                    text: nodeName
                    color: appTheme.textPrimary
                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                // Favorite button
                Text {
                    text: isFavorite ? "★" : "☆"
                    color: isFavorite ? appTheme.warning : appTheme.textTertiary
                    font.pixelSize: 12
                    Layout.alignment: Qt.AlignRight

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            isFavorite = !isFavorite
                            favoriteToggled(nodeType, isFavorite)
                        }
                    }
                }
            }

            Text {
                text: nodeDescription
                color: appTheme.textSecondary
                font.family: "Segoe UI"
                font.pixelSize: 10
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: nodeCategory
                color: nodeColor
                font.family: "Segoe UI"
                font.pixelSize: 9
                font.weight: Font.Medium
            }
        }
    }

    // Drag handle
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.OpenHandCursor
        drag.target: dragItem
        enabled: true

        onPressed: {
            dragItem.parent = nodeToolbox
            dragItem.x = mouseX + parent.x
            dragItem.y = mouseY + parent.y
            dragItem.opacity = 0.8
        }

        onPositionChanged: {
            if (drag.active) {
                dragStarted(nodeType, mouse)
            }
        }

        onReleased: {
            dragItem.opacity = 0
            dragItem.parent = null
        }
    }

    Item {
        id: dragItem
        width: parent.width
        height: parent.height
        opacity: 0
        visible: opacity > 0

        Rectangle {
            anchors.fill: parent
            radius: 12
            color: appTheme.backgroundCard
            border.color: appTheme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Rectangle {
                    width: 40
                    height: 40
                    radius: 8
                    color: nodeToolboxCard.nodeColor

                    Text {
                        text: nodeToolboxCard.nodeIcon
                        font.pixelSize: 16
                        color: "white"
                        anchors.centerIn: parent
                    }
                }

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true

                    Text {
                        text: nodeToolboxCard.nodeName
                        color: appTheme.textPrimary
                        font.family: "Segoe UI Semibold"
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                        elide: Text.ElideRight
                    }

                    Text {
                        text: nodeToolboxCard.nodeDescription
                        color: appTheme.textSecondary
                        font.family: "Segoe UI"
                        font.pixelSize: 10
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }

    Behavior on scale {
        NumberAnimation { duration: 150 }
    }

    states: [
        State {
            name: "hovered"
            when: dragItem.containsMouse
            PropertyChanges { target: nodeToolboxCard; scale: 1.02 }
        }
    ]
}
