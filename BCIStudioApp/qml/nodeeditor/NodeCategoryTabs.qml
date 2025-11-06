import QtQuick 2.15
import QtQuick.Controls 2.15

TabBar {
    id: categoryTabs
    
    property var categories: []
    signal categorySelected(string category)
    
    background: Rectangle {
        color: appTheme.backgroundTertiary
    }
    
    Repeater {
        model: categoryTabs.categories
        
        delegate: TabButton {
            text: modelData
            padding: 10
            
            background: Rectangle {
                color: categoryTabs.currentIndex === index ? 
                       appTheme.primary : "transparent"
                radius: 4
            }
            
            contentItem: Text {
                text: parent.text
                color: categoryTabs.currentIndex === index ? 
                       "white" : appTheme.textPrimary
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.bold: categoryTabs.currentIndex === index
            }
            
            onClicked: {
                categoryTabs.categorySelected(modelData)
            }
        }
    }
}