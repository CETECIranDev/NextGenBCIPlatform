import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: neuralNetworkBackground
    anchors.fill: parent

    property int nodeCount: 15
    property int connectionCount: 40
    property int animationDuration: 4000
    property real baseOpacity: 0.3

    Repeater {
        model: connectionCount

        Rectangle {
            id: connection
            property point startPos: getRandomPoint()
            property point endPos: getRandomPoint()

            width: Math.sqrt(Math.pow(endPos.x - startPos.x, 2) + Math.pow(endPos.y - startPos.y, 2))
            height: 1
            x: startPos.x
            y: startPos.y
            rotation: Math.atan2(endPos.y - startPos.y, endPos.x - startPos.x) * 180 / Math.PI
            color: "#00D4AA"
            opacity: baseOpacity * 0.5

            LinearGradient {
                width: parent.width
                height: 1
                start: Qt.point(0, 0)
                end: Qt.point(parent.width, 0)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.4; color: "#00D4AA" }
                    GradientStop { position: 0.6; color: "#00D4AA" }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                running: true
                NumberAnimation {
                    from: baseOpacity * 0.2;
                    to: baseOpacity * 0.6;
                    duration: animationDuration;
                    easing.type: Easing.InOutSine
                }
                PauseAnimation { duration: 1000 }
            }
        }
    }

    Repeater {
        model: nodeCount

        Rectangle {
            id: node
            width: 3
            height: 3
            radius: 1.5
            x: Math.random() * neuralNetworkBackground.width
            y: Math.random() * neuralNetworkBackground.height
            color: "#00B8FF"
            opacity: baseOpacity

            SequentialAnimation on scale {
                loops: Animation.Infinite
                running: true
                NumberAnimation {
                    from: 1.0;
                    to: 1.8;
                    duration: animationDuration / 2;
                    easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    from: 1.8;
                    to: 1.0;
                    duration: animationDuration / 2;
                    easing.type: Easing.InOutSine
                }
            }
        }
    }

    function getRandomPoint() {
        return Qt.point(
            Math.random() * neuralNetworkBackground.width,
            Math.random() * neuralNetworkBackground.height
        )
    }
}
