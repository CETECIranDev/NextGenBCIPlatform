import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Rectangle {
    id: iconButton

    property string icon: ""
    property string tooltip: ""
    property bool showBadge: false
    property color badgeColor: theme.accent
    property int badgeCount: 0
    property int size: 36
    property color glowColor: theme.primary
    property bool isActive: false
    property real animationDuration: 300

    signal clicked()
    signal pressed()
    signal released()

    width: size
    height: size
    radius: theme.radius.md
    color: {
        if (iconButtonMouseArea.pressed)
            return theme.backgroundTertiary
        else if (isActive)
            return theme.primary + "20" // 20% opacity
        else if (iconButtonMouseArea.containsMouse)
            return theme.backgroundTertiary
        else
            return "transparent"
    }
    border.color: isActive ? theme.primary : "transparent"
    border.width: isActive ? 1 : 0

    // افکت شیشه‌ای در حالت hover
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        gradient: theme.glassGradient
        opacity: iconButtonMouseArea.containsMouse ? appTheme.glassOpacity : 0
        visible: !isActive
    }

    // آیکون اصلی
    Text {
        id: iconText
        text: iconButton.icon
        font.pixelSize: Math.max(12, size * 0.35)
        anchors.centerIn: parent
        color: {
            if (isActive)
                return theme.primary
            else
                return theme.textPrimary
        }

        Behavior on color {
            ColorAnimation { duration: animationDuration }
        }
    }

    // افکت درخشش برای آیکون فعال
    Glow {
        anchors.fill: iconText
        source: iconText
        color: glowColor
        radius: isActive ? 8 : 0
        samples: 16
        spread: 0.2
        visible: isActive

        Behavior on radius {
            NumberAnimation { duration: animationDuration }
        }
    }

    // Notification Badge - Professional
    Rectangle {
        visible: iconButton.showBadge
        x: parent.width - (badgeCount > 0 ? 16 : 10)
        y: 6
        width: badgeCount > 0 ? badgeContent.width + 6 : 8
        height: badgeCount > 0 ? 16 : 8
        radius: badgeCount > 0 ? 8 : 4
        color: iconButton.badgeColor

        layer.enabled: true
        layer.effect: DropShadow {
            color: iconButton.badgeColor
            radius: 4
            samples: 9
            spread: 0.1
        }

        // محتوای badge برای اعداد
        Row {
            id: badgeContent
            anchors.centerIn: parent
            spacing: 1
            visible: badgeCount > 0

            Text {
                text: badgeCount > 99 ? "99+" : badgeCount
                color: "white"
                font.pixelSize: 9
                font.weight: Font.Bold
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Badge pulse animation
        SequentialAnimation on scale {
            loops: Animation.Infinite
            running: visible && badgeCount > 0
            NumberAnimation { from: 1.0; to: 1.1; duration: 1500; easing.type: Easing.InOutSine }
            NumberAnimation { from: 1.1; to: 1.0; duration: 1500; easing.type: Easing.InOutSine }
        }
    }

    // Ripple Effect on Click
    Rectangle {
        id: rippleEffect
        width: 0
        height: 0
        radius: width / 2
        color: theme.primary
        opacity: 0.3
        anchors.centerIn: parent
        visible: false
    }

    MouseArea {
        id: iconButtonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onPressed: {
            iconButton.pressed()
            // Ripple effect
            rippleEffect.visible = true
            rippleEffect.width = 0
            rippleEffect.height = 0
            rippleAnimation.start()
        }

        onReleased: {
            iconButton.released()
        }

        onClicked: {
            iconButton.clicked()
        }
    }

    // Ripple Animation
    ParallelAnimation {
        id: rippleAnimation
        NumberAnimation {
            target: rippleEffect
            property: "width"
            from: 0
            to: iconButton.width * 2
            duration: animationDuration
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: rippleEffect
            property: "height"
            from: 0
            to: iconButton.height * 2
            duration: animationDuration
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: rippleEffect
            property: "opacity"
            from: 0.3
            to: 0
            duration: animationDuration
            easing.type: Easing.OutCubic
        }
        onFinished: {
            rippleEffect.visible = false
        }
    }

    // Professional Tooltip
    Rectangle {
        visible: iconButtonMouseArea.containsMouse && tooltip !== ""
        width: tooltipText.implicitWidth + 20
        height: tooltipText.implicitHeight + 12
        radius: theme.radius.sm
        color: theme.backgroundElevated
        border.color: theme.border
        border.width: 1
        x: parent.width / 2 - width / 2
        y: -height - 8

        layer.enabled: true
        layer.effect: DropShadow {
            color: theme.shadow
            radius: 8
            samples: 17
            verticalOffset: 2
        }

        Text {
            id: tooltipText
            text: iconButton.tooltip
            color: theme.textPrimary
            font.pixelSize: theme.typography.caption.size
            font.weight: Font.Medium
            anchors.centerIn: parent
        }

        // Tooltip arrow
        Canvas {
            width: 12
            height: 6
            anchors {
                top: parent.bottom
                horizontalCenter: parent.horizontalCenter
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.fillStyle = theme.backgroundElevated
                ctx.strokeStyle = theme.border
                ctx.lineWidth = 1

                ctx.beginPath()
                ctx.moveTo(0, 0)
                ctx.lineTo(6, 6)
                ctx.lineTo(12, 0)
                ctx.closePath()
                ctx.fill()
                ctx.stroke()
            }
        }
    }

    // Hover scale animation - جایگزین States
    states: [
        State {
            name: "hovered"
            when: iconButtonMouseArea.containsMouse
            PropertyChanges {
                target: iconButton
                scale: 1.05
            }
        },
        State {
            name: "pressed"
            when: iconButtonMouseArea.pressed
            PropertyChanges {
                target: iconButton
                scale: 0.95
            }
        },
        State {
            name: "active"
            when: isActive
            PropertyChanges {
                target: iconButton
                scale: 1.02
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "*"
            NumberAnimation {
                properties: "scale"
                duration: 200
                easing.type: Easing.OutCubic
            }
        }
    ]

    // Public API functions
    function setActive(active) {
        isActive = active
    }

    function setBadge(count) {
        badgeCount = count
        showBadge = count > 0
    }

    function clearBadge() {
        badgeCount = 0
        showBadge = false
    }

    function trigger() {
        clicked()
    }

    Component.onCompleted: {
        console.log("🎯 Enterprise IconButton initialized - Size:", size, "Icon:", icon)
    }
}
