import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

SplitView {
    id: control
    property color handleColor: appTheme.border
    property color handleHoverColor: appTheme.primaryColor

    handle: Rectangle {
        implicitWidth: 4
        implicitHeight: 4
        color: SplitHandle.hovered ? control.handleHoverColor : control.handleColor
        
        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }
}