import QtQuick 2.15
import QtQuick.Controls 2.15

Canvas {
    id: connectionItem
    width: parent.width
    height: parent.height
    
    property var connectionModel: null
    property bool isSelected: false
    property point startPoint: Qt.point(0, 0)
    property point endPoint: Qt.point(0, 0)
    property bool isTemp: false
    
    signal selected()
    signal deleted()

    onPaint: {
        var ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)
        
        if (!connectionModel && !isTemp) return
        
        ctx.strokeStyle = isSelected ? appTheme.accent : appTheme.primary
        ctx.lineWidth = isSelected ? 3 : 2
        ctx.globalAlpha = isTemp ? 0.6 : 1.0
        
        if (isTemp) {
            ctx.setLineDash([5, 5])
        } else {
            ctx.setLineDash([])
        }
        
        var cp1 = Qt.point(startPoint.x + 100, startPoint.y)
        var cp2 = Qt.point(endPoint.x - 100, endPoint.y)
        
        ctx.beginPath()
        ctx.moveTo(startPoint.x, startPoint.y)
        ctx.bezierCurveTo(cp1.x, cp1.y, cp2.x, cp2.y, endPoint.x, endPoint.y)
        ctx.stroke()
        
        // رسم arrow head
        if (!isTemp) {
            drawArrowHead(ctx, endPoint, startPoint)
        }
    }
    
    function drawArrowHead(ctx, point, fromPoint) {
        var angle = Math.atan2(point.y - fromPoint.y, point.x - fromPoint.x)
        var arrowLength = 10
        var arrowWidth = 6
        
        ctx.fillStyle = isSelected ? appTheme.accent : appTheme.primary
        
        ctx.beginPath()
        ctx.moveTo(point.x, point.y)
        ctx.lineTo(
            point.x - arrowLength * Math.cos(angle) - arrowWidth * Math.sin(angle),
            point.y - arrowLength * Math.sin(angle) + arrowWidth * Math.cos(angle)
        )
        ctx.lineTo(
            point.x - arrowLength * Math.cos(angle) + arrowWidth * Math.sin(angle),
            point.y - arrowLength * Math.sin(angle) - arrowWidth * Math.cos(angle)
        )
        ctx.closePath()
        ctx.fill()
    }
    
    function updatePoints(newStart, newEnd) {
        startPoint = newStart
        endPoint = newEnd
        requestPaint()
    }
    
    // Hit testing برای انتخاب
    function containsPoint(point) {
        // محاسبه فاصله از منحنی بیزیه
        var tolerance = 8
        
        for (var t = 0; t <= 1; t += 0.05) {
            var curvePoint = getBezierPoint(t)
            var dx = point.x - curvePoint.x
            var dy = point.y - curvePoint.y
            var distance = Math.sqrt(dx * dx + dy * dy)
            
            if (distance <= tolerance) {
                return true
            }
        }
        return false
    }
    
    function getBezierPoint(t) {
        var cp1 = Qt.point(startPoint.x + 100, startPoint.y)
        var cp2 = Qt.point(endPoint.x - 100, endPoint.y)
        
        var x = Math.pow(1 - t, 3) * startPoint.x +
                3 * Math.pow(1 - t, 2) * t * cp1.x +
                3 * (1 - t) * Math.pow(t, 2) * cp2.x +
                Math.pow(t, 3) * endPoint.x
        
        var y = Math.pow(1 - t, 3) * startPoint.y +
                3 * Math.pow(1 - t, 2) * t * cp1.y +
                3 * (1 - t) * Math.pow(t, 2) * cp2.y +
                Math.pow(t, 3) * endPoint.y
        
        return Qt.point(x, y)
    }
    
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        
        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                connectionItem.selected()
            } else if (mouse.button === Qt.RightButton) {
                connectionContextMenu.open(mouse)
            }
        }
    }
    
    Menu {
        id: connectionContextMenu
        
        MenuItem {
            text: "Delete Connection"
            onTriggered: connectionItem.deleted()
        }
    }
}