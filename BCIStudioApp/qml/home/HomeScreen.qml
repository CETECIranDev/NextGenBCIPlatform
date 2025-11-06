import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: homeScreen
    color: "transparent"

    // Properties
    property ListModel recentProjects
    property ListModel quickActions
    signal actionTriggered(string action)
    signal projectSelected(string projectPath)
    signal projectRemoved(string projectPath)

    ScrollView {
        anchors.fill: parent
        anchors.margins: 24
        clip: true

        Column {
            width: parent.width
            spacing: 32

            // Welcome Section
            Rectangle {
                width: parent.width
                height: 160
                radius: 16
                color: theme.backgroundCard
                border.color: theme.border
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 24

                    // Welcome Text
                    Column {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 12

                        Text {
                            text: "🧠 Welcome to BCI Studio Pro"
                            color: theme.textPrimary
                            font.family: "Segoe UI"
                            font.pixelSize: 24
                            font.bold: true
                        }

                        Text {
                            text: "Advanced platform for EEG signal processing, real-time BCI experiments, and brain-computer interface development."
                            color: theme.textSecondary
                            font.family: "Segoe UI"
                            font.pixelSize: 14
                            wrapMode: Text.Wrap
                            width: parent.width
                            lineHeight: 1.4
                        }

                        Row {
                            spacing: 12
                            topPadding: 16

                            // Primary Button
                            Rectangle {
                                width: 120
                                height: 40
                                radius: 8
                                color: theme.primary

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: homeScreen.actionTriggered("get_started")

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: parent.radius
                                        color: "white"
                                        opacity: parent.pressed ? 0.2 : parent.containsMouse ? 0.1 : 0
                                        Behavior on opacity { NumberAnimation { duration: 150 } }
                                    }
                                }

                                Row {
                                    anchors.centerIn: parent
                                    spacing: 6

                                    Text {
                                        text: "🚀"
                                        font.pixelSize: 14
                                        font.family: "Segoe UI"
                                    }

                                    Text {
                                        text: "Get Started"
                                        color: "white"
                                        font.family: "Segoe UI"
                                        font.pixelSize: 13
                                        font.bold: true
                                    }
                                }
                            }

                            // Secondary Button
                            Rectangle {
                                width: 100
                                height: 40
                                radius: 8
                                color: "transparent"
                                border.color: theme.border
                                border.width: 1

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: homeScreen.actionTriggered("tutorials")

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: parent.radius
                                        color: theme.primary
                                        opacity: parent.pressed ? 0.1 : parent.containsMouse ? 0.05 : 0
                                        Behavior on opacity { NumberAnimation { duration: 150 } }
                                    }
                                }

                                Row {
                                    anchors.centerIn: parent
                                    spacing: 6

                                    Text {
                                        text: "📚"
                                        font.pixelSize: 14
                                        font.family: "Segoe UI"
                                    }

                                    Text {
                                        text: "Tutorials"
                                        color: theme.textPrimary
                                        font.family: "Segoe UI"
                                        font.pixelSize: 13
                                    }
                                }
                            }
                        }
                    }

                    // Stats Card
                    Rectangle {
                        Layout.preferredWidth: 140
                        Layout.fillHeight: true
                        radius: 12
                        color: theme.primary
                        opacity: 0.9

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                text: "⚡"
                                font.pixelSize: 20
                                font.family: "Segoe UI"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "Ready"
                                color: "white"
                                font.family: "Segoe UI"
                                font.pixelSize: 16
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "System Online"
                                color: "white"
                                opacity: 0.8
                                font.family: "Segoe UI"
                                font.pixelSize: 11
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }

            // Quick Actions Grid
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "Quick Actions"
                    color: theme.textPrimary
                    font.family: "Segoe UI"
                    font.pixelSize: 20
                    font.bold: true
                }

                Grid {
                    width: parent.width
                    columns: 4
                    spacing: 16

                    Repeater {
                        model: homeScreen.quickActions

                        delegate: Rectangle {
                            width: (parent.width - parent.spacing * (parent.columns - 1)) / parent.columns
                            height: 120
                            radius: 12
                            color: theme.backgroundCard
                            border.color: theme.border
                            border.width: 1

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: homeScreen.actionTriggered(action)

                                Rectangle {
                                    anchors.fill: parent
                                    radius: parent.radius
                                    color: theme.primary
                                    opacity: parent.pressed ? 0.1 : parent.containsMouse ? 0.05 : 0
                                    Behavior on opacity { NumberAnimation { duration: 200 } }
                                }
                            }

                            Column {
                                anchors.centerIn: parent
                                spacing: 12
                                width: parent.width - 24

                                Rectangle {
                                    width: 48
                                    height: 48
                                    radius: 12
                                    color: model.color
                                    anchors.horizontalCenter: parent.horizontalCenter

                                    Text {
                                        text: model.icon
                                        font.pixelSize: 20
                                        font.family: "Segoe UI"
                                        anchors.centerIn: parent
                                    }
                                }

                                Column {
                                    spacing: 6
                                    width: parent.width

                                    Text {
                                        text: model.title
                                        color: theme.textPrimary
                                        font.family: "Segoe UI"
                                        font.pixelSize: 14
                                        font.bold: true
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        elide: Text.ElideRight
                                        maximumLineCount: 1
                                        width: parent.width
                                    }

                                    Text {
                                        text: model.description
                                        color: theme.textSecondary
                                        font.family: "Segoe UI"
                                        font.pixelSize: 11
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        wrapMode: Text.Wrap
                                        maximumLineCount: 2
                                        elide: Text.ElideRight
                                        width: parent.width
                                        lineHeight: 1.3
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // Recent Projects Section
            Column {
                width: parent.width
                spacing: 20

                Row {
                    width: parent.width
                    spacing: 16

                    Text {
                        text: "Recent Projects"
                        color: theme.textPrimary
                        font.family: "Segoe UI"
                        font.pixelSize: 20
                        font.bold: true
                    }

                    Item { Layout.fillWidth: true }

                    // Show All Link
                    Rectangle {
                        width: showAllText.width + 12
                        height: showAllText.height + 8
                        radius: 6
                        color: "transparent"

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: homeScreen.actionTriggered("show_all_projects")

                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: theme.primary
                                opacity: parent.pressed ? 0.1 : parent.containsMouse ? 0.05 : 0
                            }
                        }

                        Text {
                            id: showAllText
                            text: "Show All"
                            color: theme.primary
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            font.bold: true
                            anchors.centerIn: parent
                        }
                    }
                }

                Column {
                    width: parent.width
                    spacing: 8

                    Repeater {
                        model: homeScreen.recentProjects

                        delegate: Rectangle {
                            width: parent.width
                            height: 72
                            radius: 12
                            color: theme.backgroundCard
                            border.color: theme.border
                            border.width: 1

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: homeScreen.projectSelected(path)

                                Rectangle {
                                    anchors.fill: parent
                                    radius: parent.radius
                                    color: theme.primary
                                    opacity: parent.pressed ? 0.1 : parent.containsMouse ? 0.05 : 0
                                    Behavior on opacity { NumberAnimation { duration: 200 } }
                                }
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 16
                                spacing: 16

                                // Project Icon
                                Rectangle {
                                    width: 40
                                    height: 40
                                    radius: 8
                                    color: theme.primary
                                    opacity: 0.1
                                    Layout.alignment: Qt.AlignVCenter

                                    Text {
                                        text: "📁"
                                        font.pixelSize: 16
                                        font.family: "Segoe UI"
                                        anchors.centerIn: parent
                                    }
                                }

                                // Project Info
                                Column {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    spacing: 4

                                    Text {
                                        text: name
                                        color: theme.textPrimary
                                        font.family: "Segoe UI"
                                        font.pixelSize: 14
                                        font.bold: true
                                        elide: Text.ElideRight
                                        width: parent.width
                                    }

                                    Text {
                                        text: "Modified: " + lastModified
                                        color: theme.textSecondary
                                        font.family: "Segoe UI"
                                        font.pixelSize: 11
                                    }

                                    Text {
                                        text: path
                                        color: theme.textTertiary
                                        font.family: "Segoe UI"
                                        font.pixelSize: 10
                                        elide: Text.ElideMiddle
                                        width: parent.width
                                    }
                                }

                                // Action Buttons
                                Row {
                                    spacing: 4
                                    Layout.alignment: Qt.AlignVCenter

                                    // Open in Folder
                                    Rectangle {
                                        width: 32
                                        height: 32
                                        radius: 6
                                        color: "transparent"

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: homeScreen.actionTriggered("show_in_folder")

                                            Rectangle {
                                                anchors.fill: parent
                                                radius: parent.radius
                                                color: theme.primary
                                                opacity: parent.pressed ? 0.2 : parent.containsMouse ? 0.1 : 0
                                            }
                                        }

                                        Text {
                                            text: "📂"
                                            font.pixelSize: 12
                                            font.family: "Segoe UI"
                                            anchors.centerIn: parent
                                        }
                                    }

                                    // Delete
                                    Rectangle {
                                        width: 32
                                        height: 32
                                        radius: 6
                                        color: "transparent"

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: homeScreen.projectRemoved(path)

                                            Rectangle {
                                                anchors.fill: parent
                                                radius: parent.radius
                                                color: theme.error
                                                opacity: parent.pressed ? 0.2 : parent.containsMouse ? 0.1 : 0
                                            }
                                        }

                                        Text {
                                            text: "🗑️"
                                            font.pixelSize: 12
                                            font.family: "Segoe UI"
                                            anchors.centerIn: parent
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Empty State
                    Rectangle {
                        width: parent.width
                        height: 100
                        radius: 12
                        color: theme.backgroundCard
                        border.color: theme.border
                        border.width: 1
                        visible: homeScreen.recentProjects.count === 0

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                text: "📁"
                                font.pixelSize: 24
                                font.family: "Segoe UI"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "No recent projects"
                                color: theme.textSecondary
                                font.family: "Segoe UI"
                                font.pixelSize: 14
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "Create your first project to get started"
                                color: theme.textTertiary
                                font.family: "Segoe UI"
                                font.pixelSize: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }
                    }
                }
            }

            // System Status Grid
            Column {
                width: parent.width
                spacing: 20

                Text {
                    text: "System Status"
                    color: theme.textPrimary
                    font.family: "Segoe UI"
                    font.pixelSize: 20
                    font.bold: true
                }

                Grid {
                    width: parent.width
                    columns: 3
                    spacing: 16

                    StatusItem {
                        icon: "🧠"
                        title: "BCI Engine"
                        status: "Running"
                        statusColor: theme.success
                        value: "v2.1.4"
                    }

                    StatusItem {
                        icon: "📊"
                        title: "Signal Processing"
                        status: "Ready"
                        statusColor: theme.success
                        value: "64 channels"
                    }

                    StatusItem {
                        icon: "🤖"
                        title: "ML Models"
                        status: "Loaded"
                        statusColor: theme.success
                        value: "3 models"
                    }
                }
            }
        }
    }

    // Modern Status Item Component
    component StatusItem: Rectangle {
        property string icon: "⚙️"
        property string title: "Title"
        property string status: "Status"
        property color statusColor: theme.textSecondary
        property string value: "Value"

        width: (parent.width - parent.spacing * (parent.columns - 1)) / parent.columns
        height: 100
        radius: 12
        color: theme.backgroundCard
        border.color: theme.border
        border.width: 1

        Column {
            anchors.centerIn: parent
            spacing: 8
            width: parent.width - 24

            Text {
                text: parent.parent.icon
                font.pixelSize: 20
                font.family: "Segoe UI"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                text: parent.parent.title
                color: theme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 14
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                elide: Text.ElideRight
                width: parent.width
            }

            Row {
                spacing: 6
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: parent.parent.statusColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: parent.parent.status
                    color: parent.parent.statusColor
                    font.family: "Segoe UI"
                    font.pixelSize: 11
                    font.bold: true
                }
            }

            Text {
                text: parent.parent.value
                color: theme.textSecondary
                font.family: "Segoe UI"
                font.pixelSize: 11
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Component.onCompleted: {
        console.log("HomeScreen initialized with standard fonts")
    }
}
