import QtQuick
import QtQuick.Controls

Rectangle {
    id: neuroSidebar
    width: collapsed ? 50 : 280
    color: theme.backgroundSecondary
    clip: true

    property string currentWorkspace: "home"
    property bool collapsed: false
    signal workspaceSelected(string workspaceId)

    Behavior on width {
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }

    Column {
        anchors.fill: parent
        spacing: 0

        // هدر - وقتی جمع میشه کوچیک میشه
        Rectangle {
            width: parent.width
            height: collapsed ? 50 : 60
            color: "transparent"

            Row {
                anchors.centerIn: parent
                spacing: collapsed ? 0 : 10

                // لوگو - کوچیکتر در حالت جمع شده
                Rectangle {
                    width: collapsed ? 30 : 36
                    height: collapsed ? 30 : 36
                    radius: 6
                    color: theme.primaryColor
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: "🧠"
                        font.pixelSize: collapsed ? 12 : 16
                        anchors.centerIn: parent
                    }
                }

                // عنوان - فقط وقتی بازه
                Text {
                    text: "BCI Studio"
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 14
                    anchors.verticalCenter: parent.verticalcenter
                    visible: !collapsed
                }
            }

            // دکمه ساندویچ - موقعیت ثابت
            Button {
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                width: 30
                height: 30
                background: Rectangle {
                    color: "transparent"
                    radius: 5
                }
                text: collapsed ? "☰" : "✕"
                font.pixelSize: 12
                onClicked: collapsed = !collapsed
            }
        }

        // آیتم‌های منو - عرضشون رو محدود میکنیم
        Column {
            width: parent.width
            spacing: 2

            SidebarButton {
                width: parent.width
                icon: "🏠"
                text: "Home"
                collapsed: neuroSidebar.collapsed
                selected: currentWorkspace === "home"
                onClicked: workspaceSelected("home")
            }

            SidebarButton {
                width: parent.width
                icon: "🧩"
                text: "Node Editor"
                collapsed: neuroSidebar.collapsed
                selected: currentWorkspace === "nodeeditor"
                badge: 3
                onClicked: workspaceSelected("nodeeditor")
            }

            SidebarButton {
                width: parent.width
                icon: "📊"
                text: "Dashboard"
                collapsed: neuroSidebar.collapsed
                selected: currentWorkspace === "dashboard"
                onClicked: workspaceSelected("dashboard")
            }

            SidebarButton {
                width: parent.width
                icon: "🧠"
                text: "BCI Paradigms"
                collapsed: neuroSidebar.collapsed
                selected: currentWorkspace === "bci"
                onClicked: workspaceSelected("bci")
            }

            // جداکننده
            Rectangle {
                width: parent.width - 10
                height: 1
                color: theme.border
                opacity: 0.3
                anchors.horizontalCenter: parent.horizontalCenter
                visible: !collapsed
            }

            SidebarButton {
                width: parent.width
                icon: "📁"
                text: "Data Manager"
                collapsed: neuroSidebar.collapsed
                selected: currentWorkspace === "datamanager"
                onClicked: workspaceSelected("datamanager")
            }

            SidebarButton {
                width: parent.width
                icon: "📈"
                text: "Visualization"
                collapsed: neuroSidebar.collapsed
                selected: currentWorkspace === "visualization"
                onClicked: workspaceSelected("visualization")
            }

            SidebarButton {
                width: parent.width
                icon: "🤖"
                text: "AI Models"
                collapsed: neuroSidebar.collapsed
                selected: currentWorkspace === "modelmanager"
                badge: 2
                onClicked: workspaceSelected("modelmanager")
            }

            // جداکننده
            Rectangle {
                width: parent.width - 10
                height: 1
                color: theme.border
                opacity: 0.3
                anchors.horizontalCenter: parent.horizontalCenter
                visible: !collapsed
            }

            SidebarButton {
                width: parent.width
                icon: "⭐"
                text: "New Project"
                collapsed: neuroSidebar.collapsed
                onClicked: workspaceSelected("new_project")
            }

            SidebarButton {
                width: parent.width
                icon: "📂"
                text: "Open Project"
                collapsed: neuroSidebar.collapsed
                onClicked: workspaceSelected("open_project")
            }

            SidebarButton {
                width: parent.width
                icon: "⚙️"
                text: "Settings"
                collapsed: neuroSidebar.collapsed
                onClicked: workspaceSelected("settings")
            }
        }

        // فضای خالی
        Item { height: 10; width: 1 }

        // وضعیت سیستم - کوچیک در حالت جمع شده
        Rectangle {
            width: parent.width
            height: collapsed ? 30 : 40
            color: Qt.darker(theme.backgroundSecondary, 1.1)

            Row {
                anchors.centerIn: parent
                spacing: collapsed ? 5 : 8

                // نشانگر وضعیت
                Rectangle {
                    width: collapsed ? 6 : 8
                    height: collapsed ? 6 : 8
                    radius: collapsed ? 3 : 4
                    color: "#00FF00"
                    anchors.verticalCenter: parent.verticalCenter
                }

                // متن وضعیت
                Column {
                    spacing: 1
                    visible: !collapsed
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: "System Online"
                        color: theme.textPrimary
                        font.pixelSize: 9
                        font.bold: true
                    }

                    Text {
                        text: "v1.0.0"
                        color: theme.textSecondary
                        font.pixelSize: 8
                    }
                }

                // آیکون وضعیت برای حالت جمع شده
                Text {
                    text: "●"
                    font.pixelSize: 8
                    color: "#00FF00"
                    visible: collapsed
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    // Border سمت راست
    Rectangle {
        anchors.right: parent.right
        width: 1
        height: parent.height
        color: theme.border
        opacity: 0.3
    }
}
