import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    id: systemStatusMini
    height: 60
    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 4

        // وضعیت اتصال
        Row {
            spacing: 8
            Layout.fillWidth: true

            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: appTheme.success
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "Device Connected"
                color: appTheme.textSecondary
                font.pixelSize: 11
                anchors.verticalCenter: parent.verticalCenter
            }

            Item { width: 1; height: 1 }

            Text {
                text: "NeuroScan"
                color: appTheme.textPrimary
                font.pixelSize: 11
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // وضعیت سیستم
        Row {
            spacing: 15
            Layout.fillWidth: true

            StatusIndicatorMini {
                label: "CPU"
                value: "42%"
                color: appTheme.primary
            }

            StatusIndicatorMini {
                label: "MEM"
                value: "65%"
                color: appTheme.warning
            }

            StatusIndicatorMini {
                label: "SIG"
                value: "98%"
                color: appTheme.success
            }
        }
    }

    // خط جداکننده
    Rectangle {
        anchors.top: parent.top
        width: parent.width
        height: 1
        color: appTheme.border
        opacity: 0.3
    }
}
