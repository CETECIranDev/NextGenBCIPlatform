import QtQuick
import QtQuick.Controls

RadioButton {
    id: control
    property color backgroundColor: appTheme.backgroundPrimary
    property color borderColor: appTheme.border
    property color dotColor: appTheme.primaryColor

    indicator: Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 10
        border.color: control.borderColor
        border.width: 2
        color: control.backgroundColor

        Rectangle {
            width: 10
            height: 10
            x: 5
            y: 5
            radius: 5
            color: control.dotColor
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