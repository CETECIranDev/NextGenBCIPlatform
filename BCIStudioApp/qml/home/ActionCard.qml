import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    id: actionCard
    height: 100
    Layout.fillWidth: true
    radius: 12
    color: appTheme.backgroundElevated
    border.color: appTheme.borderLight
    border.width: 1

    property string icon: "📊"
    property string title: "Action Title"
    property string description: "Action description"
    property color color: appTheme.primary

    signal clicked()

    // Hover and click effects
    property bool isHovered: false

    // Background gradient on hover
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        gradient: Gradient {
            GradientStop { position: 0.0; color: actionCard.isHovered ? actionCard.color + "10" : "transparent" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        opacity: actionCard.isHovered ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    Row {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Icon
        Rectangle {
            width: 50
            height: 50
            radius: 10
            color: actionCard.color + "20"
            border.color: actionCard.color + "40"
            border.width: 1

            Text {
                text: actionCard.icon
                font.pixelSize: 20
                anchors.centerIn: parent
            }

            // Shine effect
            layer.enabled: true
            layer.effect: Glow {
                color: actionCard.color + "30"
                radius: 8
                samples: 16
            }
        }

        // Text content
        Column {
            width: parent.width - 85
            spacing: 4
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: actionCard.title
                color: appTheme.textPrimary
                font.family: robotoBold.name
                font.pixelSize: 16
                width: parent.width
                elide: Text.ElideRight
            }

            Text {
                text: actionCard.description
                color: appTheme.textSecondary
                font.family: robotoRegular.name
                font.pixelSize: 12
                lineHeight: 1.4
                width: parent.width
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }
        }
    }

    // Chevron icon
    Text {
        text: "➡️"
        font.pixelSize: 14
        color: appTheme.textTertiary
        anchors {
            right: parent.right
            rightMargin: 15
            verticalCenter: parent.verticalCenter
        }
        opacity: actionCard.isHovered ? 1 : 0.5
        rotation: actionCard.isHovered ? 0 : -45
        Behavior on rotation { NumberAnimation { duration: 200 } }
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    // Mouse area for interactions
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: {
            actionCard.isHovered = true
            hoverAnim.start()
        }
        onExited: {
            actionCard.isHovered = false
            resetAnim.start()
        }
        onClicked: actionCard.clicked()
    }

    // Animations
    PropertyAnimation {
        id: hoverAnim
        target: actionCard
        property: "scale"
        to: 1.02
        duration: 200
        easing.type: Easing.OutCubic
    }

    PropertyAnimation {
        id: resetAnim
        target: actionCard
        property: "scale"
        to: 1.0
        duration: 200
        easing.type: Easing.OutCubic
    }

    // Ripple effect on click
    Rectangle {
        id: ripple
        width: 0
        height: 0
        radius: width / 2
        color: actionCard.color + "20"
        anchors.centerIn: parent
        opacity: 0
    }

    function showRipple() {
        ripple.width = 0
        ripple.height = 0
        ripple.opacity = 0.8
        rippleAnim.start()
    }

    PropertyAnimation {
        id: rippleAnim
        target: ripple
        properties: "width,height,opacity"
        to: Math.max(actionCard.width, actionCard.height) * 2
        duration: 600
        easing.type: Easing.OutCubic
        onFinished: ripple.opacity = 0
    }
}
