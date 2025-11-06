import QtQuick
import QtQuick.Controls

Button {
    id: control
    property color backgroundColor: appTheme.primaryColor
    property color textColor: "white"
    property color borderColor: "transparent"
    property int borderRadius: 6

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        color: control.down ? Qt.darker(control.backgroundColor, 1.2) : 
               control.hovered ? Qt.lighter(control.backgroundColor, 1.1) : 
               control.backgroundColor
        border.color: control.borderColor
        border.width: 1
        radius: control.borderRadius
    }
}