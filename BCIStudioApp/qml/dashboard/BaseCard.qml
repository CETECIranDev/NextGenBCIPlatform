import QtQuick
import QtQuick.Controls

Frame {
    default property alias content: contentItem.children
    background: Rectangle { radius: 10; color: themeManager.surfaceDark; border.color: themeManager.secondary; border.width: 1 }
    padding: 12
    Item { id: contentItem; anchors.fill: parent }
}