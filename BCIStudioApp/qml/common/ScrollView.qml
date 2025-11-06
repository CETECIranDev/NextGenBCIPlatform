import QtQuick
import QtQuick.Controls

ScrollView {
    id: control
    property color scrollBarColor: appTheme.backgroundSecondary
    property color scrollBarHandleColor: appTheme.primaryColor

    ScrollBar.vertical: ScrollBar {
        parent: control
        x: control.mirrored ? 0 : control.width - width
        y: control.topPadding
        height: control.availableHeight
        active: control.ScrollBar.horizontal.active
        
        contentItem: Rectangle {
            implicitWidth: 6
            radius: 3
            color: control.scrollBarHandleColor
            opacity: 0.7
        }
        
        background: Rectangle {
            implicitWidth: 6
            color: control.scrollBarColor
            opacity: 0.3
        }
    }

    ScrollBar.horizontal: ScrollBar {
        parent: control
        x: control.leftPadding
        y: control.height - height
        width: control.availableWidth
        active: control.ScrollBar.vertical.active
        
        contentItem: Rectangle {
            implicitHeight: 6
            radius: 3
            color: control.scrollBarHandleColor
            opacity: 0.7
        }
        
        background: Rectangle {
            implicitHeight: 6
            color: control.scrollBarColor
            opacity: 0.3
        }
    }
}