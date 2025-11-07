import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Popup {
    id: widgetConfigPanel
    width: 420
    height: 640
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    padding: 0

    property var availableWidgets: []
    property string currentCategory: "all"
    property var _filteredWidgets: []

    signal widgetAdded(string widgetId)
    signal layoutReset()

    property var categories: [
        {id: "all", name: "All", icon: "📊", color: theme.primary},
        {id: "visualization", name: "Charts", icon: "📈", color: theme.secondary},
        {id: "analysis", name: "Analysis", icon: "🧠", color: theme.accent},
        {id: "monitoring", name: "Monitor", icon: "🔍", color: theme.info},
        {id: "system", name: "System", icon: "⚙️", color: theme.warning},
        {id: "output", name: "Output", icon: "🎯", color: theme.success}
    ]

    background: Rectangle {
        radius: 20
        color: theme.backgroundCard
        border.color: theme.glassBorder
        border.width: 1

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 8
            radius: 32
            samples: 41
            color: theme.shadow
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header - Compact و تمیز
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 80

            Rectangle {
                anchors.fill: parent
                color: theme.primary
                radius: 20

                LinearGradient {
                    anchors.fill: parent
                    start: Qt.point(0, 0)
                    end: Qt.point(width, height)
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: theme.primary }
                        GradientStop { position: 1.0; color: Qt.darker(theme.primary, 1.1) }
                    }
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15

                // Title Section
                ColumnLayout {
                    spacing: 4
                    Layout.fillWidth: true

                    Text {
                        text: "Add Widgets"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 20
                        font.family: "Segoe UI"
                    }

                    Text {
                        text: "Enhance your dashboard"
                        color: Qt.rgba(1, 1, 1, 0.8)
                        font.pixelSize: 13
                        font.family: "Segoe UI"
                    }
                }

                // Close Button
                Rectangle {
                    width: 32
                    height: 32
                    radius: 8
                    color: closeMouseArea.containsMouse ? Qt.rgba(1, 1, 1, 0.2) : "transparent"
                    border.color: Qt.rgba(1, 1, 1, 0.3)
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: "white"
                        font.pixelSize: 14
                        font.bold: true
                    }

                    MouseArea {
                        id: closeMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: closePanel()
                    }
                }
            }
        }

        // Search Box - Compact
        Rectangle {
            Layout.fillWidth: true
            Layout.topMargin: 20
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            height: 44
            radius: 12
            color: theme.backgroundLight
            border.color: theme.border
            border.width: 1

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                Text {
                    text: "🔍"
                    font.pixelSize: 16
                    color: theme.textSecondary
                    Layout.alignment: Qt.AlignVCenter
                }

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: "Search widgets..."
                    font.pixelSize: 14
                    font.family: "Segoe UI"
                    background: Rectangle {
                        color: "transparent"
                    }

                    onTextChanged: updateFilteredWidgets()
                }

                Rectangle {
                    width: 24
                    height: 24
                    radius: 6
                    color: clearSearchMouseArea.containsMouse ? theme.backgroundLighter : "transparent"
                    visible: searchField.text !== ""

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: theme.textSecondary
                        font.pixelSize: 12
                    }

                    MouseArea {
                        id: clearSearchMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            searchField.text = ""
                            updateFilteredWidgets()
                        }
                    }
                }
            }
        }

        // Category Tabs - Horizontal Scroll
        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            Layout.topMargin: 10

            ScrollView {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                clip: true
                ScrollBar.horizontal.policy: ScrollBar.AsNeeded

                Row {
                    height: parent.height
                    spacing: 8

                    Repeater {
                        model: categories

                        CategoryTab {
                            categoryData: modelData
                            isSelected: currentCategory === modelData.id
                            widgetCount: getWidgetCount(modelData.id)
                            onClicked: {
                                currentCategory = modelData.id
                                updateFilteredWidgets()
                            }
                        }
                    }
                }
            }
        }

        // Widgets Grid - طراحی Grid مدرن
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: 10
            Layout.leftMargin: 20
            Layout.rightMargin: 20
            Layout.bottomMargin: 10

            ScrollView {
                anchors.fill: parent
                clip: true

                Flow {
                    width: parent.width
                    spacing: 12

                    Repeater {
                        model: _filteredWidgets

                        WidgetCard {
                            width: (parent.width - 12) / 2
                            widgetData: modelData
                            onAddClicked: {
                                widgetAdded(modelData.id)
                                addAnimation.start()
                            }
                        }
                    }

                    // Empty State
                    EmptyState {
                        width: parent.width
                        visible: _filteredWidgets.length === 0
                        searchText: searchField.text
                        currentCategory: widgetConfigPanel.currentCategory
                    }
                }
            }
        }

        // Footer Actions - Minimal
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12

                // Reset Button
                SecondaryButton {
                    Layout.fillWidth: true
                    text: "Reset to Default"
                    icon: "🔄"
                    onClicked: {
                        layoutReset()
                        resetAnimation.start()
                    }
                }

                // Done Button
                PrimaryButton {
                    Layout.fillWidth: true
                    text: "Done"
                    icon: "✓"
                    onClicked: closePanel()
                }
            }
        }
    }

    // Animations
    SequentialAnimation {
        id: addAnimation
        PropertyAction { target: widgetConfigPanel; property: "scale"; value: 0.98 }
        NumberAnimation {
            target: widgetConfigPanel
            property: "scale"
            to: 1.0
            duration: 300
            easing.type: Easing.OutBack
        }
    }

    SequentialAnimation {
        id: resetAnimation
        PropertyAction { target: widgetConfigPanel; property: "opacity"; value: 0.7 }
        NumberAnimation {
            target: widgetConfigPanel
            property: "opacity"
            to: 1.0
            duration: 500
            easing.type: Easing.OutCubic
        }
    }

    // Functions
    function updateFilteredWidgets() {
        var filtered = []
        var searchTerm = searchField.text.toLowerCase()

        for (var i = 0; i < availableWidgets.length; i++) {
            var widget = availableWidgets[i]
            var categoryMatch = currentCategory === "all" || widget.category === currentCategory
            var searchMatch = searchTerm === "" ||
                            widget.name.toLowerCase().includes(searchTerm) ||
                            widget.description.toLowerCase().includes(searchTerm)

            if (categoryMatch && searchMatch) {
                filtered.push(widget)
            }
        }
        _filteredWidgets = filtered
    }

    function getWidgetCount(categoryId) {
        if (categoryId === "all") return availableWidgets.length
        var count = 0
        for (var i = 0; i < availableWidgets.length; i++) {
            if (availableWidgets[i].category === categoryId) count++
        }
        return count
    }

    function openPanel() {
        searchField.text = ""
        currentCategory = "all"
        updateFilteredWidgets()
        open()
    }

    function closePanel() {
        close()
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200 }
        NumberAnimation { property: "scale"; from: 0.9; to: 1; duration: 300; easing.type: Easing.OutBack }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 150 }
    }
}
