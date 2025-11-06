// DashboardHeaderCard.qml
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: headerCard

    property string title: ""
    property string subtitle: ""
    property string icon: ""
    property var headerGradient: theme.primaryGradient
    property int elevation: 2

    implicitWidth: 400
    implicitHeight: 100

    // Background with gradient
    Rectangle {
        id: bgRect
        anchors.fill: parent
        radius: 20

        gradient: Gradient {
            GradientStop { position: 0.0; color: headerGradient.stops[0].color }
            GradientStop { position: 1.0; color: headerGradient.stops[1].color }
        }

        layer.enabled: elevation > 0
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: elevation
            radius: elevation * 3
            samples: (elevation * 3) * 2 + 1
            color: "#40000000"
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 25
        spacing: 20

        Text {
            text: icon
            font.pixelSize: 32
            color: "white"
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 8

            Text {
                text: title
                color: "white"
                font.bold: true
                font.pixelSize: 24
                font.family: "Segoe UI, Roboto, sans-serif"
                Layout.fillWidth: true
            }

            Text {
                text: subtitle
                color: Qt.rgba(1, 1, 1, 0.8)
                font.pixelSize: 16
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
        }
    }
}
