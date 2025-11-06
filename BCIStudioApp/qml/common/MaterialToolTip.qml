import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    id: tooltip
    
    property string text: ""
    property int delay: 1000
    property int timeout: 3000
    
    visible: false
    z: 1000
    
    // Timer for show delay
    Timer {
        id: showTimer
        interval: tooltip.delay
        onTriggered: tooltip.visible = true
    }
    
    // Timer for auto hide
    Timer {
        id: hideTimer
        interval: tooltip.timeout
        onTriggered: tooltip.visible = false
    }
    
    Rectangle {
        id: tooltipBackground
        width: tooltipText.contentWidth + 20
        height: tooltipText.contentHeight + 12
        radius: 6
        color: "#E0E0E0"
        opacity: 0.95
        
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 2
            radius: 8
            samples: 17
            color: "#40000000"
        }
        
        Text {
            id: tooltipText
            text: tooltip.text
            color: "#212121"
            font.pixelSize: 12
            font.bold: true
            anchors.centerIn: parent
        }
    }
    
    function show() {
        showTimer.start()
        hideTimer.start()
    }
    
    function hide() {
        showTimer.stop()
        hideTimer.stop()
        visible = false
    }
    
    onVisibleChanged: {
        if (visible) {
            hideTimer.restart()
        }
    }
}
