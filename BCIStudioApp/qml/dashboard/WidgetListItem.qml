// WidgetListItem.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects


Rectangle {
    id: widgetListItem
    height: 70
    radius: 12
    color: mouseArea.containsMouse ? theme.backgroundLighter : theme.backgroundLight
    border.color: theme.border
    border.width: 1

    property var widgetData: ({})
    signal addClicked()

    // Hover effect
    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: widgetListItem
                scale: 1.02
            }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "scale, color"; duration: 200 }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 12

        // Widget Icon
        Rectangle {
            id: iconContainer
            width: 44
            height: 44
            radius: 10
            color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)
            border.color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.3)
            border.width: 1
            Layout.alignment: Qt.AlignVCenter

            Text {
                anchors.centerIn: parent
                text: widgetData.icon || "📊"
                font.pixelSize: 18
                color: theme.primary
            }
        }

        // Widget Info
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 4

            Text {
                text: widgetData.name || "Unnamed Widget"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 14
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: widgetData.description || "No description available"
                color: theme.textSecondary
                font.pixelSize: 11
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            // Category tag
            Rectangle {
                height: 16
                radius: 8
                color: getCategoryColor(widgetData.category)
                Layout.alignment: Qt.AlignLeft

                Text {
                    anchors.centerIn: parent
                    text: getCategoryName(widgetData.category)
                    color: "white"
                    font.bold: true
                    font.pixelSize: 9
                    padding: 6
                }
            }
        }

        // Add Button
        Rectangle {
            id: addButton
            width: 36
            height: 36
            radius: 8
            color: addButtonMouseArea.containsMouse ? theme.primary : Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)
            border.color: theme.primary
            border.width: 1
            Layout.alignment: Qt.AlignVCenter

            Text {
                anchors.centerIn: parent
                text: "➕"
                font.pixelSize: 14
                color: addButtonMouseArea.containsMouse ? "white" : theme.primary
            }

            MouseArea {
                id: addButtonMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    widgetListItem.addClicked()
                    
                    // Click feedback
                    addButton.scale = 0.8
                    addButtonAnimation.start()
                }
            }

            SequentialAnimation {
                id: addButtonAnimation
                NumberAnimation {
                    target: addButton
                    property: "scale"
                    to: 1.0
                    duration: 200
                    easing.type: Easing.OutBack
                }
            }
        }
    }

    // Main mouse area for the whole item
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: widgetListItem.addClicked()
    }

    // Tooltip with detailed info
    ToolTip {
        id: widgetTooltip
        delay: 500
        visible: mouseArea.containsMouse

        contentItem: ColumnLayout {
            spacing: 8
            width: 200

            Text {
                text: widgetData.icon + " " + widgetData.name
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 14
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.divider
            }

            Text {
                text: widgetData.description || "A dashboard widget for monitoring and visualization."
                color: theme.textSecondary
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            GridLayout {
                columns: 2
                columnSpacing: 15
                rowSpacing: 6
                Layout.fillWidth: true

                Text { text: "Category:"; color: theme.textSecondary; font.pixelSize: 11 }
                Text { 
                    text: getCategoryName(widgetData.category); 
                    color: getCategoryColor(widgetData.category); 
                    font.bold: true;
                    font.pixelSize: 11 
                }

                Text { text: "Size:"; color: theme.textSecondary; font.pixelSize: 11 }
                Text { 
                    text: (widgetData.columnSpan || 1) + " column" + ((widgetData.columnSpan || 1) > 1 ? "s" : ""); 
                    color: theme.textPrimary; 
                    font.pixelSize: 11 
                }

                Text { text: "Type:"; color: theme.textSecondary; font.pixelSize: 11 }
                Text { 
                    text: getWidgetType(widgetData.category); 
                    color: theme.textPrimary; 
                    font.pixelSize: 11 
                }
            }
        }
    }

    // Helper functions
    function getCategoryColor(category) {
        switch(category) {
            case "visualization": return "#4CAF50"
            case "analysis": return "#FF9800"
            case "monitoring": return "#9C27B0"
            case "system": return "#607D8B"
            case "output": return "#FF4081"
            default: return theme.primary
        }
    }

    function getCategoryName(category) {
        switch(category) {
            case "visualization": return "Visualization"
            case "analysis": return "Analysis"
            case "monitoring": return "Monitoring"
            case "system": return "System"
            case "output": return "Output"
            default: return "General"
        }
    }

    function getWidgetType(category) {
        switch(category) {
            case "visualization": return "Chart & Graph"
            case "analysis": return "Data Analysis"
            case "monitoring": return "Real-time Monitor"
            case "system": return "System Status"
            case "output": return "BCI Output"
            default: return "General Widget"
        }
    }
}
