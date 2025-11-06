import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: categoryButton
    width: Math.max(80, buttonText.implicitWidth + 20)
    height: 30
    color: isSelected ? appTheme.primary : 
           mouseArea.containsMouse ? appTheme.backgroundCard : "transparent"
    radius: 4
    border.color: isSelected ? appTheme.primary : "transparent"
    border.width: 1

    property string text: ""
    property string icon: "📁"
    property bool isSelected: false

    signal clicked()

    Row {
        anchors.centerIn: parent
        spacing: 5

        Text {
            text: categoryButton.icon
            font.pixelSize: 12
        }

        Text {
            id: buttonText
            text: categoryButton.text
            color: isSelected ? "white" : appTheme.textPrimary
            font.pixelSize: 11
            font.bold: isSelected
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: categoryButton.clicked()
    }
}