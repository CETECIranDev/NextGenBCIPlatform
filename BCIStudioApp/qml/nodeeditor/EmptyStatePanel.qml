import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    id: emptyStatePanel
    spacing: 16

    // Properties
    property string emptyTitle: ""
    property string emptyDescription: ""
    property string emptyIcon: "📄"
    property string actionText: ""
    property string secondaryActionText: ""
    property bool showAction: false
    property bool showSecondaryAction: false
    property real iconSize: 64
    property real titleSize: 18
    property real descriptionSize: 12
    property real maxTextWidth: 300
    property bool centered: true

    property var theme: ({
        "backgroundPrimary": "#FFFFFF",
        "backgroundSecondary": "#F8F9FA",
        "backgroundTertiary": "#E9ECEF",
        "primary": "#4361EE",
        "secondary": "#3A0CA3",
        "accent": "#7209B7",
        "success": "#4CC9F0",
        "warning": "#F72585",
        "error": "#EF476F",
        "info": "#4895EF",
        "textPrimary": "#212529",
        "textSecondary": "#6C757D",
        "textTertiary": "#ADB5BD",
        "border": "#DEE2E6"
    })

    // Signals
    signal actionClicked()
    signal secondaryActionClicked()
    signal iconClicked()

    // Layout alignment
    Layout.alignment: centered ? Qt.AlignCenter : Qt.AlignLeft

    // Icon
    Rectangle {
        id: iconContainer
        width: iconSize
        height: iconSize
        radius: iconSize / 2
        color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)
        Layout.alignment: Qt.AlignHCenter
        visible: emptyIcon !== ""

        Text {
            text: emptyIcon
            font.pixelSize: iconSize * 0.4
            color: theme.primary
            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: emptyStatePanel.iconClicked()
        }

        // Pulse animation
        SequentialAnimation on scale {
            running: true
            loops: Animation.Infinite
            NumberAnimation { to: 1.05; duration: 2000; easing.type: Easing.InOutQuad }
            NumberAnimation { to: 1.0; duration: 2000; easing.type: Easing.InOutQuad }
        }
    }

    // Content
    ColumnLayout {
        spacing: 8
        Layout.alignment: Qt.AlignHCenter
        Layout.maximumWidth: emptyStatePanel.maxTextWidth
        Layout.fillWidth: true

        // Title
        Text {
            id: titleText
            text: emptyTitle
            color: theme.textPrimary
            font.family: "Segoe UI Semibold"
            font.pixelSize: titleSize
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
        }

        // Description
        Text {
            id: descriptionText
            text: emptyDescription
            color: theme.textSecondary
            font.family: "Segoe UI"
            font.pixelSize: descriptionSize
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            lineHeight: 1.4
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
        }

        // Actions
        ColumnLayout {
            spacing: 8
            Layout.topMargin: 16
            Layout.alignment: Qt.AlignHCenter
            visible: showAction || showSecondaryAction

            // Primary Action
            Button {
                id: primaryActionButton
                text: actionText
                visible: showAction && actionText !== ""
                Layout.alignment: Qt.AlignHCenter

                background: Rectangle {
                    color: parent.down ? Qt.darker(theme.primary, 1.2) :
                           parent.hovered ? Qt.lighter(theme.primary, 1.1) : theme.primary
                    radius: 6
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: emptyStatePanel.actionClicked()
            }

            // Secondary Action
            Button {
                id: secondaryActionButton
                text: secondaryActionText
                visible: showSecondaryAction && secondaryActionText !== ""
                Layout.alignment: Qt.AlignHCenter

                background: Rectangle {
                    color: "transparent"
                    border.color: theme.border
                    border.width: 1
                    radius: 6
                }

                contentItem: Text {
                    text: parent.text
                    color: theme.textPrimary
                    font.family: "Segoe UI"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: emptyStatePanel.secondaryActionClicked()
            }
        }
    }

    // Public functions
    function show(title, description, icon) {
        emptyTitle = title || ""
        emptyDescription = description || ""
        emptyIcon = icon || "📄"
        visible = true
    }

    function hide() {
        visible = false
    }

    function setAction(text, visible) {
        actionText = text || ""
        showAction = visible !== undefined ? visible : text !== ""
    }

    function setSecondaryAction(text, visible) {
        secondaryActionText = text || ""
        showSecondaryAction = visible !== undefined ? visible : text !== ""
    }

    function setIcon(newIcon) {
        emptyIcon = newIcon || "📄"
    }

    function setThemeColor(color) {
        if (color) {
            iconContainer.color = Qt.rgba(color.r, color.g, color.b, 0.1)
            iconContainer.children[0].color = color
        }
    }

    // Animation functions
    function bounce() {
        bounceAnimation.start()
    }

    function fadeIn() {
        fadeInAnimation.start()
    }

    function fadeOut() {
        fadeOutAnimation.start()
    }

    // Animations
    SequentialAnimation {
        id: bounceAnimation
        running: false

        NumberAnimation {
            target: iconContainer
            property: "scale"
            from: 1.0
            to: 1.2
            duration: 200
            easing.type: Easing.OutBack
        }

        NumberAnimation {
            target: iconContainer
            property: "scale"
            from: 1.2
            to: 1.0
            duration: 300
            easing.type: Easing.OutBounce
        }
    }

    NumberAnimation {
        id: fadeInAnimation
        target: emptyStatePanel
        property: "opacity"
        from: 0.0
        to: 1.0
        duration: 500
        running: false
    }

    NumberAnimation {
        id: fadeOutAnimation
        target: emptyStatePanel
        property: "opacity"
        from: 1.0
        to: 0.0
        duration: 300
        running: false
    }

    Component.onCompleted: {
        console.log("EmptyStatePanel created")
    }
}

