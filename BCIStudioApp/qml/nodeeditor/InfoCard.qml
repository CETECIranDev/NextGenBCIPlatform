import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: infoCard
    property string title: ""
    property string icon: ""
    property string value: "0"
    property string description: ""
    property color cardColor: appTheme.primary

    height: 60
    radius: 8
    color: Qt.rgba(appTheme.backgroundTertiary.r, appTheme.backgroundTertiary.g, appTheme.backgroundTertiary.b, 0.8)

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // Icon
        Rectangle {
            width: 32
            height: 32
            radius: 6
            color: infoCard.cardColor
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: infoCard.icon
                font.pixelSize: 14
                color: "white"
                anchors.centerIn: parent
            }
        }

        // Content
        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter

            RowLayout {
                spacing: 6
                Layout.fillWidth: true

                Text {
                    text: infoCard.title
                    color: appTheme.textSecondary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    font.weight: Font.Medium
                    font.letterSpacing: 1
                }

                Text {
                    text: infoCard.value
                    color: appTheme.textPrimary
                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    Layout.alignment: Qt.AlignRight
                }
            }

            Text {
                text: infoCard.description
                color: appTheme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 10
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }
    }
}
