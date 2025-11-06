import QtQuick

Rectangle {
    id: statusBadge
    
    property string text: ""
    //property color color: "#00C853"
    
    height: 20
    radius: 10
    color: Qt.lighter(statusBadge.color, 1.8)
    border.color: statusBadge.color
    border.width: 1

    Text {
        text: statusBadge.text
        color: statusBadge.color
        font.bold: true
        font.pixelSize: 9
        font.family: "Segoe UI"
        anchors.centerIn: parent
    }
}
