import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects  // برای Qt 6

Item {
    id: cardRoot

    // Properties
    property string title: ""
    property string icon: ""
    property string subtitle: ""
    property bool hoverEnabled: true
    property bool clickable: false
    property real radius: 12
    property real borderWidth: 1
    property color borderColor: theme.border
    property color backgroundColor: theme.backgroundCard
    property color hoverColor: Qt.lighter(theme.backgroundCard, 1.1)
    property alias contentItem: contentContainer.data
    property alias headerItem: headerContainer.data
    property alias footerItem: footerContainer.data
    property int contentHeight: 0

    // Shadow properties
    property bool shadowEnabled: true
    property real shadowRadius: 16
    property real shadowOpacity: 0.1
    property real shadowVerticalOffset: 2
    property color shadowColor: Qt.rgba(0, 0, 0, shadowOpacity)

    // Sizes
    property real headerHeight: title || icon ? 50 : 0
    property real footerHeight: 0
    property real contentTopMargin: 10
    property real contentBottomMargin: 10

    implicitWidth: 300
    implicitHeight: headerHeight + contentContainer.height + footerHeight +
                   contentTopMargin + contentBottomMargin

    // Main Card Background با سایه
    Rectangle {
        id: cardBackground
        anchors.fill: parent
        color: cardRoot.backgroundColor
        border.color: cardRoot.borderColor
        border.width: cardRoot.borderWidth
        radius: cardRoot.radius

        layer.enabled: cardRoot.shadowEnabled
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: cardRoot.shadowVerticalOffset
            radius: cardRoot.shadowRadius
            samples: cardRoot.shadowRadius * 2 + 1
            color: cardRoot.shadowColor
        }

        // Hover effect
        states: [
            State {
                name: "hovered"
                when: mouseArea.containsMouse && cardRoot.hoverEnabled
                PropertyChanges {
                    target: cardBackground
                    color: cardRoot.hoverColor
                    scale: 1.02
                }
                PropertyChanges {
                    target: shadowEffect
                    radius: cardRoot.shadowRadius * 1.2
                }
            },
            State {
                name: "pressed"
                when: mouseArea.pressed
                PropertyChanges {
                    target: cardBackground
                    color: Qt.darker(cardRoot.hoverColor, 1.1)
                    scale: 0.98
                }
            }
        ]

        transitions: Transition {
            PropertyAnimation {
                properties: "color, scale"
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        // Mouse Area for interactions
        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: cardRoot.hoverEnabled
            enabled: cardRoot.clickable
            cursorShape: cardRoot.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor

            onClicked: cardRoot.clicked()
            onDoubleClicked: cardRoot.doubleClicked()
            onPressAndHold: cardRoot.pressAndHold()
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // Header Section
            Item {
                id: headerContainer
                Layout.fillWidth: true
                Layout.preferredHeight: cardRoot.headerHeight
                visible: cardRoot.headerHeight > 0

                // Default Header (if no custom header provided)
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.rightMargin: 16
                    visible: headerContainer.data.length === 0

                    // Icon
                    Text {
                        id: iconText
                        text: cardRoot.icon
                        font.pixelSize: 18
                        Layout.alignment: Qt.AlignVCenter
                    }

                    // Title and Subtitle
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 2

                        Text {
                            id: titleText
                            text: cardRoot.title
                            color: theme.textPrimary
                            font.bold: true
                            font.pixelSize: 16
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            id: subtitleText
                            text: cardRoot.subtitle
                            color: theme.textSecondary
                            font.pixelSize: 12
                            elide: Text.ElideRight
                            visible: cardRoot.subtitle !== ""
                            Layout.fillWidth: true
                        }
                    }

                    // Optional Menu Button
                    Button {
                        id: menuButton
                        text: "⋯"
                        flat: true
                        visible: false
                        Layout.alignment: Qt.AlignVCenter
                        onClicked: console.log("Card menu clicked")
                    }
                }
            }

            // Separator
            Rectangle {
                id: headerSeparator
                Layout.fillWidth: true
                height: 1
                color: theme.border
                opacity: 0.3
                visible: cardRoot.headerHeight > 0 && contentContainer.children.length > 0
            }

            // Content Section
            Item {
                id: contentContainer
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: cardRoot.contentTopMargin
                Layout.bottomMargin: cardRoot.contentBottomMargin
                Layout.leftMargin: 16
                Layout.rightMargin: 16
            }

            // Footer Separator
            Rectangle {
                id: footerSeparator
                Layout.fillWidth: true
                height: 1
                color: theme.border
                opacity: 0.3
                visible: cardRoot.footerHeight > 0
            }

            // Footer Section
            Item {
                id: footerContainer
                Layout.fillWidth: true
                Layout.preferredHeight: cardRoot.footerHeight
                visible: cardRoot.footerHeight > 0
            }
        }
    }

    // Shadow effect (جداگانه برای انیمیشن)
    DropShadow {
        id: shadowEffect
        anchors.fill: cardBackground
        source: cardBackground
        horizontalOffset: 0
        verticalOffset: cardRoot.shadowVerticalOffset
        radius: cardRoot.shadowRadius
        samples: cardRoot.shadowRadius * 2 + 1
        color: cardRoot.shadowColor
        visible: cardRoot.shadowEnabled
        transparentBorder: true

        Behavior on radius {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }
    }

    // Utility functions
    function showMenu() {
        menuButton.visible = true
    }

    function hideMenu() {
        menuButton.visible = false
    }

    function setHeaderHeight(height) {
        cardRoot.headerHeight = height
    }

    function setFooterHeight(height) {
        cardRoot.footerHeight = height
    }

    // Theme integration
    property var theme: {
        "backgroundCard": "#1E1E1E",
        "textPrimary": "#FFFFFF",
        "textSecondary": "#B0B0B0",
        "textDisabled": "#666666",
        "border": "#333333",
        "backgroundLight": "#2D2D2D"
    }
}
