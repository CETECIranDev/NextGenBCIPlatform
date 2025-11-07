
// ActionButton.qml
Rectangle {
    height: 30
    radius: 6
    color: mouseArea.containsMouse ? 
          Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.2) : 
          Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)
    border.color: theme.primary
    border.width: 1

    property string text: ""
    property string tooltip: ""

    signal clicked()

    Text {
        anchors.centerIn: parent
        text: parent.text
        color: theme.textPrimary
        font.pixelSize: 11
        font.bold: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: parent.clicked()

        ToolTip.text: parent.tooltip
        ToolTip.visible: containsMouse
    }

    Behavior on color {
        ColorAnimation { duration: 200 }
    }
}
