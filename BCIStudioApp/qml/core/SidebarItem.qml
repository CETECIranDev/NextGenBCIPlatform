import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: sidebarItem
    height: 50
    color: getBackgroundColor()
    radius: 8

    property string itemId: ""
    property string icon: "📊"
    property string title: "Item"
    property string description: ""
    property int badgeCount: 0
    property bool isEnabled: true
    property bool isActive: false
    property bool isHovered: false

    signal clicked()

    // انیمیشن‌ها
    Behavior on color {
        ColorAnimation { duration: 200 }
    }
    Behavior on scale {
        NumberAnimation { duration: 150 }
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 8
        spacing: 12

        // آیکون
        Rectangle {
            width: 32
            height: 32
            radius: 6
            color: getIconColor()
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: sidebarItem.icon
                font.pixelSize: 14
                anchors.centerIn: parent
            }

            // نشانگر وضعیت فعال
            Rectangle {
                width: 3
                height: parent.height
                radius: 1.5
                color: appTheme.primary
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                visible: sidebarItem.isActive
            }
        }

        // متن
        Column {
            width: parent.width - 60
            spacing: 2
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: sidebarItem.title
                color: getTextColor()
                font.pixelSize: 13
                font.bold: sidebarItem.isActive
                width: parent.width
                elide: Text.ElideRight
            }

            Text {
                text: sidebarItem.description
                color: appTheme.textTertiary
                font.pixelSize: 10
                width: parent.width
                elide: Text.ElideRight
                visible: sidebarItem.isHovered && sidebarItem.description !== ""
            }
        }

        Item { width: 1; height: 1 }

        // Badge
        Rectangle {
            width: Math.max(18, badgeText.implicitWidth + 8)
            height: 18
            radius: 9
            color: appTheme.accent
            visible: sidebarItem.badgeCount > 0
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: badgeText
                text: sidebarItem.badgeCount > 99 ? "99+" : sidebarItem.badgeCount
                color: "white"
                font.pixelSize: 9
                font.bold: true
                anchors.centerIn: parent
            }
        }
    }

    // MouseArea برای تعامل
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: sidebarItem.isEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        enabled: sidebarItem.isEnabled

        onEntered: {
            sidebarItem.isHovered = true
            if (!sidebarItem.isActive) {
                hoverAnim.start()
            }
        }
        onExited: {
            sidebarItem.isHovered = false
            if (!sidebarItem.isActive) {
                resetAnim.start()
            }
        }
        onClicked: {
            if (sidebarItem.isEnabled) {
                sidebarItem.clicked()
                clickAnim.start()
            }
        }
    }

    // Tooltip
    ToolTip {
        visible: mouseArea.containsMouse && sidebarItem.description !== ""
        text: sidebarItem.description
        delay: 500
    }

    // توابع کمکی برای رنگ‌ها
    function getBackgroundColor() {
        if (!sidebarItem.isEnabled) {
            return "transparent"
        }
        if (sidebarItem.isActive) {
            return appTheme.primary + "20"
        }
        if (sidebarItem.isHovered) {
            return appTheme.backgroundTertiary
        }
        return "transparent"
    }

    function getIconColor() {
        if (!sidebarItem.isEnabled) {
            return appTheme.textDisabled
        }
        if (sidebarItem.isActive) {
            return appTheme.primary + "40"
        }
        return appTheme.backgroundTertiary
    }

    function getTextColor() {
        if (!sidebarItem.isEnabled) {
            return appTheme.textDisabled
        }
        if (sidebarItem.isActive) {
            return appTheme.primary
        }
        return appTheme.textPrimary
    }

    // انیمیشن‌ها
    PropertyAnimation {
        id: hoverAnim
        target: sidebarItem
        property: "scale"
        to: 1.02
        duration: 150
        easing.type: Easing.OutCubic
    }

    PropertyAnimation {
        id: resetAnim
        target: sidebarItem
        property: "scale"
        to: 1.0
        duration: 150
        easing.type: Easing.OutCubic
    }

    PropertyAnimation {
        id: clickAnim
        target: sidebarItem
        property: "scale"
        to: 0.95
        duration: 100
        easing.type: Easing.OutCubic
        onFinished: resetClickAnim.start()
    }

    PropertyAnimation {
        id: resetClickAnim
        target: sidebarItem
        property: "scale"
        to: 1.0
        duration: 100
        easing.type: Easing.OutCubic
    }
}