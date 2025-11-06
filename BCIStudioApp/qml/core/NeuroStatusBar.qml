import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: statusBar
    height: 35
    color: appTheme.backgroundSecondary
    border.color: appTheme.border
    border.width: 1

    // Properties
    property string currentWorkspace: "home"
    property string currentProject: "No Project"
    property bool hasUnsavedChanges: false
    property string statusMessage: "Ready"
    property color statusColor: appTheme.success
    property string deviceStatus: "NeuroScan"
    property string samplingRate: "1000 Hz"
    property string memoryUsage: "245 MB"
    property int fps: 60
    ThemeManager {
        id: appTheme
        onThemeSwitched: {
            console.log("Theme switched to:", newTheme)
            // انیمیشن تغییر تم برای کل پنجره
            themeTransition.from = newTheme === "light" ? "#0A0A0A" : "#FFFFFF"
            themeTransition.to = theme.backgroundPrimary
            themeTransition.start()
        }
    }
    // Timer for updating dynamic info
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            // Update FPS (simulated)
            fps = Math.floor(Math.random() * 10) + 55
            // Update memory usage (simulated)
            memoryUsage = Math.floor(Math.random() * 50) + 200 + " MB"
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 20

        // Left side - Project and workspace info
        Row {
            spacing: 15

            // Project indicator
            Row {
                spacing: 6
                visible: currentProject !== "No Project"

                Text {
                    text: "📁"
                    font.pixelSize: 12
                }

                Text {
                    text: currentProject
                    color: appTheme.textPrimary
                    font.family: robotoRegular ? robotoRegular.name : "Arial"
                    font.pixelSize: 11
                    font.bold: true
                    elide: Text.ElideMiddle
                    maximumLineCount: 1
                }

                Text {
                    text: "•"
                    color: appTheme.textSecondary
                    font.pixelSize: 11
                }
            }

            // Workspace indicator
            Row {
                spacing: 6

                Text {
                    text: getWorkspaceIcon()
                    font.pixelSize: 12
                }

                Text {
                    text: getWorkspaceName()
                    color: appTheme.textPrimary
                    font.family: robotoRegular ? robotoRegular.name : "Arial"
                    font.pixelSize: 11
                    elide: Text.ElideRight
                }
            }

            // Unsaved changes indicator
            Text {
                text: hasUnsavedChanges ? "●" : ""
                color: hasUnsavedChanges ? appTheme.warning : "transparent"
                font.pixelSize: 14
                visible: hasUnsavedChanges
            }
        }

        Item { Layout.fillWidth: true }

        // Center - Status messages
        Text {
            id: statusText
            text: statusMessage
            color: statusColor
            font.family: robotoRegular ? robotoRegular.name : "Arial"
            font.pixelSize: 11
            font.bold: true

            // Blink animation for important status
            SequentialAnimation on opacity {
                running: statusColor === appTheme.error || statusColor === appTheme.warning
                loops: Animation.Infinite
                NumberAnimation { to: 0.5; duration: 500 }
                NumberAnimation { to: 1.0; duration: 500 }
            }
        }

        Item { Layout.fillWidth: true }

        // Right side - System info
        Row {
            spacing: 12

            // Device status
            Row {
                spacing: 4

                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: deviceStatus !== "Disconnected" ? appTheme.success : appTheme.error
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: deviceStatus
                    color: appTheme.textSecondary
                    font.family: robotoRegular ? robotoRegular.name : "Arial"
                    font.pixelSize: 10
                }
            }

            Text {
                text: "•"
                color: appTheme.textTertiary
                font.pixelSize: 10
            }

            // Sampling rate
            Text {
                text: samplingRate
                color: appTheme.textSecondary
                font.family: robotoRegular ? robotoRegular.name : "Arial"
                font.pixelSize: 10
            }

            Text {
                text: "•"
                color: appTheme.textTertiary
                font.pixelSize: 10
            }

            // Memory usage
            Text {
                text: memoryUsage
                color: getMemoryColor()
                font.family: robotoRegular ? robotoRegular.name : "Arial"
                font.pixelSize: 10
            }

            Text {
                text: "•"
                color: appTheme.textTertiary
                font.pixelSize: 10
            }

            // FPS
            Text {
                text: fps + " FPS"
                color: getFPSColor()
                font.family: robotoRegular ? robotoRegular.name : "Arial"
                font.pixelSize: 10
            }
        }
    }

    // Mouse area for context menu
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: contextMenu.popup()

        Menu {
            id: contextMenu
            MenuItem {
                text: "Copy Status Info"
                onTriggered: copyStatusToClipboard()
            }
            MenuItem {
                text: "Refresh Status"
                onTriggered: refreshStatus()
            }
            MenuSeparator {}
            MenuItem {
                text: "System Information"
                onTriggered: showSystemInfo()
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

    function getMemoryColor() {
        var memoryValue = parseInt(memoryUsage)
        if (memoryValue > 400) return appTheme.error
        if (memoryValue > 300) return appTheme.warning
        return appTheme.textSecondary
    }

    function getFPSColor() {
        if (fps < 30) return appTheme.error
        if (fps < 50) return appTheme.warning
        return appTheme.textSecondary
    }

    function setStatus(message, color) {
        statusMessage = message
        statusColor = color
    }

    function setDeviceStatus(device, connected) {
        deviceStatus = connected ? device : "Disconnected"
    }

    function copyStatusToClipboard() {
        var statusInfo = `Project: ${currentProject}
Workspace: ${getWorkspaceName()}
Status: ${statusMessage}
Device: ${deviceStatus}
Sampling: ${samplingRate}
Memory: ${memoryUsage}
FPS: ${fps}`
        // In a real app, you would use Clipboard API here
        console.log("Status info copied to clipboard:\n" + statusInfo)
    }

    function refreshStatus() {
        // Simulate status refresh
        setStatus("Status refreshed", appTheme.success)
        console.log("Status refreshed")
    }

    function showSystemInfo() {
        console.log("Showing system information...")
        // This would open a system info dialog in a real app
    }

    // Public API functions
    function showSuccess(message) {
        setStatus(message, appTheme.success)
    }

    function showWarning(message) {
        setStatus(message, appTheme.warning)
    }

    function showError(message) {
        setStatus(message, appTheme.error)
    }

    function showInfo(message) {
        setStatus(message, appTheme.info)
    }

    function showLoading(message = "Processing...") {
        setStatus(message, appTheme.primaryColor)
    }

    // Initialize
    Component.onCompleted: {
        console.log("StatusBar initialized")
        // Set initial device status
        setDeviceStatus("NeuroScan", true)
    }
}
