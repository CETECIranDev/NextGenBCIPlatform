import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts


Rectangle {
    id: sidebarHeader
    height: 80
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 8

        // لوگو و عنوان
        Row {
            spacing: 12
            Layout.alignment: Qt.AlignHCenter

            // لوگو
            Rectangle {
                width: 40
                height: 40
                radius: 10
                gradient: Gradient {
                    GradientStop { position: 0.0; color: appTheme.primary }
                    GradientStop { position: 1.0; color: appTheme.secondary }
                }

                Text {
                    text: "🧠"
                    font.pixelSize: 18
                    anchors.centerIn: parent
                }
            }

            // عنوان
            Column {
                spacing: 2
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: "NEUROSTUDIO"
                    color: appTheme.textPrimary
                    font.pixelSize: 16
                    font.bold: true
                }

                Text {
                    text: "PRO"
                    color: appTheme.primary
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }

        // جستجوی سریع
        SearchField {
            Layout.fillWidth: true
            height: 32
            placeholderText: "Search commands..."
            onSearchRequested: (text) => {
                console.log("Searching for:", text)
                // پیاده‌سازی جستجو
            }
        }
    }

    // خط جداکننده
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: 1
        color: appTheme.border
        opacity: 0.3
    }
}
