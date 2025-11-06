import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: nodeItem
    width: Math.max(220, contentLayout.width + 24)
    height: contentLayout.height + 20
    color: isSelected ? Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1) : theme.backgroundCard
    border.color: isSelected ? theme.primary : theme.border
    border.width: isSelected ? 2 : 1
    radius: 12
    opacity: isDragging ? 0.8 : 1.0

    // Properties
    property var theme: ({})
    property var nodeModel
    property bool isSelected: false
    property bool isDragging: false
    property bool multipleSelection: false
    property bool isExecuting: nodeModel ? nodeModel.status === "executing" : false

    readonly property bool isNodeItem: true
    readonly property string nodeId: nodeModel ? nodeModel.nodeId : ""

    // Signals
    signal selected(bool multiple)
    signal deselected()
    signal moved(point newPosition)
    signal connectionStarted(var port, var mouse)
    signal connectionFinished(var port)
    signal doubleClicked()
    signal contextMenuRequested(var mouse)

    // Shadow effect
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        radius: isSelected ? 12 : 8
        samples: 16
        color: "#40000000"
        verticalOffset: isSelected ? 3 : 2
    }

    // Animations
    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Behavior on border.color {
        ColorAnimation { duration: 200 }
    }

    Behavior on opacity {
        NumberAnimation { duration: 250 }
    }

    Behavior on scale {
        NumberAnimation { duration: 200; easing.type: Easing.OutBack }
    }

    // Execution animation
    SequentialAnimation on scale {
        running: isExecuting
        loops: Animation.Infinite
        NumberAnimation { to: 1.02; duration: 800; easing.type: Easing.InOutQuad }
        NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
    }

    // Main content layout
    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Node header
        Rectangle {
            id: nodeHeader
            Layout.fillWidth: true
            height: 36
            color: getCategoryColor()
            radius: 8

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 8

                // Node icon
                Rectangle {
                    width: 24
                    height: 24
                    radius: 6
                    color: "white"
                    opacity: 0.9
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        text: nodeModel ? nodeModel.icon : "⚙️"
                        font.pixelSize: 12
                        anchors.centerIn: parent
                    }
                }

                // Node title and info
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 1

                    Text {
                        text: nodeModel ? nodeModel.name : "Unknown Node"
                        color: "white"
                        font.family: "Segoe UI"
                        font.pixelSize: 12
                        font.bold: true
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: nodeModel ? nodeModel.category : "General"
                        color: "white"
                        opacity: 0.8
                        font.family: "Segoe UI"
                        font.pixelSize: 9
                        Layout.fillWidth: true
                    }
                }

                // Node status indicator
                Rectangle {
                    width: 10
                    height: 10
                    radius: 5
                    color: getStatusColor()
                    border.color: "white"
                    border.width: 1
                    Layout.alignment: Qt.AlignVCenter

                    // Pulse animation for active nodes
                    SequentialAnimation on opacity {
                        running: isExecuting || (nodeModel && nodeModel.status === "active")
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.4; duration: 1000 }
                        NumberAnimation { to: 1.0; duration: 1000 }
                    }
                }
            }
        }

        // Input ports section
        ColumnLayout {
            id: inputsColumn
            Layout.fillWidth: true
            spacing: 8
            visible: inputPorts.count > 0

            Text {
                text: "Inputs"
                color: theme.textSecondary
                font.family: "Segoe UI"
                font.pixelSize: 10
                font.bold: true
                Layout.alignment: Qt.AlignLeft
            }

            Repeater {
                id: inputPorts
                model: nodeModel ? getInputPorts(nodeModel.ports) : []

                delegate: PortItem {
                    Layout.fillWidth: true
                    portModel: modelData
                    isInput: true
                    theme: nodeItem.theme
                    onConnectionStarted: (port, mouse) => {
                        console.log("🔗 Input port connection started:", port.name)
                        var globalPos = mapToItem(null, mouse.x, mouse.y)
                        nodeItem.connectionStarted(port, globalPos)
                    }
                    onConnectionFinished: (port) => {
                        console.log("🔗 Input port connection finished:", port.name)
                        nodeItem.connectionFinished(port)
                    }
                }
            }
        }

        // Output ports section
        ColumnLayout {
            id: outputsColumn
            Layout.fillWidth: true
            spacing: 8
            visible: outputPorts.count > 0

            Text {
                text: "Outputs"
                color: theme.textSecondary
                font.family: "Segoe UI"
                font.pixelSize: 10
                font.bold: true
                Layout.alignment: Qt.AlignLeft
            }

            Repeater {
                id: outputPorts
                model: nodeModel ? getOutputPorts(nodeModel.ports) : []

                delegate: PortItem {
                    Layout.fillWidth: true
                    portModel: modelData
                    isInput: false
                    theme: nodeItem.theme
                    onConnectionStarted: (port, mouse) => {
                        console.log("🔗 Output port connection started:", port.name)
                        var globalPos = mapToItem(null, mouse.x, mouse.y)
                        nodeItem.connectionStarted(port, globalPos)
                    }
                    onConnectionFinished: (port) => {
                        console.log("🔗 Output port connection finished:", port.name)
                        nodeItem.connectionFinished(port)
                    }
                }
            }
        }
    }

    // Mouse area for selection and dragging
    MouseArea {
        id: mainMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        drag.threshold: 5
        hoverEnabled: true
        propagateComposedEvents: true

        property point dragStartPosition
        property bool isDraggingNode: false

        onPressed: (mouse) => {
            forceActiveFocus()
            console.log("🖱️ Node pressed:", nodeId)

            if (mouse.button === Qt.LeftButton) {
                dragStartPosition = Qt.point(nodeItem.x, nodeItem.y)

                if (mouse.modifiers & Qt.ControlModifier) {
                    // Multiple selection
                    nodeItem.selected(true)
                } else {
                    // Single selection
                    nodeItem.selected(false)
                }
            } else if (mouse.button === Qt.RightButton) {
                nodeItem.contextMenuRequested(mouse)
                mouse.accepted = true
            }
        }

        onPositionChanged: (mouse) => {
            if (pressed && (Math.abs(mouse.x - mouse.originX) > drag.threshold ||
                            Math.abs(mouse.y - mouse.originY) > drag.threshold)) {
                isDraggingNode = true
                nodeItem.z += 1 // Bring dragging node to front
            }
        }

        onReleased: (mouse) => {
            if (isDraggingNode) {
                isDraggingNode = false
                nodeItem.z -= 1 // Restore original z-index
                nodeItem.moved(Qt.point(nodeItem.x, nodeItem.y))
                console.log("📦 Node moved to:", nodeItem.x, nodeItem.y)
            }
        }

        onDoubleClicked: {
            console.log("🖱️ Node double clicked:", nodeId)
            nodeItem.doubleClicked()
        }

        onEntered: {
            if (!isSelected) {
                border.color = Qt.lighter(theme.border, 1.5)
            }
            nodeItem.scale = 1.02
        }

        onExited: {
            if (!isSelected) {
                border.color = theme.border
            }
            nodeItem.scale = 1.0
        }

        drag.target: isSelected ? nodeItem : undefined
        drag.axis: Drag.XAndYAxis
        drag.smoothed: true
    }

    // Helper functions
    function getInputPorts(ports) {
        if (!ports) return []
        return ports.filter(port => port.direction === "input")
    }

    function getOutputPorts(ports) {
        if (!ports) return []
        return ports.filter(port => port.direction === "output")
    }

    function getPortGlobalPosition(portId, isInput) {
        var ports = isInput ? inputPorts : outputPorts
        for (var i = 0; i < ports.count; i++) {
            var portItem = ports.itemAt(i)
            if (portItem && portItem.portModel && portItem.portModel.portId === portId) {
                var portCenter = portItem.mapToItem(null,
                    portItem.portCircle.x + portItem.portCircle.width/2,
                    portItem.portCircle.y + portItem.portCircle.height/2)
                return portCenter
            }
        }
        return null
    }

    function getCategoryColor() {
        if (!nodeModel) return theme.primary

        var category = nodeModel.category
        var colors = {
            "Data Acquisition": theme.primary,
            "Preprocessing": theme.secondary,
            "Feature Extraction": "#00E676",
            "Classification": "#FF4081",
            "BCI Paradigms": "#7C4DFF",
            "Visualization": "#FF9100",
            "Control": "#E040FB",
            "Utilities": "#00E5FF"
        }
        return colors[category] || theme.primary
    }

    function getStatusColor() {
        if (!nodeModel) return theme.textTertiary

        var status = nodeModel.status
        var colors = {
            "idle": theme.textTertiary,
            "active": theme.success,
            "executing": theme.warning,
            "error": theme.error,
            "disabled": theme.textDisabled
        }
        return colors[status] || theme.textTertiary
    }

    // Function to update node status
    function updateStatus(newStatus) {
        if (nodeModel) {
            nodeModel.status = newStatus
        }
    }

    // Function to enable/disable node
    function setEnabled(enabled) {
        if (nodeModel) {
            nodeModel.enabled = enabled
            opacity = enabled ? 1.0 : 0.5
        }
    }

    // Function to highlight node
    function highlight(temporary) {
        var originalBorder = border.color
        border.color = theme.accent
        border.width = 3

        if (temporary) {
            highlightTimer.start()
        }
    }

    // Highlight timer
    Timer {
        id: highlightTimer
        interval: 1000
        onTriggered: {
            border.color = isSelected ? theme.primary : theme.border
            border.width = isSelected ? 2 : 1
        }
    }

    Component.onCompleted: {
        console.log("🎯 NodeItem created:", nodeId, nodeModel ? nodeModel.name : "Unknown")
        console.log("📊 Node ports:", nodeModel && nodeModel.ports ? nodeModel.ports.length : 0)
    }

    Component.onDestruction: {
        console.log("🗑️ NodeItem destroyed:", nodeId)
    }
}
