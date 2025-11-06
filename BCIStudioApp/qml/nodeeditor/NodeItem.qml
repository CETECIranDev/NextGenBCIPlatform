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

    property var nodeModel
    property bool isSelected: false
    property bool isDragging: false
    property bool multipleSelection: false
    property bool isExecuting: nodeModel ? nodeModel.status === "executing" : false

    readonly property bool isNodeItem: true
    readonly property string nodeId: nodeModel ? nodeModel.nodeId : ""

    signal selected(bool multiple)
    signal deselected()
    signal moved(point newPosition)
    signal connectionStarted(var port, var mouse)
    signal connectionFinished(var port)
    signal doubleClicked()
    signal contextMenuRequested(var mouse)

    // سایه برای نود
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        radius: isSelected ? 12 : 8
        samples: 16
        color: "#40000000"
        verticalOffset: isSelected ? 3 : 2
    }

    // انیمیشن‌ها
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

    // انیمیشن اجرا برای نودهای در حال پردازش
    SequentialAnimation on scale {
        running: isExecuting
        loops: Animation.Infinite
        NumberAnimation { to: 1.02; duration: 800; easing.type: Easing.InOutQuad }
        NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
    }

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // هدر نود
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

                // آیکون نود
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

                // عنوان و اطلاعات نود
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

                // وضعیت نود
                Rectangle {
                    width: 10
                    height: 10
                    radius: 5
                    color: getStatusColor()
                    border.color: "white"
                    border.width: 1
                    Layout.alignment: Qt.AlignVCenter

                    // پالس انیمیشن برای نودهای فعال
                    SequentialAnimation on opacity {
                        running: isExecuting || (nodeModel && nodeModel.status === "active")
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.4; duration: 1000 }
                        NumberAnimation { to: 1.0; duration: 1000 }
                    }
                }
            }
        }

        // پورت‌های ورودی
        ColumnLayout {
            id: inputsColumn
            Layout.fillWidth: true
            spacing: 3
            visible: inputPorts.count > 0

            Repeater {
                id: inputPorts
                model: nodeModel ? getInputPorts(nodeModel.ports) : []

                delegate: PortItem {
                    Layout.fillWidth: true
                    portModel: modelData
                    isInput: true
                    onConnectionStarted: (port, mouse) => nodeItem.connectionStarted(port, mouse)
                    onConnectionFinished: (port) => nodeItem.connectionFinished(port)
                }
            }
        }

        // بدنه نود - پارامترها
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: parametersColumn.height + 12
            color: Qt.darker(theme.backgroundCard, 1.05)
            radius: 6
            visible: parametersColumn.visible

            ColumnLayout {
                id: parametersColumn
                width: parent.width - 12
                anchors.centerIn: parent
                spacing: 6

                Repeater {
                    model: nodeModel ? getVisibleParameters(nodeModel.parameters) : []

                    delegate: ParameterRow {
                        Layout.fillWidth: true
                        parameterName: modelData.name
                        parameterValue: modelData.value
                        parameterType: modelData.type
                        parameterOptions: modelData.options
                        onValueChanged: (newValue) => {
                            if (nodeModel && nodeModel.updateParameter) {
                                nodeModel.updateParameter(modelData.name, newValue)
                            }
                        }
                    }
                }
            }
        }

        // پورت‌های خروجی
        ColumnLayout {
            id: outputsColumn
            Layout.fillWidth: true
            spacing: 3
            visible: outputPorts.count > 0

            Repeater {
                id: outputPorts
                model: nodeModel ? getOutputPorts(nodeModel.ports) : []

                delegate: PortItem {
                    Layout.fillWidth: true
                    portModel: modelData
                    isInput: false
                    onConnectionStarted: (port, mouse) => nodeItem.connectionStarted(port, mouse)
                    onConnectionFinished: (port) => nodeItem.connectionFinished(port)
                }
            }
        }
    }

    // Mouse area for selection and dragging
    MouseArea {
        id: mainMouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        drag.threshold: 3
        hoverEnabled: true
        propagateComposedEvents: true

        onPressed: (mouse) => {
            forceActiveFocus()

            if (mouse.button === Qt.LeftButton) {
                if (multipleSelection) {
                    if (isSelected) {
                        nodeItem.deselected()
                    } else {
                        nodeItem.selected(true)
                    }
                } else {
                    nodeItem.selected(false)
                }
                dragTarget = nodeItem
                dragStartPos = Qt.point(nodeItem.x, nodeItem.y)
            } else if (mouse.button === Qt.RightButton) {
                nodeItem.contextMenuRequested(mouse)
                mouse.accepted = true
            }
        }

        onPositionChanged: (mouse) => {
            if (pressed && mainMouseArea.drag.active) {
                isDragging = true
                var newX = nodeItem.x + mouse.x - mouse.originX
                var newY = nodeItem.y + mouse.y - mouse.originY
                nodeItem.x = newX
                nodeItem.y = newY
            }
        }

        onReleased: (mouse) => {
            if (isDragging) {
                isDragging = false
                nodeItem.moved(Qt.point(nodeItem.x, nodeItem.y))
            }
        }

        onDoubleClicked: {
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

    // توابع کمکی
    function getInputPorts(ports) {
        if (!ports) return []
        return ports.filter(port => port.direction === 0 || port.direction === "input")
    }

    function getOutputPorts(ports) {
        if (!ports) return []
        return ports.filter(port => port.direction === 1 || port.direction === "output")
    }

    function getPortPosition(portId, isInput) {
        var ports = isInput ? inputPorts : outputPorts
        for (var i = 0; i < ports.count; i++) {
            var portItem = ports.itemAt(i)
            if (portItem && portItem.portModel && portItem.portModel.portId === portId) {
                var portCircle = portItem.children[0].children[0] // Assuming the port circle is the first child
                var portCenter = portItem.mapToItem(nodeItem.parent, portCircle.x + portCircle.width/2, portCircle.y + portCircle.height/2)
                return portCenter
            }
        }
        return Qt.point(nodeItem.x + (isInput ? 0 : nodeItem.width), nodeItem.y + nodeItem.height / 2)
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

    function getVisibleParameters(parameters) {
        if (!parameters) return []
        var visibleParams = []
        for (var key in parameters) {
            if (parameters[key].visible !== false) {
                visibleParams.push({
                    name: key,
                    value: parameters[key].value,
                    type: parameters[key].type || typeof parameters[key].value,
                    options: parameters[key].options,
                    description: parameters[key].description
                })
            }
        }
        return visibleParams
    }

    // تابع برای به‌روزرسانی وضعیت نود
    function updateStatus(newStatus) {
        if (nodeModel) {
            nodeModel.status = newStatus
        }
    }

    // تابع برای فعال/غیرفعال کردن نود
    function setEnabled(enabled) {
        if (nodeModel) {
            nodeModel.enabled = enabled
            opacity = enabled ? 1.0 : 0.5
        }
    }

    // تابع برای هایلایت نود
    function highlight(temporary) {
        var originalBorder = border.color
        border.color = theme.accent
        border.width = 3

        if (temporary) {
            highlightTimer.start()
        }
    }

    Timer {
        id: highlightTimer
        interval: 1000
        onTriggered: {
            border.color = isSelected ? theme.primary : theme.border
            border.width = isSelected ? 2 : 1
        }
    }

    Component.onCompleted: {
        console.log("NodeItem created:", nodeId, nodeModel ? nodeModel.name : "Unknown")
    }

    Component.onDestruction: {
        console.log("NodeItem destroyed:", nodeId)
    }
}
