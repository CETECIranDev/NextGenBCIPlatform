import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Card {
    id: logCard
    title: "Event Log"
    icon: "📋"

    property ListModel logModel: ListModel {}
    property int maxEntries: 50

    contentHeight: 250

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // Controls
        RowLayout {
            Layout.fillWidth: true

            Button {
                text: "Clear"
                onClicked: logCard.logModel.clear()
            }

            Button {
                text: "Export"
                onClicked: exportLog()
            }

            Item { Layout.fillWidth: true }

            Text {
                text: logCard.logModel.count + " events"
                color: theme.textSecondary
                font.pixelSize: 12
            }
        }

        // Log List
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: theme.backgroundLight
            radius: 4
            border.color: theme.border
            border.width: 1

            ListView {
                id: logListView
                anchors.fill: parent
                anchors.margins: 2
                model: logCard.logModel
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                delegate: Rectangle {
                    width: logListView.width
                    height: 40
                    color: index % 2 === 0 ? "transparent" : Qt.rgba(1, 1, 1, 0.05)

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 10

                        // Type Icon
                        Text {
                            text: getTypeIcon(model.type)
                            font.pixelSize: 14
                            Layout.preferredWidth: 20
                        }

                        // Timestamp
                        Text {
                            text: model.timestamp
                            color: theme.textSecondary
                            font.pixelSize: 11
                            font.family: "Monospace"
                            Layout.preferredWidth: 70
                        }

                        // Message
                        Text {
                            text: model.message
                            color: getMessageColor(model.type)
                            font.pixelSize: 12
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        // Action Button
                        Button {
                            text: "📋"
                            flat: true
                            onClicked: copyToClipboard(model.timestamp + " - " + model.message)
                            Layout.preferredWidth: 30
                        }
                    }
                }
            }
        }

        // Auto-scroll toggle
        CheckBox {
            text: "Auto-scroll to latest"
            checked: true
            onCheckedChanged: {
                if (checked) {
                    logListView.positionViewAtEnd()
                }
            }
        }
    }

    function addLogEntry(timestamp, message, type) {
        if (logCard.logModel.count >= logCard.maxEntries) {
            logCard.logModel.remove(0)
        }

        logCard.logModel.append({
            timestamp: timestamp,
            message: message,
            type: type || "info"
        })

        if (logListView.atYEnd) {
            logListView.positionViewAtEnd()
        }
    }

    function exportLog() {
        var logText = "BCI Studio Pro - Event Log\n"
        logText += "Generated: " + new Date().toLocaleString() + "\n\n"

        for (var i = 0; i < logCard.logModel.count; i++) {
            var entry = logCard.logModel.get(i)
            logText += entry.timestamp + " - " + entry.message + "\n"
        }

        console.log("Log exported:\n" + logText)
        // در آینده می‌توانید فایل ذخیره کنید
    }

    function copyToClipboard(text) {
        console.log("Copied to clipboard:", text)
        // Qt.platform.os === "android" ? ... : ...
    }

    function getTypeIcon(type) {
        switch(type) {
            case "success": return "✅"
            case "warning": return "⚠️"
            case "error": return "❌"
            case "command": return "🎯"
            case "metric": return "📊"
            default: return "ℹ️"
        }
    }

    function getMessageColor(type) {
        switch(type) {
            case "success": return "#4CAF50"
            case "warning": return "#FF9800"
            case "error": return "#F44336"
            case "command": return "#2196F3"
            case "metric": return "#9C27B0"
            default: return theme.textPrimary
        }
    }

    // شبیه‌سازی رویدادهای نمونه
    Component.onCompleted: {
        if (logModel.count === 0) {
            addLogEntry("14:30:25", "System initialized", "info")
            addLogEntry("14:30:30", "Device connected: OpenBCI Cyton", "success")
            addLogEntry("14:31:15", "Signal quality stabilized", "info")
            addLogEntry("14:32:45", "Command detected: LEFT (87% confidence)", "command")
            addLogEntry("14:33:20", "Attention level increased to 65%", "metric")
        }
    }
}
