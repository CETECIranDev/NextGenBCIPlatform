import QtQuick
import QtQuick.Layouts

Item {
    id: statusItem
    width: 200
    height: 36

    property string label: ""
    property string value: ""
    property string status: "success"
    property string icon: ""
    property int appearDelay: 0

    opacity: 0

    Row {
        anchors.fill: parent
        spacing: 8

        Text {
            text: icon
            font.pixelSize: 14
            color: getStatusColor()
            anchors.verticalCenter: parent.verticalCenter
        }

        Column {
            width: parent.width - 30
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2

            Text {
                text: label
                font.pixelSize: 9
                font.weight: Font.Medium
                color: "#8899AA"
            }

            Text {
                text: value
                font.pixelSize: 13
                font.weight: Font.Bold
                color: getStatusColor()
            }
        }

        Rectangle {
            width: 6
            height: 6
            radius: 3
            color: getStatusColor()
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // انیمیشن ظاهر شدن با تاخیر
    Timer {
        running: true
        interval: appearDelay
        onTriggered: {
            appearAnimation.start()
        }
    }

    NumberAnimation {
        id: appearAnimation
        target: statusItem
        property: "opacity"
        from: 0
        to: 1
        duration: 800
        easing.type: Easing.OutCubic
    }

    function getStatusColor() {
        switch(status) {
            case "success": return "#00D4AA"
            case "warning": return "#FF9800"
            case "error": return "#F44336"
            case "processing": return "#00B8FF"
            default: return "#8899AA"
        }
    }
}
