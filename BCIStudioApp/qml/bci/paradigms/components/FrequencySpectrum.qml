import QtQuick
import QtQuick.Layouts

// Frequency Spectrum Visualizer
Item {
    id: frequencySpectrum
    
    property var frequencies: [8, 10, 12, 14]
    property real activeFrequency: 0
    property bool isRunning: false
    
    Canvas {
        anchors.fill: parent
        
        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            var centerX = width / 2
            var centerY = height / 2
            var maxRadius = Math.min(centerX, centerY) - 20
            
            // Draw frequency circles
            for (var i = 0; i < frequencies.length; i++) {
                var freq = frequencies[i]
                var radius = maxRadius * (0.2 + 0.6 * (i / (frequencies.length - 1)))
                
                ctx.strokeStyle = freq === activeFrequency ? "#00BFA5" : "#B0BEC5"
                ctx.lineWidth = freq === activeFrequency ? 3 : 1
                ctx.beginPath()
                ctx.arc(centerX, centerY, radius, 0, Math.PI * 2)
                ctx.stroke()
                
                // Frequency label
                ctx.fillStyle = freq === activeFrequency ? "#00BFA5" : theme.textSecondary
                ctx.font = "bold 12px Segoe UI"
                ctx.textAlign = "center"
                ctx.fillText(freq + " Hz", centerX, centerY - radius - 10)
            }
            
            // Draw active frequency indicator
            if (activeFrequency > 0 && isRunning) {
                var activeIndex = frequencies.indexOf(activeFrequency)
                var activeRadius = maxRadius * (0.2 + 0.6 * (activeIndex / (frequencies.length - 1)))
                
                ctx.fillStyle = "#4000BFA5"
                ctx.beginPath()
                ctx.arc(centerX, centerY, activeRadius, 0, Math.PI * 2)
                ctx.fill()
                
                // Pulsing effect
                ctx.strokeStyle = "#00BFA5"
                ctx.lineWidth = 2
                ctx.beginPath()
                ctx.arc(centerX, centerY, activeRadius + 5 * Math.sin(Date.now() / 200), 0, Math.PI * 2)
                ctx.stroke()
            }
        }
        
        Timer {
            interval: 50
            running: true
            repeat: true
            onTriggered: parent.requestPaint()
        }
    }
}
