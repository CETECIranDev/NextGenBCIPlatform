// SuccessToast.qml
import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Rectangle {
    id: toast
    width: 300
    height: 50
    radius: 25
    color: "#4CAF50"
    opacity: 0
    visible: false
    
    property string message: ""
    property int duration: 2000
    
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50
    
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 4
        radius: 12
        samples: 17
        color: "#40000000"
    }
    
    Text {
        anchors.centerIn: parent
        text: toast.message
        color: "white"
        font.bold: true
        font.pixelSize: 14
    }
    
    function show() {
        toast.visible = true
        showAnimation.start()
    }
    
    function hide() {
        hideAnimation.start()
    }
    
    SequentialAnimation {
        id: showAnimation
        NumberAnimation {
            target: toast
            property: "opacity"
            from: 0
            to: 1
            duration: 300
        }
        PauseAnimation { duration: toast.duration }
        NumberAnimation {
            target: toast
            property: "opacity"
            from: 1
            to: 0
            duration: 300
        }
        PropertyAction { target: toast; property: "visible"; value: false }
    }
    
    SequentialAnimation {
        id: hideAnimation
        NumberAnimation {
            target: toast
            property: "opacity"
            from: 1
            to: 0
            duration: 300
        }
        PropertyAction { target: toast; property: "visible"; value: false }
    }
}
