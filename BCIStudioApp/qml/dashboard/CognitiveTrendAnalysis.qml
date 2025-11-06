// CognitiveTrendAnalysis.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

Item {
    id: trendAnalysis
    width: 300
    height: 200

    property var history: []
    property string metric: "attention"
    property color lineColor: "#4CAF50"
    property int visiblePoints: 10

    Canvas {
        id: trendCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            if (history.length < 2) return

            var data = history.map(item => item[metric])
            var visibleData = data.slice(-visiblePoints)
            
            var maxVal = Math.max(...visibleData)
            var minVal = Math.min(...visibleData)
            var range = maxVal - minVal || 1

            var width = trendCanvas.width
            var height = trendCanvas.height
            var pointSpacing = width / (visibleData.length - 1)

            // Draw grid
            ctx.strokeStyle = theme.backgroundLight
            ctx.lineWidth = 1
            ctx.beginPath()
            for (var i = 0; i <= 4; i++) {
                var y = (height / 4) * i
                ctx.moveTo(0, y)
                ctx.lineTo(width, y)
            }
            ctx.stroke()

            // Draw trend line
            ctx.strokeStyle = lineColor
            ctx.lineWidth = 2
            ctx.beginPath()

            visibleData.forEach((value, index) => {
                var x = index * pointSpacing
                var y = height - ((value - minVal) / range) * height * 0.8 - height * 0.1

                if (index === 0) {
                    ctx.moveTo(x, y)
                } else {
                    ctx.lineTo(x, y)
                }
            })

            ctx.stroke()

            // Draw points
            ctx.fillStyle = lineColor
            visibleData.forEach((value, index) => {
                var x = index * pointSpacing
                var y = height - ((value - minVal) / range) * height * 0.8 - height * 0.1
                
                ctx.beginPath()
                ctx.arc(x, y, 3, 0, Math.PI * 2)
                ctx.fill()
            })
        }
    }

    onHistoryChanged: trendCanvas.requestPaint()
}