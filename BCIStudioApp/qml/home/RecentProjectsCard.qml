import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import "../core"

Rectangle {
    id: recentProjectsCard
    height: recentProjects.count > 0 ? 320 : 200
    radius: 16
    color: appTheme.backgroundCard
    border.color: appTheme.border
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Header with actions
        RowLayout {
            Layout.fillWidth: true

            Text {
                text: "Recent Projects"
                color: appTheme.textPrimary
                font.family: robotoBold.name
                font.pixelSize: 20
                Layout.fillWidth: true
            }

            NeuroButton {
                text: "Show All"
                type: "secondary"
                size: "small"
                onClicked: appController.showAllProjects()
            }
        }

        // Projects list or empty state
        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: recentProjects.count > 0 ? projectsListComponent : emptyStateComponent
        }
    }

    // Projects list component
    Component {
        id: projectsListComponent
        
        ScrollView {
            clip: true
            
            Column {
                width: parent.width
                spacing: 10

                Repeater {
                    model: recentProjects

                    delegate: ProjectItem {
                        width: parent.width
                        projectName: model.name
                        projectPath: model.path
                        lastModified: model.lastModified
                        thumbnail: model.thumbnail
                        onClicked: appController.openProject(model.path)
                    }
                }
            }
        }
    }

    // Empty state component
    Component {
        id: emptyStateComponent
        
        Column {
            width: parent.width
            spacing: 20
            anchors.verticalCenter: parent.verticalCenter

            // Illustration
            Rectangle {
                width: 80
                height: 80
                radius: 40
                color: appTheme.backgroundTertiary
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: "📁"
                    font.pixelSize: 32
                    anchors.centerIn: parent
                }
            }

            // Text
            Column {
                width: parent.width
                spacing: 8

                Text {
                    text: "No Recent Projects"
                    color: appTheme.textPrimary
                    font.family: robotoBold.name
                    font.pixelSize: 18
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Create a new project or open an existing one to get started"
                    color: appTheme.textSecondary
                    font.family: robotoRegular.name
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width * 0.8
                    wrapMode: Text.WordWrap
                }
            }

            // Action button
            NeuroButton {
                text: "Create New Project"
                type: "primary"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: newProjectDialog.open()
            }
        }
    }
}
