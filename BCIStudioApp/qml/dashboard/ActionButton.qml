import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


Rectangle {
    height: 36
    radius: 8

    property string buttonText: ""
    property color buttonColor: theme.primary
    signal buttonClicked()

    color: actionMouseArea.containsMouse ? Qt.darker(buttonColor, 1.1) : buttonColor

    Text {
        anchors.centerIn: parent
        text: buttonText
        color: "white"
        font.bold: true
        font.pixelSize: 12
    }

    MouseArea {
        id: actionMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: buttonClicked()
    }

    Behavior on color {
        ColorAnimation { duration: 200 }
    }
}
