import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    id: navSidebar
    width: 80
    color: appTheme.colors.background.secondary
    border.color: appTheme.colors.border

    property string currentWorkspace: "dashboard"
    signal workspaceSelected(string workspaceId)

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Logo
        Image {
            source: "qrc:/resources/icons/logo.png"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            Layout.preferredWidth: 40
            Layout.preferredHeight: 40
        }

        Item { Layout.fillHeight: true }

        // Main Navigation
        Repeater {
            model: [
                { id: "dashboard", icon: "📊", label: "Dashboard", color: "#00E5FF" },
                { id: "nodeeditor", icon: "🧩", label: "Node Editor", color: "#7C4DFF" },
                { id: "pipeline", icon: "⚡", label: "Pipeline", color: "#FF4081" },
                { id: "bci", icon: "🧠", label: "BCI Paradigms", color: "#FFD600" },
                { id: "analysis", icon: "📈", label: "Analysis", color: "#00E676" }
            ]

            delegate: NavigationButton {
                icon: modelData.icon
                label: modelData.label
                color: modelData.color
                isActive: navSidebar.currentWorkspace === modelData.id
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 15

                onClicked: navSidebar.workspaceSelected(modelData.id)
            }
        }

        Item { Layout.fillHeight: true }

        // System Buttons
        NavigationButton {
            icon: "⚙️"
            label: "Settings"
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 10
            onClicked: settingsDialog.open()
        }

        NavigationButton {
            icon: "👤"
            label: "Profile"
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 20
            onClicked: userMenu.open()
        }
    }
}
