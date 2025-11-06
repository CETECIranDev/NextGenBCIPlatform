// QuickStatCard.qml
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: statCard

    property string title: ""
    property string value: ""
    property string trend: ""
    property string icon: ""
    property color cardColor: theme.primary
    property int elevation: 2

    implicitWidth: 200
    implicitHeight: 120

    // Background Rectangle
    Rectangle {
        id: background
        anchors.fill: parent
        color: theme.backgroundCard
        radius: 16

        layer.enabled: elevation > 0
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: elevation
            radius: elevation * 2
            samples: (elevation * 2) * 2 + 1
            color: "#20000000"
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 8

        // Header row
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: icon
                font.pixelSize: 18
                color: statCard.cardColor
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                text: title
                color: theme.textSecondary
                font.pixelSize: 14
                font.bold: true
                Layout.fillWidth: true
            }
        }

        // Value
        Text {
            text: value
            color: statCard.cardColor
            font.bold: true
            font.pixelSize: 28
            font.family: "Segoe UI, Roboto, monospace"
            Layout.alignment: Qt.AlignLeft
        }

        // Trend
        Text {
            text: trend
            color: statCard.cardColor
            font.pixelSize: 12
            font.bold: true
            visible: trend !== ""
            Layout.alignment: Qt.AlignLeft
        }
    }
}
