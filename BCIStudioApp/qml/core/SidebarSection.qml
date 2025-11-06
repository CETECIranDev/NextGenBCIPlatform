import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    id: sidebarSection

    property string title: ""
    property ListModel model: null
    property string currentWorkspace: ""
    signal itemClicked(string workspaceId)

    width: parent.width
    implicitHeight: sectionColumn.height
    color: "transparent"

    ColumnLayout {
        id: sectionColumn
        width: parent.width
        spacing: 0

        // Section header
        Text {
            text: sidebarSection.title
            color: appTheme.textTertiary
            font.family: robotoBold ? robotoBold.name : "Arial"
            font.pixelSize: 10
            font.bold: true
            font.capitalization: Font.AllUppercase
            Layout.topMargin: 15
            Layout.leftMargin: 20
            Layout.bottomMargin: 8
            opacity: 0.7
        }

        // Items
        Repeater {
            model: sidebarSection.model

            delegate: Rectangle {
                width: parent.width
                height: 50
                color: getItemColor()

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (isEnabled) {
                            sidebarSection.itemClicked(workspaceId)
                        }
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 15
                    anchors.rightMargin: 10
                    spacing: 12

                    // Icon
                    Rectangle {
                        width: 32
                        height: 32
                        radius: 8
                        color: getIconColor()
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            text: icon
                            font.pixelSize: 14
                            anchors.centerIn: parent
                        }

                        // Badge
                        Rectangle {
                            x: 20
                            y: -2
                            width: 16
                            height: 16
                            radius: 8
                            color: appTheme.accent ? appTheme.accent : "#FF4081"
                            visible: badgeCount > 0

                            Text {
                                text: badgeCount > 9 ? "9+" : badgeCount
                                color: "white"
                                font.family: robotoBold ? robotoBold.name : "Arial"
                                font.pixelSize: 8
                                font.bold: true
                                anchors.centerIn: parent
                            }
                        }
                    }

                    // Text content
                    Column {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                        spacing: 2

                        Text {
                            text: title
                            color: getTextColor()
                            font.family: robotoRegular ? robotoRegular.name : "Arial"
                            font.pixelSize: 13
                            font.bold: currentWorkspace === workspaceId
                            elide: Text.ElideRight
                        }

                        Text {
                            text: description
                            color: appTheme.textSecondary
                            font.family: robotoRegular ? robotoRegular.name : "Arial"
                            font.pixelSize: 10
                            opacity: isEnabled ? 0.7 : 0.4
                            elide: Text.ElideRight
                        }
                    }

                    // Active indicator
                    Rectangle {
                        width: 3
                        height: 20
                        radius: 2
                        color: appTheme.primaryColor
                        visible: currentWorkspace === workspaceId
                        Layout.alignment: Qt.AlignVCenter
                    }
                }

                // Disabled overlay
                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(0.1, 0.1, 0.1, 0.5)
                    visible: !isEnabled

                    Text {
                        text: "🔒"
                        font.pixelSize: 10
                        anchors.centerIn: parent
                        opacity: 0.5
                    }
                }

                // Hover effect
                Rectangle {
                    anchors.fill: parent
                    color: Qt.rgba(1, 1, 1, 0.05)
                    visible: parent.parent.MouseArea.containsMouse && isEnabled
                }

                // Bottom separator
                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width - 30
                    height: 1
                    color: appTheme.border
                    opacity: 0.2
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: index < sidebarSection.model.count - 1
                }

                // Helper functions
                function getItemColor() {
                    if (!isEnabled) return "transparent"
                    if (currentWorkspace === workspaceId) {
                        return Qt.rgba(appTheme.primaryColor.r, appTheme.primaryColor.g, appTheme.primaryColor.b, 0.1)
                    }
                    return "transparent"
                }

                function getIconColor() {
                    if (!isEnabled) return Qt.darker(appTheme.backgroundCard, 1.3)
                    if (currentWorkspace === workspaceId) return appTheme.primaryColor
                    return Qt.darker(appTheme.backgroundCard, 1.1)
                }

                function getTextColor() {
                    if (!isEnabled) return appTheme.textTertiary
                    if (currentWorkspace === workspaceId) return appTheme.primaryColor
                    return appTheme.textPrimary
                }
            }
        }
    }
}
