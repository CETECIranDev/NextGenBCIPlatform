import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects  // برای Qt 6

Rectangle {
    id: gridItem
    
    property string character: "A"
    property bool isTarget: false
    property bool isFlashing: false
    property bool experimentRunning: false
    
    signal clicked(string character)

    radius: 8
    color: getBackgroundColor()
    border.color: getBorderColor()
    border.width: isTarget ? 3 : 1
    
    layer.enabled: isFlashing || isTarget
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 0
        radius: isFlashing ? 20 : 8
        samples: isFlashing ? 41 : 17
        color: isFlashing ? "#60FF6D00" : (isTarget ? "#607C4DFF" : "#20000000")
    }

    // Glow effect for target
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        border.color: "#7C4DFF"
        border.width: 2
        opacity: isTarget && experimentRunning ? 0.6 : 0
        visible: isTarget
        
        SequentialAnimation on opacity {
            running: isTarget && experimentRunning
            loops: Animation.Infinite
            NumberAnimation { from: 0.3; to: 0.8; duration: 1500 }
            NumberAnimation { from: 0.8; to: 0.3; duration: 1500 }
        }
    }

    Text {
        text: gridItem.character
        color: getTextColor()
        font.bold: true
        font.pixelSize: 18
        font.family: "Segoe UI"
        anchors.centerIn: parent
    }

    // Flash animation
    SequentialAnimation on scale {
        running: isFlashing
        NumberAnimation { from: 1.0; to: 1.1; duration: 50; easing.type: Easing.OutCubic }
        NumberAnimation { from: 1.1; to: 1.0; duration: 150; easing.type: Easing.OutCubic }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: gridItem.clicked(character)
    }

    function getBackgroundColor() {
        if (isFlashing) {
            return isTarget ? "#7C4DFF" : "#FF6D00"
        }
        return isTarget ? "#2A1B3D" : "#252540"
    }

    function getBorderColor() {
        if (isFlashing) return "white"
        return isTarget ? "#7C4DFF" : "#444466"
    }

    function getTextColor() {
        return isFlashing ? "white" : (isTarget ? "#7C4DFF" : "white")
    }
}
