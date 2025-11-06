import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: toolTip
    padding: 8
    margins: 0
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property alias text: toolTipText.text

    background: Rectangle {
        color: appTheme.backgroundElevated
        radius: 4
        border.color: appTheme.border
        border.width: 1

        // سایه
        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            color: "#40000000"
            radius: 8
            samples: 16
        }
    }

    contentItem: Text {
        id: toolTipText
        text: toolTip.text
        color: appTheme.textPrimary
        font.pixelSize: 11
        wrapMode: Text.Wrap
    }

    // موقعیت‌دهی خودکار
    function show(item, x, y) {
        var pos = item.mapToItem(null, x, y)
        toolTip.x = pos.x + 10
        toolTip.y = pos.y + 10
        toolTip.open()
    }
}