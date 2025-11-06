import QtQuick 2.15

Column {
    spacing: 2

    property string label: "CPU"
    property string value: "0%"
    property color color: appTheme.primary

    Text {
        text: parent.label
        color: appTheme.textTertiary
        font.pixelSize: 9
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        text: parent.value
        color: parent.color
        font.pixelSize: 10
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
    }
}