import QtQuick 2.15

Rectangle {
    id: statBadge
    height: 60
    radius: 12
    color: appTheme.backgroundCard
    border.color: appTheme.borderLight
    border.width: 1

    property string value: "0"
    property string label: "Label"
    property string icon: "📊"
    property color color: appTheme.primary

    Row {
        anchors.centerIn: parent
        spacing: 12
        padding: 15

        // Icon
        Rectangle {
            width: 32
            height: 32
            radius: 8
            color: statBadge.color + "20"
            border.color: statBadge.color + "40"
            border.width: 1

            Text {
                text: statBadge.icon
                font.pixelSize: 14
                anchors.centerIn: parent
            }
        }

        // Text content
        Column {
            spacing: 2
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: statBadge.value
                color: appTheme.textPrimary
                font.family: robotoBold.name
                font.pixelSize: 18
            }

            Text {
                text: statBadge.label
                color: appTheme.textSecondary
                font.family: robotoRegular.name
                font.pixelSize: 12
            }
        }
    }

    // Hover effect
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            hoverAnimation.start()
        }
        onExited: {
            resetAnimation.start()
        }
    }

    PropertyAnimation {
        id: hoverAnimation
        target: statBadge
        property: "scale"
        to: 1.05
        duration: 200
        easing.type: Easing.OutCubic
    }

    PropertyAnimation {
        id: resetAnimation
        target: statBadge
        property: "scale"
        to: 1.0
        duration: 200
        easing.type: Easing.OutCubic
    }
}