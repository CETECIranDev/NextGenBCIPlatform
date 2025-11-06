import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects  // برای Qt 6
import "../common"

Rectangle {
    id: neuroHeader
    height: 80
    color: "transparent"

    // Properties
    property string currentWorkspace: "home"
    property string currentProject: "No Project"
    signal togglePropertiesPanel()
    signal toggleFullScreen()
    signal newProjectRequested()
    signal openProjectRequested()

    // Background with modern gradient
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: theme.backgroundPrimary }
            GradientStop { position: 1.0; color: theme.backgroundSecondary }
        }
        opacity: 0.95

        // Glass morphism effect
        layer.enabled: true
        layer.effect: Rectangle {
            color: "transparent"
            border.color: theme.borderLight
            border.width: 0.5
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: theme.spacing.xl
        anchors.rightMargin: theme.spacing.xl
        spacing: theme.spacing.lg

        // Logo and Title Section
        Row {
            spacing: theme.spacing.md
            Layout.alignment: Qt.AlignVCenter

            // Modern Logo with gradient
            Rectangle {
                width: 44
                height: 44
                radius: theme.radius.lg
                gradient: theme.primaryGradient

                // Shine effect
                Rectangle {
                    width: parent.width * 0.4
                    height: parent.height * 0.15
                    radius: 2
                    color: Qt.rgba(1, 1, 1, 0.4)
                    rotation: -45
                    x: parent.width * 0.3
                    y: parent.height * 0.15
                }

                Text {
                    text: "🧠"
                    font.pixelSize: 20
                    anchors.centerIn: parent
                    color: theme.textInverted
                }

                // Subtle shadow
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 2
                    radius: 8
                    samples: 16
                    color: "#40000000"
                }
            }

            // Title and Project Info
            Column {
                spacing: theme.spacing.xs
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: "BCI STUDIO PRO"
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: theme.typography.h5.size
                    font.letterSpacing: theme.typography.h5.letterSpacing
                }

                Text {
                    text: currentProject !== "No Project" ?
                          currentProject : "Advanced Brain-Computer Interface Platform"
                    color: currentProject !== "No Project" ? theme.primary : theme.textSecondary
                    font.pixelSize: theme.typography.caption.size
                    font.letterSpacing: theme.typography.caption.letterSpacing
                    opacity: 0.9
                    elide: Text.ElideRight
                    maximumLineCount: 1
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Workspace Indicator - Modern Design
        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            width: workspaceContent.width + theme.spacing.lg
            height: 36
            radius: theme.radius.round
            color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.15)
            border.color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.3)
            border.width: 1

            Row {
                id: workspaceContent
                anchors.centerIn: parent
                spacing: theme.spacing.sm

                Text {
                    text: getWorkspaceIcon()
                    font.pixelSize: 14
                    color: theme.primary
                }

                Text {
                    text: getWorkspaceName()
                    color: theme.textPrimary
                    font.pixelSize: theme.typography.caption.size
                    font.bold: true
                    font.letterSpacing: theme.typography.caption.letterSpacing
                }
            }

            // Subtle shadow
            layer.enabled: true
            layer.effect: DropShadow {
                transparentBorder: true
                horizontalOffset: 0
                verticalOffset: 1
                radius: 4
                samples: 8
                color: "#20000000"
            }
        }

        Item { Layout.fillWidth: true }

        // Quick Actions - Modern Buttons
        Row {
            spacing: theme.spacing.sm
            Layout.alignment: Qt.AlignVCenter

            // New Project Button
            MaterialButton {
                text: "➕"
                tooltip: "New Project"
                buttonColor: theme.primary
                highlighted: true
                onClicked: neuroHeader.newProjectRequested()

                Text {
                    anchors.centerIn: parent
                    text: "New"
                    color: theme.textInverted
                    font.pixelSize: theme.typography.caption.size
                    font.bold: true
                }
            }

            // Open Project Button
            MaterialButton {
                text: "📂"
                tooltip: "Open Project"
                onClicked: neuroHeader.openProjectRequested()

                Text {
                    anchors.centerIn: parent
                    text: "Open"
                    color: theme.textPrimary
                    font.pixelSize: theme.typography.caption.size
                    font.bold: true
                }
            }
        }

        // Control Buttons - Compact Design
        Row {
            spacing: theme.spacing.xs
            Layout.alignment: Qt.AlignVCenter

            // Properties Panel Toggle
            MaterialButton {
                text: "⚙️"
                tooltip: "Toggle Properties Panel"
                onClicked: neuroHeader.togglePropertiesPanel()
            }

            // Full Screen Toggle
            MaterialButton {
                text: "⛶"
                tooltip: "Toggle Full Screen"
                onClicked: neuroHeader.toggleFullScreen()
            }
        }

        // User Area - Modern Icons
        Row {
            spacing: theme.spacing.sm
            Layout.alignment: Qt.AlignVCenter

            // Notifications with modern badge
            Rectangle {
                width: 40
                height: 40
                radius: theme.radius.round
                color: "transparent"
                border.color: theme.borderLight
                border.width: 1

                Text {
                    text: "🔔"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                // Modern notification badge
                Rectangle {
                    x: 24
                    y: 8
                    width: 12
                    height: 12
                    radius: 6
                    color: theme.accent
                    border.color: theme.backgroundSecondary
                    border.width: 2

                    // Pulse animation
                    SequentialAnimation on scale {
                        running: true
                        loops: Animation.Infinite
                        NumberAnimation {
                            to: 1.3;
                            duration: theme.animation.slow;
                            easing.type: Easing.InOutQuad
                        }
                        NumberAnimation {
                            to: 1.0;
                            duration: theme.animation.slow;
                            easing.type: Easing.InOutQuad
                        }
                    }

                    // Inner dot for better visibility
                    Rectangle {
                        anchors.centerIn: parent
                        width: 4
                        height: 4
                        radius: 2
                        color: theme.textInverted
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log("Notifications clicked")
                }
            }

            // User Profile with gradient
            Rectangle {
                width: 40
                height: 40
                radius: theme.radius.round
                gradient: Gradient {
                    GradientStop { position: 0.0; color: theme.secondary }
                    GradientStop { position: 1.0; color: theme.secondaryDark }
                }

                Text {
                    text: "👤"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                    color: theme.textInverted
                }

                // Subtle shadow
                layer.enabled: true
                layer.effect: DropShadow {
                    transparentBorder: true
                    horizontalOffset: 0
                    verticalOffset: 2
                    radius: 6
                    samples: 12
                    color: "#40000000"
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: console.log("User menu clicked")
                }
            }
        }
    }

    // Modern bottom border with gradient
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.3; color: theme.borderLight }
            GradientStop { position: 0.7; color: theme.borderLight }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.5
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

    function showNotification(count) {
        console.log("Show notification count:", count)
        // In a real implementation, this would update the notification badge
    }

    // Initialize
    Component.onCompleted: {
        console.log("NeuroHeader initialized with modern dark blue theme")
    }
}
