import QtQuick
import Qt5Compat.GraphicalEffects

Rectangle {
    id: recordButton
    width: 36
    height: 36
    radius: theme.radius.lg
    color: recording ? theme.error : theme.success

    property bool recording: false
    signal toggled(bool isRecording)  // تغییر نام signal

    layer.enabled: true
    layer.effect: DropShadow {
        color: recording ? theme.error : theme.success
        radius: recording ? 16 : 8
        samples: 25
        spread: 0.2
    }

    Rectangle {
        width: recording ? 12 : 18
        height: recording ? 12 : 18
        radius: recording ? 6 : 9
        color: "white"
        anchors.centerIn: parent

        Behavior on width {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }

        Behavior on height {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }

        Behavior on radius {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }
    }

    // Pulsing animation when recording
    SequentialAnimation on scale {
        loops: Animation.Infinite
        running: recording
        NumberAnimation { from: 1.0; to: 1.1; duration: 800; easing.type: Easing.InOutSine }
        NumberAnimation { from: 1.1; to: 1.0; duration: 800; easing.type: Easing.InOutSine }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            recording = !recording
            toggled(recording)  // استفاده از signal جدید
        }
    }
}
