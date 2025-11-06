import QtQuick
import QtQuick.Controls

Slider {
    id: control
    property color grooveColor: appTheme.backgroundSecondary
    property color handleColor: appTheme.primaryColor
    property color progressColor: appTheme.primaryColor

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: control.grooveColor

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: control.progressColor
            radius: 2
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 20
        implicitHeight: 20
        radius: 10
        color: control.handleColor
        border.color: Qt.darker(control.handleColor, 1.2)
        border.width: 2
    }
}