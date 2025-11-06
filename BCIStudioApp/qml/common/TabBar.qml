import QtQuick
import QtQuick.Controls

TabBar {
    id: control
    property color backgroundColor: appTheme.backgroundSecondary
    property color borderColor: appTheme.border
    property color selectedColor: appTheme.primaryColor

    background: Rectangle {
        color: control.backgroundColor
        border.color: control.borderColor
        border.width: 1
    }

    contentItem: ListView {
        model: control.contentModel
        currentIndex: control.currentIndex
        spacing: 0
        orientation: ListView.Horizontal
        boundsBehavior: Flickable.StopAtBounds

        delegate: Item {
            width: Math.max(100, text.implicitWidth + 20)
            height: control.height

            Rectangle {
                anchors.fill: parent
                color: control.currentIndex === index ? control.selectedColor : "transparent"
            }

            Text {
                id: text
                text: modelData
                anchors.centerIn: parent
                color: control.currentIndex === index ? "white" : appTheme.textPrimary
                font.bold: control.currentIndex === index
            }

            MouseArea {
                anchors.fill: parent
                onClicked: control.currentIndex = index
            }
        }
    }
}