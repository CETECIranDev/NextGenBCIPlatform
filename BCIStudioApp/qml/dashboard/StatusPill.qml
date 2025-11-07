import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// StatusPill.qml
Rectangle {
    height: 24
    radius: 12
    opacity: 0.9

    property string statusText: ""
    property color statusColor: theme.primary
    property bool shouldPulse: false

    color: statusColor

    Text {
        anchors.centerIn: parent
        text: statusText
        color: "white"
        font.bold: true
        font.pixelSize: 10
        padding: 8
    }

    // Pulse animation
    SequentialAnimation on opacity {
        running: shouldPulse
        loops: Animation.Infinite
        NumberAnimation { to: 0.6; duration: 800; easing.type: Easing.InOutQuad }
        NumberAnimation { to: 0.9; duration: 800; easing.type: Easing.InOutQuad }
    }
}
