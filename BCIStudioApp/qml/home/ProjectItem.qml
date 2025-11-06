import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: projectItem
    height: 70
    radius: 8
    color: projectMouseArea.containsMouse ? appTheme.backgroundElevated : "transparent"
    border.color: projectMouseArea.containsMouse ? appTheme.primary + "40" : "transparent"
    border.width: 1

    property string projectName: "Untitled Project"
    property string projectPath: ""
    property string lastModified: ""
    property string thumbnail: ""

    signal clicked()

    Row {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Thumbnail
        Rectangle {
            width: 46
            height: 46
            radius: 6
            color: appTheme.backgroundTertiary

            Image {
                source: projectItem.thumbnail
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                opacity: 0.8
            }

            // Fallback icon
            Text {
                text: "📊"
                font.pixelSize: 16
                anchors.centerIn: parent
                visible: projectItem.thumbnail === ""
            }
        }

        // Project info
        Column {
            width: parent.width - 70
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: projectItem.projectName
                color: appTheme.textPrimary
                font.family: robotoBold.name
                font.pixelSize: 14
                width: parent.width
                elide: Text.ElideRight
            }

            Text {
                text: projectItem.projectPath
                color: appTheme.textTertiary
                font.family: robotoRegular.name
                font.pixelSize: 11
                width: parent.width
                elide: Text.ElideMiddle
            }

            Text {
                text: "Modified: " + projectItem.lastModified
                color: appTheme.textTertiary
                font.family: robotoRegular.name
                font.pixelSize: 10
                width: parent.width
                elide: Text.ElideRight
            }
        }
    }

    // Context menu button
    ToolButton {
        text: "⋯"
        font.pixelSize: 16
        anchors {
            right: parent.right
            rightMargin: 8
            verticalCenter: parent.verticalCenter
        }
        opacity: projectMouseArea.containsMouse ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        onClicked: projectContextMenu.open()

        Menu {
            id: projectContextMenu
            
            MenuItem {
                text: "Open Project"
                onTriggered: projectItem.clicked()
            }
            
            MenuItem {
                text: "Open in File Explorer"
                onTriggered: appController.showInFileExplorer(projectItem.projectPath)
            }
            
            MenuSeparator {}
            
            MenuItem {
                text: "Remove from Recent"
                onTriggered: appController.removeFromRecent(projectItem.projectPath)
            }
        }
    }

    // Mouse area
    MouseArea {
        id: projectMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: projectItem.clicked()
        onDoubleClicked: projectItem.clicked()
    }

    // Hover animation
    Behavior on color {
        ColorAnimation { duration: 200 }
    }
    Behavior on border.color {
        ColorAnimation { duration: 200 }
    }
}