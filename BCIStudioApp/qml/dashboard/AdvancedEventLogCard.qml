// AdvancedEventLogCard.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

DashboardCard {
    id: advancedLogCard
    title: "Event Log"
    icon: "📋"
    subtitle: "Real-time System Activity Monitor"
    badgeText: "LIVE"
    badgeColor: "#FF4081"
    collapsible: true

    property ListModel logModel: ListModel {}
    property int maxEntries: 100
    property bool autoScroll: true
    property bool showTimestamps: true
    property bool showIcons: true
    property string filterType: "all"
    property int unreadCount: 0
    property bool pauseUpdates: false

    // Signals
    signal logEntryAdded(var entry)
    signal logCleared()
    signal filterChanged(string filter)
    signal entryClicked(var entry)
    signal entryDoubleClicked(var entry)

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        // ... (همان کنترل‌های قبلی) ...

        // Log List Container
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 8
            color: theme.backgroundLight
            border.color: theme.border
            border.width: 1

            ListView {
                id: logListView
                anchors.fill: parent
                anchors.margins: 1
                model: advancedLogCard.logModel
                clip: true
                boundsBehavior: Flickable.StopAtBounds
                spacing: 1

                delegate: LogEntryDelegate {
                    timestamp: model.timestamp
                    message: model.message
                    type: model.type
                    showTimestamp: advancedLogCard.showTimestamps
                    showIcon: advancedLogCard.showIcons
                    isNew: model.isNew || false
                    entryIndex: index
                    
                    onCopyRequested: advancedLogCard.copyToClipboard(model.timestamp + " - " + model.message)
                    onMarkAsRead: {
                        if (model.isNew) {
                            advancedLogCard.logModel.setProperty(index, "isNew", false)
                            advancedLogCard.unreadCount = advancedLogCard.getUnreadCount()
                        }
                    }
                    onClicked: advancedLogCard.entryClicked(advancedLogCard.logModel.get(index))
                    onDoubleClicked: advancedLogCard.entryDoubleClicked(advancedLogCard.logModel.get(index))
                }

                // ... (بقیه کدها) ...
            }
        }

        // ... (بقیه کدها) ...
    }

    // ... (توابع و متدهای قبلی) ...

    // اضافه کردن متد جدید برای highlight کردن یک entry
    function highlightEntry(index) {
        if (index >= 0 && index < logModel.count) {
            var item = logListView.itemAtIndex(index)
            if (item) {
                item.highlight()
            }
        }
    }

    // پیدا کردن entry بر اساس message
    function findEntry(message) {
        for (var i = 0; i < logModel.count; i++) {
            if (logModel.get(i).message.includes(message)) {
                return i
            }
        }
        return -1
    }
}