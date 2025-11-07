import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: categoryTab
    width: 100
    height: 40
    radius: 20
    
    property var categoryData: ({})
    property bool isSelected: false
    property int widgetCount: 0
    
    signal clicked()
    
    color: isSelected ? categoryData.color : "transparent"
    border.color: isSelected ? categoryData.color : theme.border
    border.width: 1
    
    RowLayout {
        anchors.centerIn: parent
        anchors.margins: 12
        spacing: 8
        
        Text {
            text: categoryData.icon
            font.pixelSize: 14
            color: isSelected ? "white" : theme.textSecondary
        }
        
        Text {
            text: categoryData.name
            color: isSelected ? "white" : theme.textPrimary
            font.bold: true
            font.pixelSize: 12
        }
        
        Rectangle {
            visible: widgetCount > 0 && !isSelected
            width: 18
            height: 18
            radius: 9
            color: categoryData.color
            
            Text {
                anchors.centerIn: parent
                text: widgetCount
                color: "white"
                font.bold: true
                font.pixelSize: 9
            }
        }
    }
    
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: categoryTab.clicked()
    }
}
