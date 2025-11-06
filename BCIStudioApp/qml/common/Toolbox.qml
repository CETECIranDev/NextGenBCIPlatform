import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: toolbox
    color: appTheme.backgroundSecondary
    border.color: appTheme.border
    border.width: 1

    property string title: "Toolbox"
    property alias content: contentLayout.data
    property bool collapsed: false

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            id: header
            Layout.fillWidth: true
            height: 40
            color: appTheme.backgroundPrimary

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12

                Label {
                    text: toolbox.title
                    font.bold: true
                    color: appTheme.textPrimary
                    Layout.fillWidth: true
                }

                Button {
                    text: toolbox.collapsed ? "▶" : "▼"
                    flat: true
                    onClicked: toolbox.collapsed = !toolbox.collapsed
                }
            }
        }

        // Content
        ColumnLayout {
            id: contentLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 8
            spacing: 6
            visible: !toolbox.collapsed
        }
    }
}