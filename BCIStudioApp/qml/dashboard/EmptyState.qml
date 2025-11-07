import QtQuick
import QtQuick.Layouts

Item {
    id: emptyState
    height: 160
    
    property string searchText: ""
    property string currentCategory: "all"
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 16
        
        Text {
            text: "📊"
            font.pixelSize: 48
            opacity: 0.3
            Layout.alignment: Qt.AlignHCenter
        }
        
        ColumnLayout {
            spacing: 6
            Layout.alignment: Qt.AlignHCenter
            
            Text {
                text: searchText ? "No results found" : "No widgets available"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
            }
            
            Text {
                text: searchText ? 
                      "Try adjusting your search terms" :
                      currentCategory === "all" ? 
                      "All widgets are currently added" :
                      `No ${getCategoryName(currentCategory)} widgets available`
                color: theme.textSecondary
                font.pixelSize: 13
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
    
    function getCategoryName(category) {
        var names = {
            "visualization": "visualization",
            "analysis": "analysis",
            "monitoring": "monitoring", 
            "system": "system",
            "output": "output"
        }
        return names[category] || category
    }
}