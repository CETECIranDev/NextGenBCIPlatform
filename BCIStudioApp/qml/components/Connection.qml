import QtQuick
import QtQuick.Shapes

Shape {
    property point startPoint
    property point endPoint
    property color connectionColor: "#007ACC" // primary color

    ShapePath {
        strokeWidth: 2
        strokeColor: parent.connectionColor
        fillColor: "transparent"
        capStyle: ShapePath.RoundCap

        startX: startPoint.x
        startY: startPoint.y

        // A smooth Bezier curve for a professional look
        PathCubic {
            x: endPoint.x; y: endPoint.y
            // Control points create the curve's shape
            control1X: startPoint.x + Math.abs(endPoint.x - startPoint.x) * 0.5
            control1Y: startPoint.y
            control2X: endPoint.x - Math.abs(endPoint.x - startPoint.x) * 0.5
            control2Y: endPoint.y
        }
    }
}
