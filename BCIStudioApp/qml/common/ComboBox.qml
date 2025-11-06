import QtQuick
import QtQuick.Controls

ComboBox {
    id: control
    property color backgroundColor: appTheme.backgroundPrimary
    property color borderColor: appTheme.border
    property color textColor: appTheme.textPrimary

    delegate: ItemDelegate {
        width: control.width
        contentItem: Text {
            text: modelData
            color: appTheme.textPrimary
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        background: Rectangle {
            color: highlighted ? appTheme.backgroundSecondary : "transparent"
        }
    }

    indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
            target: control
            function onPressedChanged() { canvas.requestPaint() }
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = control.pressed ? Qt.darker(appTheme.textPrimary, 1.2) : appTheme.textPrimary;
            context.fill();
        }
    }

    contentItem: Text {
        leftPadding: 10
        rightPadding: control.indicator.width + control.spacing
        text: control.displayText
        font: control.font
        color: control.textColor
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 140
        implicitHeight: 40
        border.color: control.borderColor
        border.width: control.visualFocus ? 2 : 1
        color: control.backgroundColor
        radius: 6
    }

    popup: Popup {
        y: control.height - 1
        width: control.width
        implicitHeight: contentItem.implicitHeight
        padding: 1

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            border.color: appTheme.border
            radius: 6
            color: appTheme.backgroundPrimary
        }
    }
}