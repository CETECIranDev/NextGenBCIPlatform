import QtQuick
import QtQuick.Controls
import QtQuick.Layouts


// EmptyDashboardState.qml
Rectangle {
    width: 400
    height: 300
    radius: 16
    color: Qt.rgba(theme.backgroundCard.r, theme.backgroundCard.g, theme.backgroundCard.b, 0.8)
    border.color: theme.border
    border.width: 1

    signal addWidgets()

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20

        Text {
            text: "📊"
            font.pixelSize: 48
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Dashboard is Empty"
            color: theme.textPrimary
            font.bold: true
            font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Add widgets to start monitoring your BCI system"
            color: theme.textSecondary
            font.pixelSize: 14
            Layout.alignment: Qt.AlignHCenter
        }

        Button {
            text: "➕ Add Widgets"
            Layout.alignment: Qt.AlignHCenter
            onClicked: addWidgets()

            background: Rectangle {
                radius: 8
                color: theme.primary
            }

            contentItem: Text {
                text: parent.text
                color: "white"
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
}
