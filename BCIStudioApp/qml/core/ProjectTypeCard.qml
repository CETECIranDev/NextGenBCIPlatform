import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3


Rectangle {
    id: projectTypeCard
    
    property string type: ""
    property string name: ""
    property string icon: ""
    property string description: ""
    property string category: ""
    property color color: "#7C4DFF"
    property bool isSelected: false
    
    signal clicked()
    
    width: parent.width
    height: 120
    
    Card {
        anchors.fill: parent
        border.color: isSelected ? color : "transparent"
        border.width: 2
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: projectTypeCard.clicked()
        }
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 15
            
            // آیکون
            Rectangle {
                width: 50
                height: 50
                radius: 25
                color: color
                
                Text {
                    anchors.centerIn: parent
                    text: icon
                    font.pixelSize: 20
                }
            }
            
            // محتوا
            ColumnLayout {
                spacing: 5
                Layout.fillWidth: true
                
                Text {
                    text: name
                    font.family: robotoBold.name
                    font.pixelSize: 16
                    color: "white"
                    Layout.fillWidth: true
                }
                
                Text {
                    text: description
                    font.family: robotoRegular.name
                    font.pixelSize: 12
                    color: "#AAAAAA"
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }
                
                // دسته‌بندی
                Rectangle {
                    width: contentWidth + 10
                    height: 20
                    radius: 10
                    color: Qt.darker(color, 1.5)
                    
                    Text {
                        anchors.centerIn: parent
                        text: category
                        font.family: robotoRegular.name
                        font.pixelSize: 10
                        color: "white"
                    }
                }
            }
            
            // نشانگر انتخاب
            Rectangle {
                width: 20
                height: 20
                radius: 10
                color: isSelected ? color : "transparent"
                border.color: isSelected ? color : "#666666"
                border.width: 2
                
                Text {
                    anchors.centerIn: parent
                    text: "✓"
                    font.pixelSize: 12
                    color: "white"
                    visible: isSelected
                }
            }
        }
    }
}

