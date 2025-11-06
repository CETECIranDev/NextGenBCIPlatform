import QtQuick
import QtQuick.Controls

CheckBox {
    id: control
    property color backgroundColor: appTheme.backgroundPrimary
    property color borderColor: appTheme.border
    property color checkColor: appTheme.primaryColor

    indicator: Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 4
        border.color: control.borderColor
        border.width: 2
        color: control.backgroundColor

        Rectangle {
            width: 12
            height: 12
            x: 4
            y: 4
            radius: 2
            color: control.checkColor
            visible: control.checked
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