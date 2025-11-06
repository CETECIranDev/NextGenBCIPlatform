import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: appWindow
    color: appTheme.backgroundPrimary

    property string currentWorkspace: "dashboard"
    signal workspaceChangeRequested(string workspaceId)

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        NavigationSidebar {
            id: navSidebar
            width: 80
            currentWorkspace: appWindow.currentWorkspace
            onWorkspaceSelected: appWindow.workspaceChangeRequested(workspaceId)
        }

        ColumnLayout {
            spacing: 0
            SplitView.fillWidth: true

            WorkspaceHeader {
                id: workspaceHeader
                Layout.fillWidth: true
                height: 60
                currentWorkspace: appWindow.currentWorkspace
            }

            Loader {
                id: workspaceLoader
                Layout.fillWidth: true
                Layout.fillHeight: true
                source: {
                    switch(appWindow.currentWorkspace) {
                        case "dashboard": return "DashboardView.qml"
                        case "nodeeditor": return "NodeEditorView.qml"
                        case "pipeline": return "PipelineExecutorView.qml"
                        case "bci": return "BCIParadigmManager.qml"
                        default: return "DashboardView.qml"
                    }
                }
            }
        }

        PropertiesPanel {
            id: propertiesPanel
            width: 350
            visible: true
        }
    }

    StatusBar {
        Layout.fillWidth: true
        height: 30
    }
}