// DashboardWidgetLoader.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: widgetLoader
    width: 300
    height: 300

    property string widgetId: ""
    property string widgetName: ""
    property string widgetIcon: ""
    property string widgetCategory: ""
    property bool editMode: false
    property int gridColumns: 2
    property int columnSpan: 1

    signal closeRequested()
    signal moveRequested(string direction)

    // Calculate dynamic width
    property real effectiveWidth: {
        if (!parent) return 300
        var totalSpacing = (gridColumns - 1) * 20  // cardSpacing
        var availableWidth = parent.width - totalSpacing
        return (availableWidth / gridColumns) * columnSpan - (columnSpan > 1 ? 20 : 0)
    }

    // Main widget content
    Loader {
        id: contentLoader
        anchors.fill: parent
        source: getWidgetComponent(widgetId)
        asynchronous: true // برای performance بهتر

        onLoaded: {
            console.log("✅ Widget loaded successfully:", widgetId)
            if (item) {
                // Pass common properties to loaded widget
                if (item.hasOwnProperty("widgetId"))
                    item.widgetId = widgetLoader.widgetId
                if (item.hasOwnProperty("widgetName"))
                    item.widgetName = widgetLoader.widgetName
                if (item.hasOwnProperty("widgetIcon"))
                    item.widgetIcon = widgetLoader.widgetIcon
                if (item.hasOwnProperty("editMode"))
                    item.editMode = widgetLoader.editMode
            }
        }

        onStatusChanged: {
            if (status === Loader.Error) {
                console.error("❌ Failed to load widget:", widgetId, "Source:", source)
                // Show fallback content
                fallbackContent.visible = true
            }
        }
    }

    // Fallback content when widget fails to load
    Rectangle {
        id: fallbackContent
        anchors.fill: parent
        color: theme.backgroundLight
        radius: 12
        border.color: theme.border
        border.width: 1
        visible: false

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: widgetIcon
                font.pixelSize: 32
                opacity: 0.5
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: widgetName
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Widget loading..."
                color: theme.textSecondary
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
            }

            Button {
                text: "Retry"
                onClicked: {
                    fallbackContent.visible = false
                    contentLoader.source = ""
                    contentLoader.source = getWidgetComponent(widgetId)
                }
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    // Edit Mode Overlay - بهبود یافته
    Rectangle {
        anchors.fill: parent
        color: "#801A1A2E"
        radius: 12
        visible: widgetLoader.editMode
        z: 10
        border.color: theme.primary
        border.width: 2

        // Glass effect
        Rectangle {
            anchors.fill: parent
            radius: 12
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#40FFFFFF" }
                GradientStop { position: 1.0; color: "#20FFFFFF" }
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 15

            Text {
                text: widgetIcon + "\n" + widgetName
                color: "white"
                font.bold: true
                font.pixelSize: 14
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter

                // Move controls
                RowLayout {
                    spacing: 6
                    visible: gridColumns > 1

                    Rectangle {
                        width: 36
                        height: 36
                        radius: 18
                        color: moveLeftMouseArea.containsMouse ? Qt.darker("#4CAF50", 1.2) : "#4CAF50"
                        border.color: "white"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "⬅️"
                            font.pixelSize: 12
                        }

                        MouseArea {
                            id: moveLeftMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("Moving widget left:", widgetId)
                                widgetLoader.moveRequested("left")
                            }
                        }
                    }

                    Rectangle {
                        width: 36
                        height: 36
                        radius: 18
                        color: moveRightMouseArea.containsMouse ? Qt.darker("#4CAF50", 1.2) : "#4CAF50"
                        border.color: "white"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "➡️"
                            font.pixelSize: 12
                        }

                        MouseArea {
                            id: moveRightMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                console.log("Moving widget right:", widgetId)
                                widgetLoader.moveRequested("right")
                            }
                        }
                    }
                }

                // Close button
                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: closeMouseArea.containsMouse ? Qt.darker("#F44336", 1.2) : "#F44336"
                    border.color: "white"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: "white"
                        font.pixelSize: 16
                        font.bold: true
                    }

                    MouseArea {
                        id: closeMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            console.log("Closing widget:", widgetId)
                            widgetLoader.closeRequested()
                        }
                    }
                }
            }

            Text {
                text: "Drag to reorder • Click outside to save"
                color: "#CCCCCC"
                font.pixelSize: 11
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }

    function getWidgetComponent(widgetId) {
        console.log("🔧 Getting widget component for:", widgetId)

        var widgetMap = {
            "systemStatus": "SystemStatusCard.qml",
            "signalQuality": "SignalQualityMapCard.qml",
            "cognitiveStates" :"CognitiveStateCard.qml",
            "performanceMetrics" : "PerformanceMetricsCard.qml",
            "realTimeSpectrum" : "RealTimeSpectrumCard.qml",
            "liveSignals": "LiveSignalCard.qml",
            "cognitiveMetrics": "CognitiveGaugesCard.qml",
            "spectrumAnalysis": "SpectrumCard.qml",
            "performance": "PerformanceMetricsCard.qml",
            "eventLog": "EventLogCard.qml",
            "bciOutput": "MainOutputCard.qml",
            "realTimeOutput": "BCIOutputCard.qml" // برای compatibility
        }

        var source = widgetMap[widgetId]
        if (!source) {
            console.warn("⚠️ Widget not found in map:", widgetId, "- Using default")
            source = "DefaultWidgetCard.qml"
        }

        console.log("📁 Widget source:", source)
        return source
    }

    function refresh() {
        console.log("🔄 Refreshing widget:", widgetId)
        if (contentLoader.item && typeof contentLoader.item.refresh === 'function') {
            contentLoader.item.refresh()
        } else {
            console.log("ℹ️ Widget doesn't have refresh function:", widgetId)
        }
    }

    // Handle edit mode changes
    onEditModeChanged: {
        if (contentLoader.item && contentLoader.item.hasOwnProperty("editMode")) {
            contentLoader.item.editMode = editMode
        }
    }

    Component.onCompleted: {
        console.log("🎯 DashboardWidgetLoader created for:", widgetId)
        console.log("📐 Dimensions:", width, "x", height)
        console.log("🔧 Column span:", columnSpan)
    }

    Component.onDestruction: {
        console.log("🗑️ DashboardWidgetLoader destroyed for:", widgetId)
    }
}
