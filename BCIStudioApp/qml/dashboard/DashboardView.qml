// DashboardView.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: dashboardRoot
    anchors.fill: parent

    // Properties
    property bool editMode: false
    property int currentColumns: calculateColumns()
    property real cardSpacing: 20
    property real headerHeight: 120

    // Default widgets layout
    property var defaultWidgets: [
        {id: "signalQuality", name: "Signal Quality Map", icon: "🗺️", category: "visualization", columnSpan: 2, visible: true, description: "Real-time EEG electrode quality monitoring"},
        {id: "cognitiveStates", name: "Signal Quality Map", icon: "🗺️", category: "visualization", columnSpan: 2, visible: true, description: "Real-time EEG electrode quality monitoring"},
        {id: "realTimeSpectrum", name: "Signal Quality Map", icon: "🗺️", category: "visualization", columnSpan: 2, visible: true, description: "Real-time EEG electrode quality monitoring"},
        {id: "performanceMetrics", name: "Signal Quality Map", icon: "🗺️", category: "visualization", columnSpan: 2, visible: true, description: "Real-time EEG electrode quality monitoring"},
        {id: "systemStatus", name: "System Status", icon: "🔌", category: "system", columnSpan: 1, visible: true, description: "BCI system hardware and connection status"},
        {id: "liveSignals", name: "EEG Signals", icon: "📈", category: "visualization", columnSpan: 1, visible: true, description: "Live EEG signal visualization and analysis"},
        {id: "cognitiveMetrics", name: "Cognitive Metrics", icon: "🧠", category: "analysis", columnSpan: 1, visible: true, description: "Real-time cognitive state analysis"},
        {id: "bciOutput", name: "BCI Output", icon: "🎯", category: "output", columnSpan: 1, visible: true, description: "Brain-computer interface command output"}
    ]

    property var availableWidgets: [
        {id: "systemStatus", name: "System Status", icon: "🔌", category: "system", columnSpan: 1, description: "BCI system hardware and connection status"},
        {id: "signalQuality", name: "Signal Quality Map", icon: "🗺️", category: "visualization", columnSpan: 2, description: "Real-time EEG electrode quality monitoring"},
        {id: "realTimeSpectrum", name: "Signal Quality Map", icon: "🗺️", category: "visualization", columnSpan: 2, visible: true, description: "Real-time EEG electrode quality monitoring"},
        {id: "cognitiveStates", name: "Signal Quality Map", icon: "🗺️", category: "visualization", columnSpan: 2, visible: true, description: "Real-time EEG electrode quality monitoring"},
        {id: "performanceMetrics", name: "Signal Quality Map", icon: "🗺️", category: "visualization", columnSpan: 2, visible: true, description: "Real-time EEG electrode quality monitoring"},
        {id: "liveSignals", name: "EEG Signals", icon: "📈", category: "visualization", columnSpan: 1, description: "Live EEG signal visualization and analysis"},
        {id: "cognitiveMetrics", name: "Cognitive Metrics", icon: "🧠", category: "analysis", columnSpan: 1, description: "Real-time cognitive state analysis"},
        {id: "spectrumAnalysis", name: "Spectrum Analysis", icon: "📊", category: "analysis", columnSpan: 1, description: "EEG frequency spectrum analysis"},
        {id: "performance", name: "Performance Metrics", icon: "⚡", category: "analysis", columnSpan: 1, description: "BCI system performance metrics"},
        {id: "eventLog", name: "Event Log", icon: "📝", category: "monitoring", columnSpan: 1, description: "System events and activity log"},
        {id: "bciOutput", name: "BCI Output", icon: "🎯", category: "output", columnSpan: 1, description: "Brain-computer interface command output"}
    ]

    property var widgetLayout: defaultWidgets

    property var visibleWidgets: getVisibleWidgets()




    // Professional background
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: theme.backgroundPrimary }
            GradientStop { position: 0.3; color: Qt.lighter(theme.backgroundPrimary, 1.02) }
            GradientStop { position: 1.0; color: theme.backgroundSecondary }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Enterprise Header
        Rectangle {
            id: dashboardHeader
            Layout.fillWidth: true
            height: headerHeight
            color: "transparent"

            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(width, 0)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1) }
                    GradientStop { position: 0.5; color: "transparent" }
                    GradientStop { position: 1.0; color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.05) }
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 25

                // Title Section
                ColumnLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 8

                    RowLayout {
                        spacing: 15

                        Text {
                            text: "🧠"
                            font.pixelSize: 32
                        }

                        ColumnLayout {
                            spacing: 4

                            Text {
                                text: "BCI Studio Pro"
                                color: theme.textPrimary
                                font.bold: true
                                font.pixelSize: 24
                                font.family: "Segoe UI"
                            }

                            Text {
                                text: "Enterprise Dashboard"
                                color: theme.textSecondary
                                font.pixelSize: 14
                                font.family: "Segoe UI"
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // Live Metrics
                RowLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 20

                    LiveMetricPill {
                        icon: "📶"
                        value: "94%"
                        label: "Signal Quality"
                        trend: "+1.2%"
                        pillColor: "#4CAF50"  // استفاده از pillColor به جای color
                    }

                    LiveMetricPill {
                        icon: "⚡"
                        value: "256Hz"
                        label: "Sampling"
                        trend: "Stable"
                        pillColor: "#2196F3"  // استفاده از pillColor به جای color
                    }

                    LiveMetricPill {
                        icon: "🔋"
                        value: "87%"
                        label: "Battery"
                        trend: "-3%"
                        pillColor: "#FF9800"  // استفاده از pillColor به جای color
                    }
                }

                Item { Layout.preferredWidth: 20 }

                // Dashboard Controls
                RowLayout {
                    Layout.alignment: Qt.AlignVCenter
                    spacing: 10

                    // Edit Mode Toggle
                    Rectangle {
                        width: 48
                        height: 28
                        radius: 14
                        color: editMode ? theme.primary : theme.backgroundLight
                        border.color: theme.border
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: editMode ? "✓" : "✏️"
                            font.pixelSize: 12
                            color: editMode ? "white" : theme.textSecondary
                            font.bold: editMode
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                dashboardRoot.editMode = !dashboardRoot.editMode
                                if (!dashboardRoot.editMode) {
                                    widgetConfigPanel.close()
                                }
                            }
                        }
                    }

                    // Add Widget Button
                    Rectangle {
                        width: 36
                        height: 36
                        radius: 8
                        color: theme.primary
                        visible: editMode

                        Text {
                            anchors.centerIn: parent
                            text: "➕"
                            font.pixelSize: 14
                            color: "white"
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: widgetConfigPanel.openPanel() // تغییر از open() به openPanel()
                        }
                    }

                    // Refresh Button
                    Rectangle {
                        width: 36
                        height: 36
                        radius: 8
                        color: theme.backgroundLight
                        border.color: theme.border
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "🔄"
                            font.pixelSize: 14
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: refreshAllWidgets()
                        }
                    }
                }
            }

            // Separator line
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: theme.border
                opacity: 0.3
            }
        }

        // Main Dashboard Area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollView {
                id: scrollView
                anchors.fill: parent
                anchors.margins: 10
                clip: true
                ScrollBar.vertical.policy: ScrollBar.AsNeeded

                contentWidth: dashboardGrid.width
                contentHeight: dashboardGrid.height

                // Dashboard Grid
                GridLayout {
                    id: dashboardGrid
                    width: Math.max(scrollView.width - 40, 1200)
                    columns: currentColumns
                    columnSpacing: cardSpacing
                    rowSpacing: cardSpacing

                    Repeater {
                        model: visibleWidgets

                        delegate: Loader {
                            id: widgetLoader
                            source: "DashboardWidgetLoader.qml" // استفاده از فایل صحیح
                            asynchronous: true

                            property var widgetData: modelData
                            property bool editMode: dashboardRoot.editMode
                            property int gridColumns: currentColumns
                            property int columnSpan: modelData.columnSpan

                            Layout.fillWidth: true
                            Layout.preferredHeight: getWidgetHeight(modelData.id)
                            Layout.columnSpan: modelData.columnSpan

                            onLoaded: {
                                if (item) {
                                   item.widgetId = widgetData.id
                                   item.widgetName = widgetData.name
                                   item.widgetIcon = widgetData.icon
                                   item.editMode = editMode
                                   item.columnSpan = columnSpan
                                   item.gridColumns = gridColumns
                                    // Connect signals
                                   item.closeRequested.connect(function() {
                                       dashboardRoot.removeWidget(widgetData.id)
                                   })

                                   item.moveRequested.connect(function(direction) {
                                       console.log("Move requested:", widgetData.id, direction)
                                       // Implement move logic here
                                   })
                                }

                            }
                        }
                    }

                    // Empty Slot for adding new widgets
                    Rectangle {
                        id: emptySlot
                        visible: editMode && visibleWidgets.length < 8
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        Layout.columnSpan: currentColumns >= 2 ? 2 : 1
                        color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.05)
                        radius: 16

                        // Dashed border using Canvas
                        Canvas {
                            anchors.fill: parent
                            contextType: "2d"

                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.reset()
                                ctx.strokeStyle = Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.5)
                                ctx.lineWidth = 2
                                ctx.setLineDash([8, 4])
                                ctx.strokeRect(2, 2, parent.width - 4, parent.height - 4)
                                ctx.setLineDash([])
                            }
                        }

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 15

                            Text {
                                text: "➕"
                                font.pixelSize: 32
                                opacity: 0.7
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: "Add Widget"
                                color: theme.textPrimary
                                font.bold: true
                                font.pixelSize: 16
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: "Click to add a new widget to dashboard"
                                color: theme.textSecondary
                                font.pixelSize: 12
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: widgetConfigPanel.open()
                        }

                        // Hover effect
                        states: [
                            State {
                                name: "hovered"
                                when: emptySlotMouseArea.containsMouse
                                PropertyChanges {
                                    target: emptySlot
                                    color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.08)
                                    scale: 1.02
                                }
                            }
                        ]

                        transitions: Transition {
                            NumberAnimation { properties: "color, scale"; duration: 200 }
                        }

                        MouseArea {
                            id: emptySlotMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: widgetConfigPanel.open()
                        }
                    }
                }
            }

            // Empty State when no widgets
            EmptyDashboardState {
                visible: visibleWidgets.length === 0 && !editMode
                anchors.centerIn: parent
                onAddWidgets: {
                    dashboardRoot.editMode = true
                    widgetConfigPanel.open()
                }
            }
        }
    }

    // Widget Configuration Panel
    WidgetConfigPanel {
        id: widgetConfigPanel
        anchors.centerIn: parent
        availableWidgets: dashboardRoot.availableWidgets

        onWidgetAdded: function(widgetId) {
            console.log("Adding widget:", widgetId)
            addNewWidget(widgetId)
        }

        onLayoutReset: function() {
            console.log("Resetting layout to default")
            resetToDefaultLayout()
        }

        onClosed: {
            console.log("Widget config panel closed")
        }
    }

    // Functions
    function calculateColumns() {
        var width = dashboardRoot.width
        if (width > 1800) return 4
        if (width > 1400) return 3
        if (width > 1000) return 2
        return 1
    }

    function getVisibleWidgets() {
        var visible = []
        for (var i = 0; i < widgetLayout.length; i++) {
            if (widgetLayout[i].visible) {
                visible.push(widgetLayout[i])
            }
        }
        return visible
    }

    function getWidgetHeight(widgetId) {
        if (widgetId === "signalQuality") return 500  // بزرگ و پراهمیت
        if (widgetId === "liveSignals") return 400
        if (widgetId === "cognitiveMetrics") return 350
        if (widgetId === "spectrumAnalysis") return 380
        if (widgetId === "bciOutput") return 340
        return 320  // سایر ویجت‌ها
    }


    function updateVisibleWidgets() {
        // ایجاد آرایه جدید برای trigger کردن binding
        var temp = []
        for (var i = 0; i < widgetLayout.length; i++) {
            if (widgetLayout[i].visible) {
                temp.push(widgetLayout[i])
            }
        }
        visibleWidgets = temp
        console.log("📊 Visible widgets updated:", visibleWidgets.length)
    }

    function showToastMessage(message) {
        var component = Qt.createComponent("SuccessToast.qml")
        if (component.status === Component.Ready) {
            var toast = component.createObject(dashboardRoot, {
                message: message,
                duration: 2000
            })
            toast.show()
        } else {
            console.log("⚠️", message)
        }
    }


    function removeWidget(widgetId) {
        console.log("Removing widget:", widgetId)

        var newLayout = []
        for (var i = 0; i < widgetLayout.length; i++) {
            var widget = {
                id: widgetLayout[i].id,
                name: widgetLayout[i].name,
                icon: widgetLayout[i].icon,
                category: widgetLayout[i].category,
                columnSpan: widgetLayout[i].columnSpan,
                visible: widgetLayout[i].id === widgetId ? false : widgetLayout[i].visible,
                description: widgetLayout[i].description
            }
            newLayout.push(widget)
        }
        widgetLayout = newLayout
        updateVisibleWidgets()
    }



    function resetToDefaultLayout() {
        console.log("Resetting to default layout")

        // ایجاد کپی عمیق از default widgets
        var newLayout = []
        for (var i = 0; i < defaultWidgets.length; i++) {
            newLayout.push({
                id: defaultWidgets[i].id,
                name: defaultWidgets[i].name,
                icon: defaultWidgets[i].icon,
                category: defaultWidgets[i].category,
                columnSpan: defaultWidgets[i].columnSpan,
                visible: defaultWidgets[i].visible,
                description: defaultWidgets[i].description
            })
        }
        widgetLayout = newLayout
        updateVisibleWidgets()

        // نمایش پیام موفقیت
        showResetSuccessMessage()
    }

    function refreshAllWidgets() {
        console.log("Refreshing all dashboard widgets...")

        // اینجا می‌توانید منطق رفرش کردن تمام ویجت‌ها را اضافه کنید
        for (var i = 0; i < dashboardGrid.children.length; i++) {
            var child = dashboardGrid.children[i]
            if (child && child.item && typeof child.item.refresh === 'function') {
                child.item.refresh()
            }
        }

        // نمایش پیام رفرش
        showRefreshMessage()
    }

    function showAddSuccessMessage(widgetName) {
        // ایجاد یک toast message ساده
        var component = Qt.createComponent("SuccessToast.qml")
        if (component.status === Component.Ready) {
            var toast = component.createObject(dashboardRoot, {
                message: "✓ " + widgetName + " added to dashboard",
                duration: 2000
            })
            toast.show()
        }
    }

    function showResetSuccessMessage() {
        var component = Qt.createComponent("SuccessToast.qml")
        if (component.status === Component.Ready) {
            var toast = component.createObject(dashboardRoot, {
                message: "✓ Dashboard layout reset to default",
                duration: 2000
            })
            toast.show()
        }
    }

    function showRefreshMessage() {
        var component = Qt.createComponent("SuccessToast.qml")
        if (component.status === Component.Ready) {
            var toast = component.createObject(dashboardRoot, {
                message: "🔄 Dashboard refreshed",
                duration: 1500
            })
            toast.show()
        }
    }

    // تابع جدید برای لود خودکار ویجت‌ها
    function loadWidgetLayout() {
        console.log("🔄 Loading widget layout...")

        // ابتدا سعی کنید از localStorage لود کنید
        var savedLayout = loadFromStorage("widgetLayout")
        if (savedLayout && savedLayout.length > 0) {
            console.log("✅ Loaded layout from storage:", savedLayout.length, "widgets")
            return savedLayout
        }

        // اگر وجود نداشت، از default استفاده کنید
        console.log("📋 Using default layout")
        return defaultWidgets
    }

    function loadFromStorage(key) {
        // اینجا می‌توانید از Qt.labs.settings یا localStorage استفاده کنید
        try {
            // شبیه‌سازی لود از storage
            return defaultWidgets
        } catch (error) {
            console.log("❌ Error loading from storage:", error)
            return null
        }
    }

    // در تابع addNewWidget - اضافه کردن ذخیره‌سازی
    function addNewWidget(widgetId) {
        console.log("🔄 Adding new widget:", widgetId)

        // بررسی وجود ویجت
        for (var i = 0; i < visibleWidgets.length; i++) {
            if (visibleWidgets[i].id === widgetId) {
                console.log("⚠️ Widget already exists")
                showToastMessage("Widget already added")
                return
            }
        }

        var widgetToAdd = null
        for (var j = 0; j < availableWidgets.length; j++) {
            if (availableWidgets[j].id === widgetId) {
                widgetToAdd = {
                    id: availableWidgets[j].id,
                    name: availableWidgets[j].name,
                    icon: availableWidgets[j].icon,
                    category: availableWidgets[j].category,
                    columnSpan: availableWidgets[j].columnSpan,
                    visible: true,
                    description: availableWidgets[j].description
                }
                break
            }
        }

        if (!widgetToAdd) {
            console.error("❌ Widget not found:", widgetId)
            return
        }

        // اضافه کردن به layout
        var newLayout = []
        for (var k = 0; k < widgetLayout.length; k++) {
            newLayout.push(QtObject.assign({}, widgetLayout[k]))
        }
        newLayout.push(widgetToAdd)
        widgetLayout = newLayout

        updateVisibleWidgets()
        saveToStorage("widgetLayout", widgetLayout)
        showAddSuccessMessage(widgetToAdd.name)

        widgetConfigPanel.closePanel()
    }

    function saveToStorage(key, data) {
        // ذخیره‌سازی در localStorage
        console.log("💾 Saving layout to storage")
    }


    // Responsive behavior
    onWidthChanged: {
        Qt.callLater(function() {
            var newColumns = calculateColumns()
            if (newColumns !== currentColumns) {
                currentColumns = newColumns
            }
        })
    }

    Component.onCompleted: {
        console.log("🚀 Enterprise Dashboard initialized")
        console.log("📊 Visible widgets:", visibleWidgets.length)
        console.log("🎯 Available widgets:", availableWidgets.length)

        // مطمئن شوید ویجت‌ها لود شده‌اند
        if (visibleWidgets.length === 0) {
            console.log("⚠️ No visible widgets, loading defaults...")
            widgetLayout = defaultWidgets
            updateVisibleWidgets()
        }
    }
}
