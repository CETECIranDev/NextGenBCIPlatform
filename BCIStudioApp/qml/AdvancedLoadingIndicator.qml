import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: advancedLoadingIndicator
    width: 550
    height: 8

    property real progress: 0
    property bool running: true
    property int duration: 11500

    Rectangle {
        id: track
        anchors.fill: parent
        color: "#334455"
        opacity: 0.3
        radius: 4
    }

    Rectangle {
        id: progress
        width: parent.width * progress
        height: parent.height
        color: "transparent"
        radius: 4
        clip: true

        Rectangle {
            id: progressBar
            width: parent.width
            height: parent.height
            color: "#00D4AA"
            radius: 4

            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(parent.width, 0)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#00D4AA" }
                    GradientStop { position: 0.3; color: "#00B8FF" }
                    GradientStop { position: 0.7; color: "#00B8FF" }
                    GradientStop { position: 1.0; color: "#00D4AA" }
                }
            }
        }

        // افکت درخشش پویا
        Glow {
            anchors.fill: progressBar
            source: progressBar
            color: "#00B8FF"
            radius: 10
            samples: 20

            SequentialAnimation on radius {
                loops: Animation.Infinite
                running: true
                NumberAnimation { from: 8; to: 12; duration: 2000; easing.type: Easing.InOutSine }
                NumberAnimation { from: 12; to: 8; duration: 2000; easing.type: Easing.InOutSine }
            }
        }
    }

    // انیمیشن پیشرفت با زمان طولانی
    SequentialAnimation {
        running: advancedLoadingIndicator.running
        loops: 1

        NumberAnimation {
            target: advancedLoadingIndicator
            property: "progress"
            from: 0.0
            to: 1.0
            duration: advancedLoadingIndicator.duration
            easing.type: Easing.InOutCubic
        }
    }

    // درصد پیشرفت (اختیاری)
    Text {
        anchors {
            top: parent.bottom
            topMargin: 8
            horizontalCenter: parent.horizontalCenter
        }
        text: Math.round(advancedLoadingIndicator.progress * 100) + "%"
        font.pixelSize: 12
        color: "#8899AA"
        opacity: 0.7
    }
}
