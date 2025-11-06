import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: categoryPanel
    height: 40
    color: appTheme.backgroundTertiary
    
    property var categories: []
    property string selectedCategory: "All"
    
    signal categorySelected(string category)

    ScrollView {
        anchors.fill: parent
        clip: true

        Row {
            height: parent.height
            spacing: 2
            padding: 5

            // دسته‌بندی "همه"
            CategoryButton {
                text: "All"
                icon: "🌟"
                isSelected: categoryPanel.selectedCategory === "All"
                onClicked: categoryPanel.categorySelected("All")
            }

            // دسته‌بندی‌های داینامیک
            Repeater {
                model: categoryPanel.categories

                delegate: CategoryButton {
                    text: modelData.name
                    icon: modelData.icon
                    isSelected: categoryPanel.selectedCategory === modelData.name
                    onClicked: categoryPanel.categorySelected(modelData.name)
                }
            }
        }
    }
}