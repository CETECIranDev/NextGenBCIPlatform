import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: navButton
    width: 60
    height: 60
    radius: 12
    color: getButtonColor()

    // Properties
    property string icon: "⚡"
    property string label: "Button"
    property color color: "#7C4DFF"
    property bool isActive: false
    property bool isHovered: false
    property string tooltipText: label
    property bool showNotification: false
    property bool enabled: true

    signal clicked()
    signal pressed()
    signal released()

    // Tooltip
    ToolTip {
        id: tooltip
        text: navButton.tooltipText
        delay: 500
        timeout: 3000
        visible: false
    }

    // Mouse Area
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        enabled: navButton.enabled

        onEntered: {
            navButton.isHovered = true
            if (tooltip.text.length > 0) {
                tooltip.visible = true
            }
        }

        onExited: {
            navButton.isHovered = false
            tooltip.visible = false
        }

        onPressed: {
            navButton.scale = 0.95
            navButton.pressed()
        }

        onReleased: {
            navButton.scale = 1.0
            navButton.released()
        }

        onClicked: {
            if (navButton.enabled) {
                navButton.clicked()
            }
        }
    }

    // محتوای دکمه
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 4

        // آیکون
        Rectangle {
            id: iconContainer
            width: 28
            height: 28
            radius: 8
            color: getIconColor()
            Layout.alignment: Qt.AlignHCenter

            Text {
                anchors.centerIn: parent
                text: navButton.icon
                font.pixelSize: 14
                color: getIconTextColor()
            }

            // Rotation animation for loading state
            Behavior on rotation {
                NumberAnimation { duration: 300; easing.type: Easing.InOutQuad }
            }
        }

        // متن
        Text {
            id: buttonLabel
            text: navButton.label
            font.family: "Roboto"
            font.pixelSize: 9
            font.weight: Font.Medium
            color: getTextColor()
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: 55
            elide: Text.ElideRight
            wrapMode: Text.Wrap
            maximumLineCount: 2
        }
    }

    // Indicator for active state
    Rectangle {
        id: activeIndicator
        width: 3
        height: parent.height * 0.6
        radius: 2
        color: navButton.color
        anchors {
            left: parent.left
            leftMargin: 2
            verticalCenter: parent.verticalCenter
        }
        visible: navButton.isActive

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    // Notification badge
    Rectangle {
        id: notificationBadge
        width: 8
        height: 8
        radius: 4
        color: "#FF4081"
        anchors {
            top: parent.top
            right: parent.right
            margins: 2
        }
        visible: navButton.showNotification

        // Pulsing animation
        SequentialAnimation on scale {
            running: notificationBadge.visible
            loops: Animation.Infinite
            NumberAnimation { to: 1.3; duration: 500; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
        }
    }

    // Drop shadow effect (ساده‌شده)
    Rectangle {
        id: shadowEffect
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        border.color: navButton.isActive ? Qt.rgba(navButton.color.r, navButton.color.g, navButton.color.b, 0.3) : "transparent"
        border.width: 2
        opacity: navButton.isActive ? 1 : 0

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    // Animations
    Behavior on scale {
        NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
    }

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    // توابع کمکی برای مدیریت رنگ‌ها
    function getButtonColor() {
        if (!navButton.enabled) {
            return "transparent"
        }

        if (navButton.isActive) {
            return Qt.rgba(navButton.color.r * 0.15, navButton.color.g * 0.15, navButton.color.b * 0.15, 0.3)
        } else if (navButton.isHovered) {
            return Qt.rgba(1, 1, 1, 0.1)
        } else {
            return "transparent"
        }
    }

    function getIconColor() {
        if (!navButton.enabled) {
            return Qt.rgba(0.3, 0.3, 0.3, 0.5)
        }

        if (navButton.isActive) {
            return navButton.color
        } else if (navButton.isHovered) {
            return Qt.lighter(navButton.color, 1.5)
        } else {
            return Qt.rgba(0.5, 0.5, 0.5, 0.3)
        }
    }

    function getIconTextColor() {
        if (!navButton.enabled) {
            return Qt.rgba(1, 1, 1, 0.4)
        }

        if (navButton.isActive) {
            return "white"
        } else {
            return Qt.rgba(1, 1, 1, 0.8)
        }
    }

    function getTextColor() {
        if (!navButton.enabled) {
            return Qt.rgba(1, 1, 1, 0.4)
        }

        if (navButton.isActive) {
            return navButton.color
        } else {
            return Qt.rgba(1, 1, 1, 0.7)
        }
    }

    // توابع عمومی برای مدیریت state
    function showNotification() {
        navButton.showNotification = true
    }

    function hideNotification() {
        navButton.showNotification = false
    }

    function setActive() {
        navButton.isActive = true
    }

    function setInactive() {
        navButton.isActive = false
    }

    function pulse() {
        pulseAnimation.start()
    }

    // Animation برای effects ویژه
    SequentialAnimation {
        id: pulseAnimation
        NumberAnimation {
            target: navButton
            property: "scale"
            to: 1.1
            duration: 150
            easing.type: Easing.OutQuad
        }
        NumberAnimation {
            target: navButton
            property: "scale"
            to: 1.0
            duration: 150
            easing.type: Easing.InQuad
        }
    }

    // برای موارد خاص مانند new project
    property bool isSpecial: false

    onIsSpecialChanged: {
        if (isSpecial) {
            specialAnimation.start()
        } else {
            specialAnimation.stop()
            navButton.rotation = 0
            navButton.scale = 1.0
        }
    }

    SequentialAnimation {
        id: specialAnimation
        loops: Animation.Infinite
        running: navButton.isSpecial && navButton.enabled

        ParallelAnimation {
            NumberAnimation {
                target: navButton
                property: "rotation"
                from: -5
                to: 5
                duration: 500
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: navButton
                property: "scale"
                from: 1.0
                to: 1.05
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: navButton
                property: "rotation"
                from: 5
                to: -5
                duration: 500
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: navButton
                property: "scale"
                from: 1.05
                to: 1.0
                duration: 500
                easing.type: Easing.InOutQuad
            }
        }
    }

    // States برای مدیریت وضعیت‌های مختلف
    states: [
        State {
            name: "DISABLED"
            when: !navButton.enabled
            PropertyChanges {
                target: navButton
                opacity: 0.5
            }
        },
        State {
            name: "LOADING"
            PropertyChanges {
                target: iconContainer
                rotation: 360
            }
        }
    ]

    transitions: [
        Transition {
            to: "LOADING"
            RotationAnimation {
                target: iconContainer
                duration: 1000
                loops: Animation.Infinite
                easing.type: Easing.Linear
            }
        }
    ]

    // برای نمایش وضعیت loading
    function startLoading() {
        navButton.state = "LOADING"
    }

    function stopLoading() {
        navButton.state = ""
        iconContainer.rotation = 0
    }

    // مدیریت opacity بر اساس enabled state
    onEnabledChanged: {
        if (!enabled) {
            navButton.state = "DISABLED"
        } else {
            navButton.state = ""
        }
    }

    Component.onCompleted: {
        // مقداردهی اولیه state
        if (!navButton.enabled) {
            navButton.state = "DISABLED"
        }
    }
}
