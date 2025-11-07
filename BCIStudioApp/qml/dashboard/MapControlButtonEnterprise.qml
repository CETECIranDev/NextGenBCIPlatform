import QtQuick
import QtQuick.Controls

Rectangle {
    id: controlButton
    width: 36
    height: 36
    radius: 8
    color: buttonMouseArea.containsMouse ? 
          Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.2) : 
          Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)
    border.color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.3)
    border.width: 1

    property string icon: ""
    property string tooltip: ""

    signal clicked()

    Text {
        anchors.centerIn: parent
        text: controlButton.icon
        font.pixelSize: 14
        color: theme.textPrimary
    }

    MouseArea {
        id: buttonMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: controlButton.clicked()
    }

    ToolTip {
        visible: buttonMouseArea.containsMouse
        text: controlButton.tooltip
        delay: 500
    }
}
