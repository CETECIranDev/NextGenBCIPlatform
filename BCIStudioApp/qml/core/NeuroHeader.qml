import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "../common"

Rectangle {
    id: neuroHeader
    height: 80
    color: "transparent"

    // Properties
    property string currentWorkspace: "home"
    property string currentProject: "No Project"
    property bool isConnected: false
    property int signalQuality: 95 // 0-100
    property real cpuUsage: 25.3 // %

    signal togglePropertiesPanel()
    signal toggleFullScreen()
    signal newProjectRequested()
    signal openProjectRequested()
    signal quickActionTriggered(string action)
    signal recordingToggled(bool recording)  // signal جدید برای ضبط

    // گرادیانت پس‌زمینه حرفه‌ای
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: theme.backgroundSecondary }
            GradientStop { position: 0.5; color: theme.backgroundTertiary }
            GradientStop { position: 1.0; color: theme.backgroundSecondary }
        }
        opacity: 0.9
    }

    // افکت شیشه‌ای
    Rectangle {
        anchors.fill: parent
        color: theme.backgroundGlass
        opacity: appTheme.glassOpacity

        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: neuroHeader.width
                height: neuroHeader.height
                radius: 0
            }
        }
    }

    // خط براق بالایی
    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 1
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.3; color: theme.primary }
            GradientStop { position: 0.7; color: theme.primary }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: 0.6
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 28
        anchors.rightMargin: 28
        spacing: 24

        // Logo and Brand Section - Premium
        Row {
            spacing: 16
            Layout.alignment: Qt.AlignVCenter

            // Animated Logo
            Rectangle {
                width: 44
                height: 44
                radius: theme.radius.lg
                gradient: theme.primaryGradient

                layer.enabled: true
                layer.effect: DropShadow {
                    color: theme.glow
                    radius: 12
                    samples: 25
                    spread: 0.1
                }

                Text {
                    text: "🧠"
                    font.pixelSize: 20
                    anchors.centerIn: parent
                    color: "white"
                }

                // Pulsing Animation
                SequentialAnimation on scale {
                    loops: Animation.Infinite
                    running: true
                    NumberAnimation { from: 1.0; to: 1.05; duration: 2000; easing.type: Easing.InOutSine }
                    NumberAnimation { from: 1.05; to: 1.0; duration: 2000; easing.type: Easing.InOutSine }
                }
            }

            // Brand and Project Info
            Column {
                spacing: 4
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: "NEUROSYNC PRO"
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: theme.typography.h5.size
                    font.weight: Font.DemiBold
                    font.letterSpacing: 1.5
                }

                Row {
                    spacing: 8
                    visible: currentProject !== "No Project"

                    Text {
                        text: currentProject
                        color: theme.primary
                        font.pixelSize: theme.typography.caption.size
                        font.weight: Font.Medium
                        maximumLineCount: 1
                        elide: Text.ElideRight
                    }

                    // Project Status Indicator
                    Rectangle {
                        width: 6
                        height: 6
                        radius: 3
                        color: theme.success
                        anchors.verticalCenter: parent.verticalCenter

                        Glow {
                            anchors.fill: parent
                            source: parent
                            color: theme.success
                            radius: 4
                            samples: 8
                        }
                    }
                }

                Text {
                    text: "ENTERPRISE BCI PLATFORM"
                    color: theme.textTertiary
                    font.pixelSize: theme.typography.overline.size
                    font.letterSpacing: 2
                    visible: currentProject === "No Project"
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Workspace Indicator - Premium
        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            width: workspaceContent.width + 32
            height: 38
            radius: theme.radius.md
            color: theme.backgroundElevated
            border.color: theme.glassBorder
            border.width: 1

            layer.enabled: true
            layer.effect: DropShadow {
                color: theme.shadow
                radius: 8
                samples: 17
                verticalOffset: 2
            }

            Row {
                id: workspaceContent
                anchors.centerIn: parent
                spacing: 12
                padding: 8

                Rectangle {
                    width: 24
                    height: 24
                    radius: theme.radius.sm
                    gradient: theme.primaryGradient
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: getWorkspaceIcon()
                        font.pixelSize: 10
                        color: "white"
                        anchors.centerIn: parent
                    }
                }

                Column {
                    spacing: 1
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: getWorkspaceName().toUpperCase()
                        color: theme.textPrimary
                        font.pixelSize: theme.typography.overline.size
                        font.weight: Font.Bold
                        font.letterSpacing: 1
                    }

                    Text {
                        text: getWorkspaceDescription()
                        color: theme.textTertiary
                        font.pixelSize: theme.typography.caption.size
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }

        // System Status Indicators
        Row {
            spacing: 16
            Layout.alignment: Qt.AlignVCenter
            visible: currentWorkspace !== "home"

            // Connection Status
            StatusIndicator {
                label: "CONNECTION"
                value: isConnected ? "ACTIVE" : "OFFLINE"
                status: isConnected ? "success" : "error"
                icon: isConnected ? "🔗" : "🔌"
            }

            // Signal Quality
            StatusIndicator {
                label: "SIGNAL"
                value: signalQuality + "%"
                status: getSignalStatus()
                icon: "📊"
            }

            // CPU Usage
            StatusIndicator {
                label: "CPU"
                value: cpuUsage.toFixed(1) + "%"
                status: cpuUsage > 80 ? "warning" : "success"
                icon: "⚡"
            }
        }

        Item { Layout.fillWidth: true }

        // Quick Actions - Premium
        Row {
            spacing: 12
            Layout.alignment: Qt.AlignVCenter

            // New Project Button
            GlassButton {
                text: "New Project"
                icon: "✨"
                backgroundColor: theme.primary
                onClicked: neuroHeader.newProjectRequested()
                width: 120
            }

            // Open Project Button
            GlassButton {
                text: "Open"
                icon: "📂"
                backgroundColor: theme.secondary
                onClicked: neuroHeader.openProjectRequested()
                width: 100
            }
        }

        // Control Buttons - Premium
        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            // Record Button
            RecordButton {
                visible: currentWorkspace === "bci" || currentWorkspace === "dashboard"
                onToggled: (recording) => {  // استفاده از signal جدید
                    console.log("Recording:", recording)
                    neuroHeader.recordingToggled(recording)
                }
            }

            // Properties Panel Toggle
            IconButton {
                icon: "⚙️"
                tooltip: "Toggle Properties Panel"
                size: 36
                glowColor: theme.primary
                onClicked: neuroHeader.togglePropertiesPanel()
            }

            // Full Screen Toggle
            IconButton {
                icon: mainWindow.visibility === Window.FullScreen ? "⛶" : "⛶"
                tooltip: mainWindow.visibility === Window.FullScreen ? "Exit Fullscreen" : "Enter Fullscreen"
                size: 36
                glowColor: theme.secondary
                onClicked: neuroHeader.toggleFullScreen()
            }

            // Theme Switcher
            ThemeSwitcher {
                size: 36
                //glowEffect: true
            }
        }

        // User Area - Premium
        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            // Notifications
            IconButton {
                icon: "🔔"
                tooltip: "Notifications"
                showBadge: true
                badgeColor: theme.accent
                badgeCount: 3
                size: 36
                onClicked: console.log("Notifications clicked")
            }

            // User Profile with Avatar
            Rectangle {
                width: 40
                height: 40
                radius: theme.radius.lg
                gradient: Gradient {
                    GradientStop { position: 0.0; color: theme.primary }
                    GradientStop { position: 1.0; color: theme.primaryDark }
                }

                layer.enabled: true
                layer.effect: DropShadow {
                    color: theme.shadow
                    radius: 8
                    samples: 17
                    verticalOffset: 2
                }

                Text {
                    text: "👤"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: showUserMenu()
                }
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

    function getWorkspaceDescription() {
        switch(currentWorkspace) {
            case "home": return "Project Management"
            case "dashboard": return "Real-time Monitoring"
            case "nodeeditor": return "Visual Programming"
            case "bci": return "Experiment Design"
            case "pipeline": return "Data Processing"
            case "analysis": return "Advanced Analytics"
            default: return "Workspace"
        }
    }

    function getSignalStatus() {
        if (signalQuality >= 90) return "success"
        if (signalQuality >= 70) return "warning"
        return "error"
    }

    function showUserMenu() {
        console.log("User menu clicked")
        // Implement user menu
    }

    function setSystemStatus(connected, quality, cpu) {
        isConnected = connected
        signalQuality = quality
        cpuUsage = cpu
    }

    // Public API
    function setCurrentProject(projectName) {
        currentProject = projectName
    }

    function setCurrentWorkspace(workspace) {
        currentWorkspace = workspace
    }

    Component.onCompleted: {
        console.log("🚀 Enterprise NeuroHeader initialized")
    }
}
