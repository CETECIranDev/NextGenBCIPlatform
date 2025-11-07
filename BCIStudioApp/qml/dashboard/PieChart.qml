import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects  // برای Qt 6
// PieChart.qml
Canvas {
    id: pieChart

    property var data: []

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        
        var centerX = width / 2
        var centerY = height / 2
        var radius = Math.min(width, height) / 2 - 5
        
        var total = data.reduce((sum, item) => sum + item.value, 0)
        var startAngle = 0
        
        // Draw pie segments
        for (var i = 0; i < data.length; i++) {
            var segment = data[i]
            var angle = (segment.value / total) * Math.PI * 2
            
            ctx.fillStyle = segment.color
            ctx.beginPath()
            ctx.moveTo(centerX, centerY)
            ctx.arc(centerX, centerY, radius, startAngle, startAngle + angle)
            ctx.closePath()
            ctx.fill()
            
            startAngle += angle
        }
        
        // Draw center circle
        ctx.fillStyle = theme.backgroundCard
        ctx.beginPath()
        ctx.arc(centerX, centerY, radius * 0.6, 0, Math.PI * 2)
        ctx.fill()
    }
    
    onDataChanged: requestPaint()
}