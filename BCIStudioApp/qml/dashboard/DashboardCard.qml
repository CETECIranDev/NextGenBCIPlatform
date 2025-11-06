// DashboardCard.qml
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

    color: theme.backgroundCard
    radius: 16  // استفاده مستقیم از عدد به جای cardRadius
    border.color: elevation > 0 ? "transparent" : theme.border
    border.width: elevation > 0 ? 0 : 1

    // Material Shadow Effect
    layer.enabled: elevation > 0
    layer.effect: DropShadow {
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
        radius: 16

        // Header background با opacity
        Rectangle {
            anchors.fill: parent
            opacity: 0.08
            color: headerColor
            radius: 16
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: contentMargin
            anchors.rightMargin: contentMargin
            spacing: 15

            // Icon
            Text {
                text: icon
                font.pixelSize: 24
                color: headerColor
                visible: icon !== ""
                Layout.alignment: Qt.AlignVCenter
            }

            // Title and Subtitle
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 4

                Text {
                    text: title
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: 18
                    font.family: "Segoe UI, Roboto, -apple-system, sans-serif"
                    elide: Text.ElideRight
                    Layout.fillWidth: true
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

    // Content Area
    Item {
        id: contentContainer
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: contentMargin
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
        }
    ]

    transitions: Transition {
        PropertyAnimation {
            properties: "scale"
            duration: 300
            easing.type: Easing.OutCubic
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: dashboardCard.hoverEnabled
        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
    }
}
