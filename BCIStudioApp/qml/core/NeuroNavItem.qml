import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: navItem
    height: 50
    color: "transparent"

    property string icon: "❓"
    property string title: "Item"
    property int badgeCount: 0
    property bool isActive: false
    property bool isCollapsed: false

    signal clicked()

    property bool hovered: false

    // نشانگر فعال بودن - فقط در حالت باز شده
    Rectangle {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            margins: 4
        }
        width: 3
        radius: 2
        color: theme.primaryColor
        visible: isActive && !isCollapsed
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: isCollapsed ? 15 : 16
        anchors.rightMargin: isCollapsed ? 15 : 12
        spacing: isCollapsed ? 0 : 12

        // آیکون - همیشه مرکز باشد در حالت جمع شده
        Text {
            text: icon
            font.pixelSize: 18
            opacity: isActive ? 1.0 : (hovered ? 0.9 : 0.7)
            Layout.alignment: isCollapsed ? Qt.AlignCenter : Qt.AlignVCenter
        }

        // عنوان - فقط در حالت باز شده
        Text {
            text: title
            color: isActive ? theme.textPrimary : theme.textSecondary
            font.family: robotoRegular.name
            font.pixelSize: 13
            font.weight: isActive ? Font.Medium : Font.Normal
            Layout.fillWidth: true
            visible: !isCollapsed
        }

        // Badge - فقط در حالت باز شده
        Rectangle {
            visible: badgeCount > 0 && !isCollapsed
            width: Math.max(20, badgeText.width + 8)
            height: 20
            radius: 10
            color: theme.error
            Layout.alignment: Qt.AlignVCenter

            Text {
                id: badgeText
                text: badgeCount > 99 ? "99+" : badgeCount
                color: "white"
                font.family: robotoRegular.name
                font.pixelSize: 10
                font.bold: true
                anchors.centerIn: parent
            }
        }

        // Dot badge برای حالت جمع شده
        Rectangle {
            visible: badgeCount > 0 && isCollapsed
            width: 6
            height: 6
            radius: 3
            color: theme.error
            Layout.alignment: Qt.AlignTop | Qt.AlignRight
            Layout.topMargin: 8
            Layout.rightMargin: 8
        }
    }

    // پس‌زمینه هنگام hover
    Rectangle {
        anchors.fill: parent
        color: theme.primaryColor
        opacity: hovered ? 0.1 : 0
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    // ناحیه قابل کلیک
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: hovered = true
        onExited: hovered = false
        onClicked: navItem.clicked()
    }
}
