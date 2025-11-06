import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    id: nodeSearchPanel
    color: "transparent"

    property var nodeRegistry
    property string selectedNodeType: ""
    property string currentCategory: "All"
    property string searchText: ""

    signal nodeSelected(string nodeType)
    signal nodeDragStarted(string nodeType, var mouse)

    function filterNodes(searchText) {
        nodeSearchPanel.searchText = searchText
        listView.model = nodeRegistry.searchNodes(searchText, currentCategory)
    }

    function filterByCategory(category) {
        currentCategory = category
        filterNodes(searchText)
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // آمار و اطلاعات
        Rectangle {
            Layout.fillWidth: true
            height: 30
            color: appTheme.backgroundTertiary

            Text {
                text: listView.count + " nodes available"
                color: appTheme.textSecondary
                font.pixelSize: 11
                anchors.centerIn: parent
            }
        }

        // لیست نودها
        ScrollView {
            id: scrollView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: listView
                model: nodeRegistry ? nodeRegistry.getNodesByCategory("All") : []
                spacing: 2
                boundsBehavior: Flickable.StopAtBounds

                delegate: NodeToolboxItem {
                    width: listView.width - 5
                    nodeType: modelData.type
                    nodeName: modelData.name
                    nodeCategory: modelData.category
                    nodeIcon: modelData.icon
                    description: modelData.description
                    tags: modelData.tags || []
                    isFavorite: modelData.favorite || false

                    isSelected: nodeSearchPanel.selectedNodeType === modelData.type

                    onClicked: {
                        nodeSearchPanel.selectedNodeType = modelData.type
                        nodeSearchPanel.nodeSelected(modelData.type)
                    }

                    onDragStarted: (mouse) => {
                        nodeSearchPanel.selectedNodeType = modelData.type
                        nodeSearchPanel.nodeDragStarted(modelData.type, mouse)
                    }

                    onFavoriteToggled: {
                        nodeRegistry.toggleFavorite(modelData.type)
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (nodeRegistry) {
            listView.model = nodeRegistry.getNodesByCategory("All")
        }
    }
}
