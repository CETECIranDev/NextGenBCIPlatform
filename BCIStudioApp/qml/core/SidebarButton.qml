import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: button
    width: parent.width
    height: 40
    color: selected ? theme.primary : (hovered ? "#200d8bfd" : "transparent")
    // به جای Qt.rgba از hex ساده استفاده کردیم

    property string icon: "❓"
    property string text: "Button"
    property bool collapsed: false
    property bool selected: false
    property int badge: 0

    signal clicked()

    property bool hovered: false

    Row {
        anchors.centerIn: parent
        spacing: collapsed ? 0 : 12

        // آیکون
        Text {
            text: icon
            font.pixelSize: collapsed ? 14 : 16
            anchors.verticalCenter: parent.verticalCenter
            color: selected ? "white" : theme.textPrimary
        }

        // متن
        Text {
            text: button.text
            color: selected ? "white" : theme.textPrimary
            font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
            visible: !collapsed
        }

        // بدج
        Rectangle {
            width: 18
            height: 18
            radius: 9
            color: "#ff4757"
            visible: badge > 0 && !collapsed
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: badge > 9 ? "9+" : badge
                color: "white"
                font.pixelSize: 9
                font.bold: true
                anchors.centerIn: parent
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        onEntered: hovered = true
        onExited: hovered = false
        onClicked: button.clicked()
    }

    ToolTip.visible: collapsed && hovered
    ToolTip.text: text
    ToolTip.delay: 300
}
