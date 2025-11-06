// FloatingActionButton.qml
import QtQuick
import QtQuick.Controls

Rectangle {
    id: fab

    property string icon: ""
    property string text: ""
    property string size: "medium" // small, medium, large
    property color backgroundColor: theme.primary

    width: size === "small" ? 50 : size === "large" ? 70 : 60
    height: width
    radius: width / 2
    color: backgroundColor

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 4
        radius: 8
        samples: 17
        color: "#40000000"
    }

    Text {
        anchors.centerIn: parent
        text: icon
        font.pixelSize: size === "small" ? 16 : size === "large" ? 24 : 20
        color: "white"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: fab.clicked()
    }

    signal clicked()
}
