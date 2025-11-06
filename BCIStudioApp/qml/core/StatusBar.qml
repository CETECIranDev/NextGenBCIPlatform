import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
Rectangle {
    id: statusBar
    height: 30
    color: appTheme.backgroundSecondary
    border.color: appTheme.border
    border.width: 1

    RowLayout {
        anchors.fill: parent
        spacing: 20

        Text {
            text: "✅ Ready"
            color: appTheme.success
            font.pixelSize: 12
            Layout.leftMargin: 15
        }

        Item { Layout.fillWidth: true }

        Text {
            text: "Device: Simulated • FPS: 60 • Memory: 245 MB"
            color: appTheme.textSecondary
            font.pixelSize: 11
            Layout.rightMargin: 15
        }
    }
}
