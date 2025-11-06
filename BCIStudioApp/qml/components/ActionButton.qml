import QtQuick
import QtQuick.Controls

//import "../theme"

Button {
    id: root

    property string iconSource: ""
    
    background: Rectangle {
        color: root.hovered ? themeManager.surfaceLight : "transparent"
        border.color: themeManager.secondary
        border.width: themeManager.borderWidth
        radius: themeManager.radiusMedium
    }

    contentItem: Item {
        width: parent.width
        height: parent.height

        Image {
            id: icon
            source: root.iconSource
            width: 32; height: 32
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: themeManager.spacingLarge
            sourceSize.width: 32
            sourceSize.height: 32
            antialiasing: true
        }
        
        Label {
            text: root.text
            color: themeManager.textPrimary
            font: themeManager.fontBase
            anchors.top: icon.bottom
            anchors.topMargin: themeManager.spacingMedium
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
