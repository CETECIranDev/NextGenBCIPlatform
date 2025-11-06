import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Rectangle {
    id: materialCard
    
    property string title: ""
    property string icon: ""
    property string description: ""
    property color headerColor: "#7C4DFF"
    property real elevation: 2
    
    radius: 12
    color: theme.backgroundCard
    border.color: theme.border
    border.width: elevation > 0 ? 0 : 1
    
    // Shadow effect
    layer.enabled: elevation > 0
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: elevation
        radius: elevation * 4
        samples: (radius * 2) + 1
        color: "#20000000"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            id: header
            Layout.fillWidth: true
            height: 60
            color: headerColor
            radius: materialCard.radius - 2

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 12

                Text {
                    text: icon
                    font.pixelSize: 24
                    color: "white"
                }

                Text {
                    text: title
                    color: "white"
                    font.bold: true
                    font.pixelSize: 18
                    Layout.fillWidth: true
                }
            }
        }

        // Content
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 16
            spacing: 8

            Text {
                text: description
                color: theme.textSecondary
                font.pixelSize: 14
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            // Content placeholder
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}
