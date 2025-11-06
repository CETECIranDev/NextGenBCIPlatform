import QtQuick 2.15

Rectangle {
    id: versionInfo
    height: 40
    color: "transparent"

    Row {
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: "v" + appController.appVersion
            color: appTheme.textTertiary
            font.pixelSize: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        Rectangle {
            width: 3
            height: 3
            radius: 1.5
            color: appTheme.textTertiary
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: "NeuroStudio Pro"
            color: appTheme.textTertiary
            font.pixelSize: 10
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}