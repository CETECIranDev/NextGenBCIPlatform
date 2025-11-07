import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "../common"

Rectangle {
    id: neuroHeader
    height: 70
    color: theme.backgroundSecondary
    border.color: theme.border
    border.width: 1

    // Properties
    property string currentWorkspace: "home"
    property string currentProject: "No Project"
    signal togglePropertiesPanel()
    signal toggleFullScreen()
    signal newProjectRequested()
    signal openProjectRequested()

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 24
        anchors.rightMargin: 24
        spacing: 20

        // Logo and Title Section
        Row {
            spacing: 12
            Layout.alignment: Qt.AlignVCenter

            // Simple Logo
            Rectangle {
                width: 36
                height: 36
                radius: 8
                color: theme.primary

                Text {
                    text: "🧠"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                    color: "white"
                }
            }

            // Title and Project Info
            Column {
                spacing: 2
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: "BCI STUDIO PRO"
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 16
                }

                Text {
                    text: currentProject !== "No Project" ?
                          currentProject : "Enterprise BCI Platform"
                    color: currentProject !== "No Project" ? theme.primary : theme.textSecondary
                    font.pixelSize: 11
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Workspace Indicator
        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            width: workspaceContent.width + 20
            height: 32
            radius: 6
            color: theme.backgroundTertiary
            border.color: theme.border
            border.width: 1

            Row {
                id: workspaceContent
                anchors.centerIn: parent
                spacing: 8

                Text {
                    text: getWorkspaceIcon()
                    font.pixelSize: 12
                    color: theme.primary
                }

                Text {
                    text: getWorkspaceName()
                    color: theme.textPrimary
                    font.pixelSize: 11
                    font.bold: true
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Quick Actions
        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            // New Project Button
            FlatButton {
                text: "➕ New"
                backgroundColor: theme.primary
                textColor: "white"
                onClicked: neuroHeader.newProjectRequested()
            }

            // Open Project Button
            FlatButton {
                text: "📂 Open"
                backgroundColor: theme.backgroundTertiary
                textColor: theme.textPrimary
                onClicked: neuroHeader.openProjectRequested()
            }
        }

        // Control Buttons
        Row {
            spacing: 6
            Layout.alignment: Qt.AlignVCenter

            // Properties Panel Toggle
            IconButton {
                icon: "⚙️"
                tooltip: "Toggle Properties Panel"
                onClicked: neuroHeader.togglePropertiesPanel()
            }

            // Full Screen Toggle
            IconButton {
                icon: mainWindow.visibility === Window.FullScreen ? "⛶" : "⛶"
                tooltip: mainWindow.visibility === Window.FullScreen ? "Exit Fullscreen" : "Enter Fullscreen"
                onClicked: neuroHeader.toggleFullScreen()
            }

            // Theme Switcher
            ThemeSwitcher {
                size: 32
            }
        }

        // User Area
        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            // Notifications
            IconButton {
                icon: "🔔"
                tooltip: "Notifications"
                showBadge: true
                badgeColor: theme.accent
                onClicked: console.log("Notifications clicked")
            }

            // User Profile
            IconButton {
                icon: "👤"
                tooltip: "User Menu"
                onClicked: console.log("User menu clicked")
            }
        }
    }

    // Functions
    function getWorkspaceIcon() {
        switch(currentWorkspace) {
            case "home": return "🏠"
            case "dashboard": return "📊"
            case "nodeeditor": return "🧩"
            case "bci": return "🧠"
            case "pipeline": return "⚡"
            case "analysis": return "📈"
            default: return "⚙️"
        }
    }

    function getWorkspaceName() {
        switch(currentWorkspace) {
            case "home": return "Home"
            case "dashboard": return "Dashboard"
            case "nodeeditor": return "Node Editor"
            case "bci": return "BCI Paradigms"
            case "pipeline": return "Pipeline"
            case "analysis": return "Data Analysis"
            default: return currentWorkspace
        }
    }

    // Public API
    function setCurrentProject(projectName) {
        currentProject = projectName
    }

    function setCurrentWorkspace(workspace) {
        currentWorkspace = workspace
    }

    Component.onCompleted: {
        console.log("NeuroHeader initialized with enterprise design")
    }
}
