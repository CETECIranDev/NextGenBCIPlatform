import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Popup {
    id: dialog
    modal: true
    dim: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property string title: "Dialog"
    property alias content: contentItem.data
    property alias buttons: buttonLayout.data

    background: Rectangle {
        radius: 8
        color: appTheme.backgroundPrimary
        border.color: appTheme.border
        border.width: 1
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Title
        Label {
            text: dialog.title
            font.bold: true
            font.pixelSize: 18
            color: appTheme.textPrimary
            Layout.topMargin: 16
            Layout.leftMargin: 16
            Layout.rightMargin: 16
        }

        // Content
        Item {
            id: contentItem
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 16
        }

        // Buttons
        RowLayout {
            id: buttonLayout
            Layout.fillWidth: true
            Layout.topMargin: 8
            Layout.bottomMargin: 16
            Layout.leftMargin: 16
            Layout.rightMargin: 16
            spacing: 8

            Button {
                text: "Cancel"
                flat: true
                onClicked: dialog.close()
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "OK"
                onClicked: dialog.close()
            }
        }
    }
}