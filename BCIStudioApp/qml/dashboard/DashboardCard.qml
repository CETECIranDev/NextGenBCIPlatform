// DashboardCard.qml - نسخه اصلاح شده
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Rectangle {
    id: dashboardCard

    // Properties
    property string title: ""
    property string subtitle: ""
    property string icon: ""
    property int elevation: 2
    property color headerColor: theme.primary
    property bool hoverEnabled: true
    property alias content: contentContainer.data
    property real headerHeight: subtitle ? 80 : 70
    property real contentMargin: 20
    property bool collapsible: false
    property bool expanded: true
    property bool showActions: false
    property var actionButtons: []
    property string badgeText: ""
    property color badgeColor: theme.accent
    property bool loading: false
    property real cornerRadius: 16
    property bool isEmpty: false // Property جدید برای کنترل وضعیت خالی

    // Signals
    signal clicked()
    signal actionTriggered(string action)
    signal toggleExpanded(bool expanded)

    implicitWidth: 300
    implicitHeight: expanded ? (headerHeight + contentContainer.implicitHeight + contentMargin * 2) : headerHeight

    color: theme.backgroundCard
    radius: cornerRadius
    border.color: elevation > 0 ? "transparent" : theme.border
    border.width: elevation > 0 ? 0 : 1

    // Material Shadow Effect
    layer.enabled: elevation > 0
    layer.effect: DropShadow {
        id: shadowEffect
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: Math.min(elevation, 8)
        radius: elevation * 4
        samples: (elevation * 4) * 2 + 1
        color: "#40000000"
        cached: true
    }

    // Header Section
    Rectangle {
        id: header
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: headerHeight
        color: "transparent"
        radius: cornerRadius

        // Header background با گرادیان
        Rectangle {
            anchors.fill: parent
            opacity: 0.08
            color: headerColor
            radius: cornerRadius
        }

        // Highlight border on hover
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: headerColor
            border.width: mouseArea.containsMouse && hoverEnabled ? 2 : 0
            radius: cornerRadius
            opacity: 0.3
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: contentMargin
            anchors.rightMargin: contentMargin
            spacing: 15

            // Icon with background
            Rectangle {
                id: iconContainer
                width: 40
                height: 40
                radius: 12
                color: Qt.rgba(headerColor.r, headerColor.g, headerColor.b, 0.2)
                border.color: Qt.rgba(headerColor.r, headerColor.g, headerColor.b, 0.3)
                border.width: 1
                visible: icon !== ""
                Layout.alignment: Qt.AlignVCenter

                Text {
                    anchors.centerIn: parent
                    text: icon
                    font.pixelSize: 20
                    color: headerColor
                }

                // Pulse animation when loading
                SequentialAnimation on scale {
                    running: loading
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.1; duration: 800; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
                }
            }

            // Title and Subtitle
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 4

                RowLayout {
                    spacing: 8
                    Layout.fillWidth: true

                    Text {
                        text: title
                        color: theme.textPrimary
                        font.bold: true
                        font.pixelSize: 18
                        font.family: "Segoe UI, Roboto, -apple-system, sans-serif"
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    // Badge
                    Rectangle {
                        id: badge
                        visible: badgeText !== ""
                        width: badgeText ? Math.max(20, badgeText.length * 8 + 12) : 0
                        height: 20
                        radius: 10
                        color: badgeColor

                        Text {
                            anchors.centerIn: parent
                            text: badgeText
                            color: "white"
                            font.bold: true
                            font.pixelSize: 10
                        }
                    }
                }

                Text {
                    text: subtitle
                    color: theme.textSecondary
                    font.pixelSize: 14
                    elide: Text.ElideRight
                    visible: subtitle !== ""
                    Layout.fillWidth: true
                }
            }

            // Action Buttons
            RowLayout {
                spacing: 6
                visible: showActions && actionButtons.length > 0
                Layout.alignment: Qt.AlignVCenter

                Repeater {
                    model: actionButtons

                    Rectangle {
                        width: 32
                        height: 32
                        radius: 8
                        color: actionMouseArea.containsMouse ?
                              Qt.rgba(headerColor.r, headerColor.g, headerColor.b, 0.2) :
                              "transparent"
                        border.color: Qt.rgba(headerColor.r, headerColor.g, headerColor.b, 0.3)
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData.icon
                            font.pixelSize: 14
                            color: headerColor
                        }

                        MouseArea {
                            id: actionMouseArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: actionTriggered(modelData.action)
                        }
                    }
                }
            }

            // Expand/Collapse Button
            Rectangle {
                id: expandButton
                width: 28
                height: 28
                radius: 8
                color: expandMouseArea.containsMouse ?
                      Qt.rgba(headerColor.r, headerColor.g, headerColor.b, 0.2) :
                      "transparent"
                border.color: Qt.rgba(headerColor.r, headerColor.g, headerColor.b, 0.3)
                border.width: 1
                visible: collapsible
                Layout.alignment: Qt.AlignVCenter

                Text {
                    anchors.centerIn: parent
                    text: expanded ? "⌄" : ">"
                    font.pixelSize: 14
                    color: headerColor
                    font.bold: true
                }

                MouseArea {
                    id: expandMouseArea
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: toggleCard()
                }
            }
        }

        // Loading Indicator
        Rectangle {
            id: loadingIndicator
            anchors.bottom: parent.bottom
            width: parent.width
            height: 3
            color: "transparent"
            visible: loading

            Rectangle {
                id: loadingBar
                width: parent.width
                height: 3
                color: headerColor

                SequentialAnimation on x {
                    running: loading
                    loops: Animation.Infinite
                    NumberAnimation { from: -parent.width; to: parent.width; duration: 1500; easing.type: Easing.InOutQuad }
                }
            }
        }

        // Bottom border for header
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: theme.divider
            opacity: 0.3
        }
    }

    // Content Area - استفاده از ColumnLayout برای مدیریت بهتر محتوا
    ColumnLayout {
        id: contentContainer
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: contentMargin
        spacing: 0
        visible: expanded && !loading

        // محتوای اصلی اینجا قرار می‌گیرد
    }

    // Empty State - فقط زمانی نشان داده می‌شود که isEmpty=true باشد
    Rectangle {
        anchors.fill: contentContainer
        color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.03)
        radius: 8
        border.color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)
        border.width: 1
        //border.style: Border.Dash
        visible: expanded && isEmpty && !loading

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 8

            Text {
                text: "📊"
                font.pixelSize: 32
                opacity: 0.5
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "No Content Available"
                color: theme.textSecondary
                font.pixelSize: 14
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Add content to display data"
                color: theme.textTertiary
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    // Hover Effects
    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse && hoverEnabled
            PropertyChanges {
                target: dashboardCard
                scale: 1.02
            }
        },
        State {
            name: "loading"
            when: loading
            PropertyChanges {
                target: dashboardCard
                opacity: 0.8
            }
        },
        State {
            name: "collapsed"
            when: !expanded
            PropertyChanges {
                target: contentContainer
                opacity: 0
            }
            PropertyChanges {
                target: dashboardCard
                implicitHeight: headerHeight
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"; to: "hovered"
            reversible: true
            PropertyAnimation {
                properties: "scale"
                duration: 300
                easing.type: Easing.OutCubic
            }
        },
        Transition {
            from: "*"; to: "collapsed"
            reversible: true
            PropertyAnimation {
                properties: "opacity, implicitHeight"
                duration: 400
                easing.type: Easing.OutCubic
            }
        },
        Transition {
            from: "*"; to: "loading"
            reversible: true
            PropertyAnimation {
                properties: "opacity"
                duration: 300
                easing.type: Easing.OutCubic
            }
        }
    ]

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: dashboardCard.hoverEnabled
        cursorShape: containsMouse && hoverEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            if (hoverEnabled) {
                dashboardCard.clicked()
            }
        }
    }

    // Behaviors for smooth animations
    Behavior on scale {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    Behavior on opacity {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    Behavior on implicitHeight {
        NumberAnimation { duration: 400; easing.type: Easing.OutCubic }
    }

    Behavior on border.width {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    // Public API Methods
    function showLoading() {
        loading = true
    }

    function hideLoading() {
        loading = false
    }

    function toggleCard() {
        if (collapsible) {
            expanded = !expanded
            toggleExpanded(expanded)
        }
    }

    function addAction(icon, action) {
        if (!actionButtons) {
            actionButtons = []
        }
        actionButtons.push({icon: icon, action: action})
        actionButtonsChanged()
    }

    function setBadge(text, color) {
        badgeText = text
        if (color) badgeColor = color
    }

    function clearBadge() {
        badgeText = ""
    }

    // تابع جدید برای کنترل وضعیت خالی
    function setEmptyState(isEmptyState) {
        isEmpty = isEmptyState
    }

    // Entrance animation
    NumberAnimation {
        id: entranceAnimation
        target: dashboardCard
        properties: "scale, opacity"
        from: 0.9
        to: 1.0
        duration: 500
        easing.type: Easing.OutBack
    }

    Component.onCompleted: {
        // Start entrance animation
        opacity = 0
        scale = 0.9
        entranceAnimation.start()

        // به طور پیش‌فرض کارت خالی نیست
        isEmpty = false
    }
}
