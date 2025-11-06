import QtQuick
import QtQuick.Controls

Switch {
    id: control
    property color trackColor: appTheme.backgroundSecondary
    property color handleColor: appTheme.primaryColor
    property color checkedTrackColor: Qt.lighter(appTheme.primaryColor, 1.3)

    indicator: Rectangle {
        implicitWidth: 48
        implicitHeight: 24
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 12
        color: control.checked ? control.checkedTrackColor : control.trackColor
        border.color: control.checked ? Qt.darker(control.checkedTrackColor, 1.2) : Qt.darker(control.trackColor, 1.2)

        Rectangle {
            x: control.checked ? parent.width - width - 2 : 2
            y: 2
            width: 20
            height: 20
            radius: 10
            color: control.handleColor
            border.color: Qt.darker(control.handleColor, 1.2)

            Behavior on x {
                NumberAnimation { duration: 200 }
            }
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: appTheme.textPrimary
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}