// LogEntryDelegate.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects  // برای Qt 6


Rectangle {
    id: logEntryDelegate

    // Properties
    property string timestamp: ""
    property string message: ""
    property string type: "info"
    property bool showTimestamp: true
    property bool showIcon: true
    property bool isNew: false
    property int entryIndex: -1

    // Signals
    signal copyRequested()
    signal markAsRead()
    signal clicked()
    signal doubleClicked()

    width: ListView.view ? ListView.view.width : 400
    height: message.length > 50 ? 60 : 45
    color: isNew ? Qt.rgba(getTypeColor(type).r, getTypeColor(type).g, getTypeColor(type).b, 0.05) :
                   (entryIndex % 2 === 0 ? "transparent" : Qt.rgba(0, 0, 0, 0.02))

    // Left border accent with animation
    Rectangle {
        id: typeIndicator
        width: 4
        height: parent.height
        color: getTypeColor(type)
        opacity: 0.8

        // Glow effect for new entries
        layer.enabled: isNew
        layer.effect: Glow {
            radius: 8
            samples: 16
            color: typeIndicator.color
            transparentBorder: true
        }
    }

    // New entry highlight animation
    SequentialAnimation {
        id: newEntryAnimation
        running: isNew
        loops: 3

        ParallelAnimation {
            NumberAnimation {
                target: typeIndicator
                property: "width"
                to: 8
                duration: 300
            }
            ColorAnimation {
                target: typeIndicator
                property: "color"
                to: Qt.lighter(getTypeColor(type), 1.3)
                duration: 300
            }
        }

        ParallelAnimation {
            NumberAnimation {
                target: typeIndicator
                property: "width"
                to: 4
                duration: 300
            }
            ColorAnimation {
                target: typeIndicator
                property: "color"
                to: getTypeColor(type)
                duration: 300
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 12

        // Type Icon with background
        Rectangle {
            id: iconContainer
            width: 28
            height: 28
            radius: 6
            color: Qt.rgba(getTypeColor(type).r, getTypeColor(type).g, getTypeColor(type).b, 0.1)
            Layout.alignment: Qt.AlignVCenter
            visible: showIcon

            Text {
                anchors.centerIn: parent
                text: getTypeIcon(type)
                font.pixelSize: 14
                color: getTypeColor(type)
            }
        }

        // Content Area
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2

            // First line: Timestamp and quick actions
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Text {
                    text: showTimestamp ? timestamp : ""
                    color: theme.textSecondary
                    font.pixelSize: 10
                    font.family: "Monospace, Consolas, 'Courier New'"
                    font.bold: isNew
                    Layout.preferredWidth: showTimestamp ? 60 : 0
                }

                Text {
                    text: message
                    color: getTypeColor(type)
                    font.pixelSize: 12
                    font.bold: isNew
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                // New indicator with pulse
                Rectangle {
                    width: 8
                    height: 8
                    radius: 4
                    color: "#FF4081"
                    visible: isNew
                    Layout.alignment: Qt.AlignVCenter

                    SequentialAnimation on scale {
                        running: isNew
                        loops: Animation.Infinite
                        NumberAnimation { to: 1.3; duration: 800; easing.type: Easing.InOutQuad }
                        NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
                    }
                }
            }

            // Second line: Full message (if truncated)
            Text {
                text: message
                color: theme.textSecondary
                font.pixelSize: 11
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
                visible: message.length > 80
                Layout.fillWidth: true
            }
        }

        // Action Buttons
        RowLayout {
            spacing: 4
            Layout.alignment: Qt.AlignVCenter

            // Copy Button
            Button {
                id: copyButton
                text: "📋"
                flat: true
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32

                onClicked: {
                    copyRequested()
                    copyAnimation.start()
                }

                background: Rectangle {
                    radius: 6
                    color: copyButton.hovered ? Qt.rgba(0, 0, 0, 0.1) : "transparent"
                }

                ToolTip.text: "Copy to clipboard"

                // Copy feedback animation
                SequentialAnimation {
                    id: copyAnimation
                    NumberAnimation {
                        target: copyButton
                        property: "scale"
                        to: 1.2
                        duration: 100
                    }
                    NumberAnimation {
                        target: copyButton
                        property: "scale"
                        to: 1.0
                        duration: 100
                    }
                }
            }

            // Mark as read button (for new entries)
            Button {
                id: readButton
                text: "👁️"
                flat: true
                visible: isNew
                Layout.preferredWidth: 32
                Layout.preferredHeight: 32

                onClicked: markAsRead()

                background: Rectangle {
                    radius: 6
                    color: readButton.hovered ? Qt.rgba(0.96, 0.26, 0.21, 0.1) : "transparent"
                }

                ToolTip.text: "Mark as read"
            }
        }
    }

    // Hover effect
    states: [
        State {
            name: "hovered"
            when: mouseArea.containsMouse
            PropertyChanges {
                target: logEntryDelegate
                color: Qt.rgba(getTypeColor(type).r, getTypeColor(type).g, getTypeColor(type).b, 0.08)
            }
            PropertyChanges {
                target: typeIndicator
                opacity: 1
            }
        },
        State {
            name: "pressed"
            when: mouseArea.pressed
            PropertyChanges {
                target: logEntryDelegate
                scale: 0.98
            }
        }
    ]

    transitions: [
        Transition {
            to: "hovered"
            PropertyAnimation {
                properties: "color, opacity, scale"
                duration: 200
                easing.type: Easing.OutCubic
            }
        },
        Transition {
            to: "pressed"
            PropertyAnimation {
                properties: "scale"
                duration: 100
                easing.type: Easing.OutCubic
            }
        }
    ]

    // Mouse interaction
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: (mouse) => {
            logEntryDelegate.clicked()

            if (mouse.button === Qt.RightButton) {
                contextMenu.popup()
            }
        }

        onDoubleClicked: {
            logEntryDelegate.doubleClicked()
            if (isNew) {
                markAsRead()
            }
        }
    }

    // Context Menu
    Menu {
        id: contextMenu

        MenuItem {
            text: "Copy Message"
            icon.source: "qrc:/icons/copy.svg"
            onTriggered: copyRequested()
        }

        MenuItem {
            text: "Mark as Read"
            visible: isNew
            icon.source: "qrc:/icons/check.svg"
            onTriggered: markAsRead()
        }

        MenuSeparator {}

        MenuItem {
            text: "Export This Entry"
            icon.source: "qrc:/icons/export.svg"
            onTriggered: console.log("Export entry:", timestamp, message)
        }
    }

    // Helper functions
    function getTypeIcon(type) {
        switch(type) {
            case "success": return "✅"
            case "warning": return "⚠️"
            case "error": return "❌"
            case "command": return "🎯"
            case "metric": return "📊"
            case "system": return "⚙️"
            case "device": return "🔌"
            default: return "ℹ️"
        }
    }

    function getTypeColor(type) {
        switch(type) {
            case "success": return "#4CAF50"
            case "warning": return "#FF9800"
            case "error": return "#F44336"
            case "command": return "#9C27B0"
            case "metric": return "#607D8B"
            case "system": return "#2196F3"
            case "device": return "#FF9800"
            default: return "#757575"
        }
    }

    function getTypeDescription(type) {
        switch(type) {
            case "success": return "Successful operation"
            case "warning": return "Warning notification"
            case "error": return "Error occurred"
            case "command": return "BCI command executed"
            case "metric": return "Performance metric"
            case "system": return "System event"
            case "device": return "Device communication"
            default: return "Information"
        }
    }

    // Public API methods
    function highlight() {
        highlightAnimation.start()
    }

    function copyContent() {
        copyRequested()
    }

    function markRead() {
        markAsRead()
    }

    // Highlight animation
    SequentialAnimation {
        id: highlightAnimation
        ParallelAnimation {
            ColorAnimation {
                target: logEntryDelegate
                property: "color"
                to: Qt.rgba(getTypeColor(type).r, getTypeColor(type).g, getTypeColor(type).b, 0.15)
                duration: 300
            }
            NumberAnimation {
                target: typeIndicator
                property: "width"
                to: 8
                duration: 300
            }
        }
        ParallelAnimation {
            ColorAnimation {
                target: logEntryDelegate
                property: "color"
                to: isNew ? Qt.rgba(getTypeColor(type).r, getTypeColor(type).g, getTypeColor(type).b, 0.05) :
                           (entryIndex % 2 === 0 ? "transparent" : Qt.rgba(0, 0, 0, 0.02))
                duration: 300
            }
            NumberAnimation {
                target: typeIndicator
                property: "width"
                to: 4
                duration: 300
            }
        }
    }

    Component.onCompleted: {
        // Auto-animate new entries
        if (isNew) {
            newEntryAnimation.start()
        }
    }
}
