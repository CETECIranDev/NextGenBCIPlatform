import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// NodeToolbox.qml - کامپوننت NodeToolboxItem را با این کد جایگزین کنید
Rectangle {
    property string nodeType: ""
    property string nodeName: ""
    property string nodeIcon: ""
    property string nodeDescription: ""
    property color nodeColor: "gray"
    property var theme: nodeToolbox.theme

    signal dragStarted(string nodeType, var mouse)

    width: parent.width
    height: 60
    color: mouseArea.containsMouse ? Qt.rgba(nodeColor.r, nodeColor.g, nodeColor.b, 0.1) : "transparent"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 10

        Rectangle {
            width: 36
            height: 36
            radius: 8
            color: nodeColor
            Layout.alignment: Qt.AlignVCenter

            Text {
                text: nodeIcon
                font.pixelSize: 16
                color: "white"
                anchors.centerIn: parent
            }
        }

        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true

            Text {
                text: nodeName
                color: theme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 12
                font.bold: true
                elide: Text.ElideRight
            }

            Text {
                text: nodeDescription
                color: theme.textSecondary
                font.family: "Segoe UI"
                font.pixelSize: 10
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
            }
        }
    }

    // سیستم Drag کاملاً ساده‌شده
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        drag.threshold: 1

        onPressed: (mouse) => {
            console.log("🖱️ Mouse pressed on node:", nodeType, "at:", mouse.x, mouse.y);

            // استفاده از موقعیت نسبی ساده
            var relativeMouse = {
                x: mouse.x,
                y: mouse.y,
                source: "toolbox"
            };

            parent.dragStarted(nodeType, relativeMouse);
        }

        onPositionChanged: (mouse) => {
            if (pressed) {
                // آپدیت موقعیت در حین درگ
                console.log("📍 Dragging at relative position:", mouse.x, mouse.y);
            }
        }

        onReleased: {
            console.log("🖱️ Mouse released");
        }
    }
}
