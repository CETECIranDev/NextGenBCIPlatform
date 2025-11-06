// AdvancedEventLogCard.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

DashboardCard {
    id: advancedLogCard
    title: "Event Log"
    icon: "📋"
    subtitle: "Real-time System Activity Monitor"
    // badgeText: "LIVE"
    // badgeColor: "#FF4081"
    // collapsible: true
    // expanded: true

    // Properties
    property ListModel logModel: ListModel {}
    property int maxEntries: 100
    property bool autoScroll: true
    property bool showTimestamps: true
    property bool showIcons: true
    property string filterType: "all"
    property int unreadCount: 0
    property bool pauseUpdates: false
    property bool showStatistics: true
    property real scrollPosition: 0

    // Statistics
    property int infoCount: 0
    property int successCount: 0
    property int warningCount: 0
    property int errorCount: 0
    property int commandCount: 0
    property int metricCount: 0

    // Signals
    signal logEntryAdded(var entry)
    signal logCleared()
    signal filterChanged(string filter)
    signal entryClicked(var entry)
    signal entryDoubleClicked(var entry)
    signal entryCopied(var entry)
    signal entryMarkedAsRead(var entry)

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        // Header with Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            // Filter Buttons
            ButtonGroup { id: filterGroup }

            Repeater {
                model: [
                    { type: "all", icon: "🌐", label: "All", color: theme.primary },
                    { type: "info", icon: "ℹ️", label: "Info", color: "#2196F3" },
                    { type: "success", icon: "✅", label: "Success", color: "#4CAF50" },
                    { type: "warning", icon: "⚠️", label: "Warning", color: "#FF9800" },
                    { type: "error", icon: "❌", label: "Error", color: "#F44336" },
                    { type: "command", icon: "🎯", label: "Commands", color: "#9C27B0" },
                    { type: "metric", icon: "📊", label: "Metrics", color: "#607D8B" }
                ]

                Button {
                    text: modelData.icon
                    checked: advancedLogCard.filterType === modelData.type
                    ButtonGroup.group: filterGroup
                    ToolTip.text: modelData.label + " (" + getTypeCount(modelData.type) + ")"

                    background: Rectangle {
                        radius: 6
                        color: parent.checked ? modelData.color : "transparent"
                        border.color: parent.checked ? modelData.color : theme.border
                        border.width: 1
                    }

                    contentItem: Text {
                        text: parent.text
                        color: parent.checked ? "white" : theme.textPrimary
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        advancedLogCard.filterType = modelData.type
                        advancedLogCard.filterChanged(modelData.type)
                    }
                }
            }

            Item { Layout.fillWidth: true }

            // Control Buttons
            Button {
                text: pauseUpdates ? "▶️" : "⏸️"
                ToolTip.text: pauseUpdates ? "Resume Updates" : "Pause Updates"
                onClicked: advancedLogCard.pauseUpdates = !advancedLogCard.pauseUpdates

                background: Rectangle {
                    radius: 6
                    color: parent.hovered ? Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1) : "transparent"
                    border.color: pauseUpdates ? "#FF9800" : "transparent"
                    border.width: 1
                }
            }

            Button {
                text: "🗑️"
                ToolTip.text: "Clear Log"
                onClicked: showClearDialog()

                background: Rectangle {
                    radius: 6
                    color: parent.hovered ? Qt.rgba(0.96, 0.26, 0.21, 0.1) : "transparent"
                }
            }

            Button {
                text: "📤"
                ToolTip.text: "Export Log"
                onClicked: exportLog()

                background: Rectangle {
                    radius: 6
                    color: parent.hovered ? Qt.rgba(0.3, 0.69, 0.49, 0.1) : "transparent"
                }
            }
        }

        // Statistics Bar
        Rectangle {
            Layout.fillWidth: true
            height: showStatistics ? 40 : 0
            radius: 6
            color: Qt.lighter(theme.backgroundLight, 1.1)
            visible: showStatistics

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 15

                // Total count
                Text {
                    text: "📊 " + advancedLogCard.logModel.count + " events"
                    color: theme.textPrimary
                    font.pixelSize: 12
                    font.bold: true
                }

                // Type statistics
                RowLayout {
                    spacing: 12

                    Repeater {
                        model: [
                            { type: "info", color: "#2196F3", icon: "ℹ️" },
                            { type: "success", color: "#4CAF50", icon: "✅" },
                            { type: "warning", color: "#FF9800", icon: "⚠️" },
                            { type: "error", color: "#F44336", icon: "❌" },
                            { type: "command", color: "#9C27B0", icon: "🎯" },
                            { type: "metric", color: "#607D8B", icon: "📊" }
                        ]

                        RowLayout {
                            spacing: 6
                            opacity: advancedLogCard.filterType === "all" || advancedLogCard.filterType === modelData.type ? 1 : 0.4

                            Text {
                                text: modelData.icon
                                font.pixelSize: 12
                            }

                            Text {
                                text: getTypeCount(modelData.type)
                                color: theme.textPrimary
                                font.pixelSize: 11
                                font.bold: true
                            }

                            Rectangle {
                                width: 8
                                height: 8
                                radius: 4
                                color: modelData.color
                            }

                            MouseArea {
                                Layout.preferredWidth: 50
                                Layout.preferredHeight: 20
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    advancedLogCard.filterType = modelData.type
                                    advancedLogCard.filterChanged(modelData.type)
                                }
                                ToolTip.text: "Show only " + modelData.type + " events"
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // Unread counter
                Text {
                    text: advancedLogCard.unreadCount > 0 ?
                         "🔴 " + advancedLogCard.unreadCount + " new" :
                         "✅ All read"
                    color: advancedLogCard.unreadCount > 0 ? "#F44336" : "#4CAF50"
                    font.pixelSize: 11
                    font.bold: true
                }
            }
        }

        // Log List Container
        Rectangle {
            id: listContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 8
            color: theme.backgroundLight
            border.color: theme.border
            border.width: 1

            // Search and Filter (optional - can be enabled)
            Rectangle {
                id: searchBar
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 0 // Initially hidden
                color: Qt.lighter(theme.backgroundLight, 1.05)
                clip: true

                Behavior on height {
                    NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 8

                    TextField {
                        id: searchField
                        placeholderText: "Search events..."
                        Layout.fillWidth: true
                        font.pixelSize: 12
                    }

                    Button {
                        text: "✕"
                        onClicked: searchBar.height = 0
                    }
                }
            }

            // Log List with advanced features
            ListView {
                id: logListView
                anchors.top: searchBar.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 1
                model: advancedLogCard.logModel
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                spacing: 1
                cacheBuffer: 1000

                // Save and restore scroll position
                onContentYChanged: advancedLogCard.scrollPosition = contentY
                Component.onCompleted: contentY = advancedLogCard.scrollPosition

                // Custom scroll bar
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    width: 10
                    background: Rectangle {
                        color: "transparent"
                    }
                    contentItem: Rectangle {
                        radius: 5
                        color: Qt.rgba(0, 0, 0, 0.3)
                    }
                }

                delegate: LogEntryDelegate {
                    width: logListView.width
                    timestamp: model.timestamp
                    message: model.message
                    type: model.type
                    showTimestamp: advancedLogCard.showTimestamps
                    showIcon: advancedLogCard.showIcons
                    isNew: model.isNew || false
                    entryIndex: index

                    onCopyRequested: {
                        advancedLogCard.copyToClipboard(model.timestamp + " - " + model.message)
                        advancedLogCard.entryCopied(advancedLogCard.logModel.get(index))
                    }

                    onMarkAsRead: {
                        if (model.isNew) {
                            advancedLogCard.logModel.setProperty(index, "isNew", false)
                            advancedLogCard.unreadCount = advancedLogCard.getUnreadCount()
                            advancedLogCard.entryMarkedAsRead(advancedLogCard.logModel.get(index))
                        }
                    }

                    onClicked: advancedLogCard.entryClicked(advancedLogCard.logModel.get(index))
                    onDoubleClicked: advancedLogCard.entryDoubleClicked(advancedLogCard.logModel.get(index))
                }

                // Auto-scroll to bottom
                onCountChanged: {
                    if (advancedLogCard.autoScroll && atYEnd && !advancedLogCard.pauseUpdates) {
                        positionViewAtEnd()
                    }
                    advancedLogCard.unreadCount = advancedLogCard.getUnreadCount()
                    advancedLogCard.updateStatistics()
                }

                // Add nice empty state
                Label {
                    anchors.centerIn: parent
                    text: "📋\nNo events to display\n\n" +
                         (advancedLogCard.filterType !== "all" ?
                         "Change filter to see more events" :
                         "System events will appear here automatically")
                    color: theme.textTertiary
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    visible: logListView.count === 0
                    lineHeight: 1.4
                }

                // Scroll to bottom button
                Button {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 10
                    text: "⬇️"
                    visible: !logListView.atYEnd && advancedLogCard.autoScroll
                    opacity: 0.8

                    background: Rectangle {
                        radius: 15
                        color: theme.primary
                    }

                    contentItem: Text {
                        text: parent.text
                        color: "white"
                        font.pixelSize: 14
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: logListView.positionViewAtEnd()
                }
            }
        }

        // Footer Controls
        RowLayout {
            Layout.fillWidth: true
            spacing: 15

            CheckBox {
                id: autoScrollCheck
                text: "Auto-scroll"
                checked: advancedLogCard.autoScroll
                onCheckedChanged: advancedLogCard.autoScroll = checked
            }

            CheckBox {
                id: timestampCheck
                text: "Timestamps"
                checked: advancedLogCard.showTimestamps
                onCheckedChanged: advancedLogCard.showTimestamps = checked
            }

            CheckBox {
                id: iconsCheck
                text: "Icons"
                checked: advancedLogCard.showIcons
                onCheckedChanged: advancedLogCard.showIcons = checked
            }

            CheckBox {
                id: statisticsCheck
                text: "Statistics"
                checked: advancedLogCard.showStatistics
                onCheckedChanged: advancedLogCard.showStatistics = checked
            }

            Item { Layout.fillWidth: true }

            Button {
                text: "🔍"
                ToolTip.text: "Search events"
                flat: true
                onClicked: searchBar.height = searchBar.height === 0 ? 40 : 0
            }

            Button {
                text: "Mark all as read"
                visible: advancedLogCard.unreadCount > 0
                flat: true
                onClicked: markAllAsRead()
            }
        }
    }

    // Confirmation Dialog for Clear
    Dialog {
        id: clearDialog
        title: "Clear Event Log"
        modal: true
        standardButtons: Dialog.Yes | Dialog.No

        Label {
            text: "Are you sure you want to clear all event logs?\nThis action cannot be undone."
            wrapMode: Text.Wrap
        }

        onAccepted: clearLog()
    }

    // Helper functions
    function getTypeCount(type) {
        if (type === "all") return logModel.count

        var count = 0
        for (var i = 0; i < logModel.count; i++) {
            if (logModel.get(i).type === type) {
                count++
            }
        }
        return count
    }

    function getUnreadCount() {
        var count = 0
        for (var i = 0; i < logModel.count; i++) {
            if (logModel.get(i).isNew) {
                count++
            }
        }
        return count
    }

    function updateStatistics() {
        infoCount = getTypeCount("info")
        successCount = getTypeCount("success")
        warningCount = getTypeCount("warning")
        errorCount = getTypeCount("error")
        commandCount = getTypeCount("command")
        metricCount = getTypeCount("metric")
    }

    // Public API Methods
    function addLogEntry(message, type = "info", markAsNew = true) {
        if (advancedLogCard.pauseUpdates) return

        if (logModel.count >= maxEntries) {
            logModel.remove(0)
        }

        var timestamp = new Date().toLocaleTimeString('en-US', {
            hour12: false,
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        })

        var entry = {
            timestamp: timestamp,
            message: message,
            type: type,
            isNew: markAsNew
        }

        logModel.append(entry)
        logEntryAdded(entry)

        if (autoScroll) {
            logListView.positionViewAtEnd()
        }
    }

    function clearLog() {
        logModel.clear()
        unreadCount = 0
        updateStatistics()
        logCleared()
    }

    function showClearDialog() {
        clearDialog.open()
    }

    function markAllAsRead() {
        for (var i = 0; i < logModel.count; i++) {
            if (logModel.get(i).isNew) {
                logModel.setProperty(i, "isNew", false)
            }
        }
        unreadCount = 0
    }

    function exportLog() {
        var logText = "🧠 BCI Studio Pro - Event Log\n"
        logText += "=".repeat(50) + "\n"
        logText += "Generated: " + new Date().toLocaleString() + "\n"
        logText += "Total Events: " + logModel.count + "\n"
        logText += "Filter: " + filterType + "\n"
        logText += "Statistics: " +
                  "Info(" + infoCount + ") " +
                  "Success(" + successCount + ") " +
                  "Warning(" + warningCount + ") " +
                  "Error(" + errorCount + ") " +
                  "Command(" + commandCount + ") " +
                  "Metric(" + metricCount + ")\n"
        logText += "=".repeat(50) + "\n\n"

        for (var i = 0; i < logModel.count; i++) {
            var entry = logModel.get(i)
            if (filterType === "all" || entry.type === filterType) {
                var typeIcon = getTypeIconForExport(entry.type)
                logText += "[" + entry.timestamp + "] " + typeIcon + " " + entry.message + "\n"
            }
        }

        console.log("Log exported:\n" + logText)
        addLogEntry("Event log exported successfully", "success")

        // TODO: Implement platform-specific file saving
        // saveToFile("bci_event_log.txt", logText)
    }

    function getTypeIconForExport(type) {
        switch(type) {
            case "success": return "[OK]"
            case "warning": return "[WARN]"
            case "error": return "[ERROR]"
            case "command": return "[CMD]"
            case "metric": return "[METRIC]"
            default: return "[INFO]"
        }
    }

    function copyToClipboard(text) {
        console.log("Copied to clipboard:", text)
        // Platform-specific clipboard implementation would go here
    }

    function saveToFile(filename, content) {
        // Platform-specific file saving implementation
        console.log("Saving to file:", filename)
    }

    // Quick add methods for common log types
    function addInfo(message) {
        addLogEntry(message, "info")
    }

    function addSuccess(message) {
        addLogEntry(message, "success")
    }

    function addWarning(message) {
        addLogEntry(message, "warning")
    }

    function addError(message) {
        addLogEntry(message, "error")
    }

    function addCommand(message) {
        addLogEntry(message, "command")
    }

    function addMetric(message) {
        addLogEntry(message, "metric")
    }

    function addSystem(message) {
        addLogEntry(message, "system")
    }

    function addDevice(message) {
        addLogEntry(message, "device")
    }

    // Entry management
    function highlightEntry(index) {
        if (index >= 0 && index < logModel.count) {
            var item = logListView.itemAtIndex(index)
            if (item) {
                item.highlight()
            }
        }
    }

    function findEntry(message) {
        for (var i = 0; i < logModel.count; i++) {
            if (logModel.get(i).message.includes(message)) {
                return i
            }
        }
        return -1
    }

    function getEntriesByType(type) {
        var entries = []
        for (var i = 0; i < logModel.count; i++) {
            if (logModel.get(i).type === type) {
                entries.push(logModel.get(i))
            }
        }
        return entries
    }

    // Search functionality
    function searchEntries(query) {
        var results = []
        for (var i = 0; i < logModel.count; i++) {
            var entry = logModel.get(i)
            if (entry.message.toLowerCase().includes(query.toLowerCase()) ||
                entry.timestamp.includes(query)) {
                results.push({index: i, entry: entry})
            }
        }
        return results
    }

    // Initialize with sample data
    Component.onCompleted: {
        if (logModel.count === 0) {
            addSuccess("System initialized successfully")
            addInfo("BCI Studio Pro v2.0 started")
            addCommand("Motor Imagery paradigm loaded")
            addMetric("Signal quality: 92%")
            addInfo("Real-time processing enabled")
            addCommand("Command: LEFT (87% confidence)")
            addMetric("Attention level: 78%")
            addInfo("Data streaming active")
            addDevice("OpenBCI Cyton device connected")
            addSystem("All systems operational")
        }
        updateStatistics()
    }
}
