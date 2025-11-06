import QtQuick
import QtQuick.Controls

TextField {
    id: control
    property color backgroundColor: appTheme.backgroundPrimary
    property color borderColor: appTheme.border
    property color textColor: appTheme.textPrimary
    property color placeholderColor: appTheme.textSecondary

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 40
        border.color: control.activeFocus ? appTheme.primaryColor : control.borderColor
        border.width: control.activeFocus ? 2 : 1
        color: control.backgroundColor
        radius: 6
    }

    color: control.textColor
    placeholderTextColor: control.placeholderColor
    selectByMouse: true
    selectionColor: appTheme.primaryColor
    selectedTextColor: "white"
}