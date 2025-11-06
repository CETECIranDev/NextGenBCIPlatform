import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Rectangle {
    id: categoryPill
    width: 100
    height: 60
    radius: 12

    property string categoryName: ""
    property string categoryIcon: ""
    property color categoryColor: appTheme.primary
    property bool isSelected: false
    property int nodeCount: 0

    signal clicked()

    color: isSelected ? categoryColor : appTheme.backgroundCard
    border.color: isSelected ? categoryColor : appTheme.border
    border.width: isSelected ? 2 : 1

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 4

        Text {
            text: categoryIcon
            font.pixelSize: 16
            color: isSelected ? "white" : categoryColor
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: categoryName
            color: isSelected ? "white" : appTheme.textPrimary
            font.family: "Segoe UI"
            font.pixelSize: 9
            font.weight: Font.Medium
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: nodeCount
            color: isSelected ? "white" : appTheme.textTertiary
            font.family: "Segoe UI"
            font.pixelSize: 8
            Layout.alignment: Qt.AlignHCenter
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: parent.clicked()
    }

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Behavior on border.color {
        ColorAnimation { duration: 200 }
    }
}

