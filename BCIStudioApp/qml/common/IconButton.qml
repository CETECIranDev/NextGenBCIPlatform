import QtQuick
import QtQuick.Controls

Rectangle {
    id: iconButton
    
    property string icon: ""
    property string tooltip: ""
    property bool showBadge: false
    property color badgeColor: "#FF4757"
    
    signal clicked()
    
    width: 32
    height: 32
    radius: 6
    color: iconButtonMouseArea.pressed ? theme.backgroundTertiary : 
           iconButtonMouseArea.containsMouse ? theme.backgroundTertiary : "transparent"

    Text {
        text: iconButton.icon
        font.pixelSize: 14
        anchors.centerIn: parent
        color: theme.textPrimary
    }

    // Notification Badge
    Rectangle {
        visible: iconButton.showBadge
        x: 18
        y: 6
        width: 8
        height: 8
        radius: 4
        color: iconButton.badgeColor
        border.color: theme.backgroundSecondary
        border.width: 1
    }
    
    MouseArea {
        id: iconButtonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: iconButton.clicked()
    }

    // Tooltip
    Rectangle {
        visible: iconButtonMouseArea.containsMouse
        width: tooltipText.width + 12
        height: tooltipText.height + 8
        radius: 4
        color: theme.backgroundElevated
        border.color: theme.border
        x: parent.width / 2 - width / 2
        y: -height - 6
        
        Text {
            id: tooltipText
            text: iconButton.tooltip
            color: theme.textPrimary
            font.pixelSize: 10
            anchors.centerIn: parent
        }
    }
}