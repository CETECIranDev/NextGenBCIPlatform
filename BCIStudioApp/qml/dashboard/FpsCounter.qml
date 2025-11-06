// FPS Counter Component
import QtQuick
import QtQuick.Layouts

Item {
    id: fpsCounter
    property real fps: 0
    property int frameCount: 0
    property int lastTime: 0
    
    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            var currentTime = new Date().getTime()
            if (lastTime > 0) {
                fps = frameCount * 1000 / (currentTime - lastTime)
            }
            frameCount = 0
            lastTime = currentTime
        }
    }
    
    function tick() {
        frameCount++
    }
}