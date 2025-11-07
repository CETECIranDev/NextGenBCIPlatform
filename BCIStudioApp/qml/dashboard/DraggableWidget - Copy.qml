import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

// DraggableWidget.qml
Item {
    id: draggableWidget
    width: 300
    height: 300

    property var widgetData: ({})
    property bool editMode: false
    property int gridColumns: 2
    property int columnSpan: 1

    signal closeRequested()
    signal dragStarted(int index)
    signal dragEnded()

    property bool isDragging: false
    property point dragStartPos: "0,0"

    // Calculate dynamic width
    property real effectiveWidth: {
        if (!parent) return 300
        var totalSpacing = (gridColumns - 1) * 20
        var availableWidth = parent.width - totalSpacing
        return (availableWidth / gridColumns) * columnSpan - (columnSpan > 1 ? 20 : 0)
    }

    // Widget Content
    Loader {
        id: contentLoader
        anchors.fill: parent
        source: getWidgetComponent(widgetData.id)
        
        onLoaded: {
            if (item) {
                item.widgetId = widgetData.id
                item.widgetName = widgetData.name
            }
        }
    }

    // Drag Handle
    Rectangle {
        id: dragHandle
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 8
        width: 24
        height: 24
        radius: 12
        color: theme.primary
        opacity: editMode ? 0.9 : 0
        visible: editMode

        Text {
            anchors.centerIn: parent
            text: "⠿"
            color: "white"
            font.pixelSize: 12
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            drag.target: isDragging ? draggableWidget : undefined
            drag.axis: Drag.XAndYAxis

            onPressed: {
                isDragging = true
                dragStartPos = Qt.point(draggableWidget.x, draggableWidget.y)
                dragStarted(index)
            }

            onReleased: {
                isDragging = false
                dragEnded()
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    // Close Button
    Rectangle {
        id: closeButton
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 8
        width: 24
        height: 24
        radius: 12
        color: "#F44336"
        opacity: editMode ? 0.9 : 0
        visible: editMode

        Text {
            anchors.centerIn: parent
            text: "✕"
            color: "white"
            font.pixelSize: 12
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: closeRequested()
        }

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    // Drop Shadow Effect
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: isDragging ? 8 : 2
        radius: isDragging ? 16 : 8
        samples: 17
        color: isDragging ? "#60000000" : "#20000000"
        
        Behavior on radius {
            NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
        }
        
        Behavior on color {
            ColorAnimation { duration: 300 }
        }
    }

    // Hover Effects
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: editMode ? Qt.OpenHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.LeftButton
        
        onEntered: {
            if (!editMode) {
                parent.scale = 1.02
            }
        }
        
        onExited: {
            if (!editMode) {
                parent.scale = 1.0
            }
        }
        
        onPressed: {
            if (editMode) {
                cursorShape = Qt.ClosedHandCursor
            }
        }
        
        onReleased: {
            if (editMode) {
                cursorShape = Qt.OpenHandCursor
            }
        }
    }

    // Scale Animation
    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    // Drag Animation
    Behavior on x {
        enabled: isDragging
        NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
    }
    
    Behavior on y {
        enabled: isDragging
        NumberAnimation { duration: 100; easing.type: Easing.OutCubic }
    }

    function getWidgetComponent(widgetId) {
        if (widgetId === "systemStatus") return "SystemStatusCard.qml"
        if (widgetId === "signalQuality") return "SignalQualityMap.qml"
        if (widgetId === "liveSignals") return "LiveEEGSignalsCard.qml"
        if (widgetId === "cognitiveMetrics") return "CognitiveMetricsCard.qml"
        if (widgetId === "spectrumAnalysis") return "AdvancedSpectrumCard.qml"
        if (widgetId === "bciOutput") return "AdvancedBciOutputCard.qml"
        if (widgetId === "performance") return "PerformanceMetricsCard.qml"
        if (widgetId === "eventLog") return "EventLogCard.qml"
        return "DefaultWidgetCard.qml"
    }

    function refresh() {
        if (contentLoader.item && typeof contentLoader.item.refresh === 'function') {
            contentLoader.item.refresh()
        }
    }
}