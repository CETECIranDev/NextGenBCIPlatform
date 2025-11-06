import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    id: stepIndicator
    
    property int stepNumber: 1
    property string stepText: ""
    property bool isActive: false
    property bool isCurrent: false
    
    width: parent.width
    height: 60
    
    RowLayout {
        anchors.fill: parent
        spacing: 10
        
        // شماره step
        Rectangle {
            width: 30
            height: 30
            radius: 15
            color: isCurrent ? primaryColor : (isActive ? "#444444" : "#2A2A2A")
            border.color: isActive ? primaryColor : "#666666"
            border.width: 2
            
            Text {
                anchors.centerIn: parent
                text: stepNumber
                font.family: robotoBold.name
                font.pixelSize: 12
                color: isActive ? "white" : "#888888"
            }
        }
        
        // متن step
        Text {
            text: stepText
            font.family: isCurrent ? robotoBold.name : robotoRegular.name
            font.pixelSize: 14
            color: isActive ? "white" : "#888888"
            Layout.fillWidth: true
        }
        
        // خط جداکننده
        Rectangle {
            Layout.fillWidth: true
            height: 2
            color: isActive ? primaryColor : "#444444"
            visible: stepNumber < 3
        }
    }
}

