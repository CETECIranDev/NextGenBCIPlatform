import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: propertiesPanel
    color: theme.backgroundSecondary
    border.color: theme.border
    border.width: 1
    radius: 12

    property var selectedNode: null
    property var nodeGraph: null
    property var theme: ({
        "backgroundPrimary": "#FFFFFF",
        "backgroundSecondary": "#F8F9FA",
        "backgroundTertiary": "#E9ECEF",
        "backgroundCard": "#FFFFFF",
        "primary": "#4361EE",
        "secondary": "#3A0CA3",
        "accent": "#7209B7",
        "success": "#4CC9F0",
        "warning": "#F72585",
        "error": "#EF476F",
        "info": "#4895EF",
        "textPrimary": "#212529",
        "textSecondary": "#6C757D",
        "textTertiary": "#ADB5BD",
        "textDisabled": "#CED4DA",
        "border": "#DEE2E6"
    })
    property bool hasChanges: false

    signal propertyChanged(string nodeId, string propertyName, var value)
    signal nodeDeleted(string nodeId)
    signal nodeDuplicated(string nodeId)
    signal nodeDisabled(string nodeId)
    signal nodeEnabled(string nodeId)

    // Shadow effect
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 4
        radius: 12
        samples: 17
        color: "#20000000"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header با طراحی مدرن
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: theme.backgroundCard
            radius: 12

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 16

                    // Icon Container
                    Rectangle {
                        width: 48
                        height: 48
                        radius: 12
                        color: theme.primary
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            text: selectedNode ? selectedNode.icon : "⚙️"
                            font.pixelSize: 20
                            color: "white"
                            anchors.centerIn: parent
                        }
                    }

                    // Title and Info
                    ColumnLayout {
                        spacing: 4
                        Layout.fillWidth: true

                        Text {
                            text: selectedNode ? selectedNode.name : "No Node Selected"
                            color: theme.textPrimary
                            font.family: "Segoe UI Semibold"
                            font.pixelSize: 18
                            font.weight: Font.DemiBold
                            elide: Text.ElideRight
                        }

                        Text {
                            text: selectedNode ? selectedNode.category : "Select a node to view properties"
                            color: theme.textSecondary
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                    }

                    // Action Buttons
                    RowLayout {
                        spacing: 8
                        Layout.alignment: Qt.AlignVCenter

                        // Duplicate Button
                        Rectangle {
                            width: 36
                            height: 36
                            radius: 8
                            color: theme.backgroundTertiary
                            Layout.alignment: Qt.AlignVCenter

                            Text {
                                text: "📋"
                                font.pixelSize: 16
                                color: theme.textPrimary
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (selectedNode) {
                                        propertiesPanel.nodeDuplicated(selectedNode.nodeId)
                                    }
                                }
                            }

                            ToolTip {
                                text: "Duplicate Node"
                                delay: 500
                            }
                        }

                        // Enable/Disable Button
                        Rectangle {
                            width: 36
                            height: 36
                            radius: 8
                            color: selectedNode && selectedNode.enabled === false ? theme.success : theme.warning
                            Layout.alignment: Qt.AlignVCenter
                            opacity: selectedNode ? 1.0 : 0.3

                            Text {
                                text: selectedNode && selectedNode.enabled === false ? "✅" : "⏸️"
                                font.pixelSize: 16
                                color: "white"
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: selectedNode ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: {
                                    if (selectedNode) {
                                        if (selectedNode.enabled === false) {
                                            propertiesPanel.nodeEnabled(selectedNode.nodeId)
                                        } else {
                                            propertiesPanel.nodeDisabled(selectedNode.nodeId)
                                        }
                                    }
                                }
                            }

                            ToolTip {
                                text: selectedNode && selectedNode.enabled === false ? "Enable Node" : "Disable Node"
                                delay: 500
                            }
                        }

                        // Delete Button
                        Rectangle {
                            width: 36
                            height: 36
                            radius: 8
                            color: theme.error
                            Layout.alignment: Qt.AlignVCenter
                            opacity: selectedNode ? 1.0 : 0.3

                            Text {
                                text: "🗑️"
                                font.pixelSize: 16
                                color: "white"
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: selectedNode ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: {
                                    if (selectedNode) {
                                        deleteConfirmationDialog.open()
                                    }
                                }
                            }

                            ToolTip {
                                text: "Delete Node"
                                delay: 500
                            }
                        }
                    }
                }

                // Changes Indicator
                Rectangle {
                    Layout.fillWidth: true
                    height: 3
                    radius: 2
                    color: hasChanges ? theme.warning : "transparent"
                    visible: hasChanges

                    Text {
                        text: "● Unsaved Changes"
                        color: theme.warning
                        font.family: "Segoe UI"
                        font.pixelSize: 10
                        font.weight: Font.Medium
                        anchors.centerIn: parent
                    }
                }
            }
        }

        // Content Area
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width
                spacing: 20
                anchors.margins: 20

                // Empty State
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    visible: !selectedNode

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 20
                        width: parent.width * 0.8

                        // Icon
                        Rectangle {
                            width: 80
                            height: 80
                            radius: 40
                            color: theme.backgroundTertiary
                            Layout.alignment: Qt.AlignCenter

                            Text {
                                text: "🎯"
                                font.pixelSize: 32
                                color: theme.textTertiary
                                anchors.centerIn: parent
                            }
                        }

                        // Text
                        ColumnLayout {
                            spacing: 8
                            Layout.alignment: Qt.AlignCenter

                            Text {
                                text: "Select a Node"
                                color: theme.textPrimary
                                font.family: "Segoe UI Semibold"
                                font.pixelSize: 18
                                font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignCenter
                            }

                            Text {
                                text: "Click on any node in the canvas to view and edit its properties"
                                color: theme.textSecondary
                                font.family: "Segoe UI"
                                font.pixelSize: 14
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }
                }

                // Node Content
                ColumnLayout {
                    visible: selectedNode !== null
                    spacing: 20
                    Layout.fillWidth: true

                    // Node Info Section
                    ColumnLayout {
                        spacing: 16
                        Layout.fillWidth: true

                        // Section Header
                        Text {
                            text: "NODE INFORMATION"
                            color: theme.textSecondary
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            Layout.fillWidth: true
                        }

                        // Info Card
                        Rectangle {
                            Layout.fillWidth: true
                            height: infoContent.height + 24
                            radius: 12
                            color: theme.backgroundCard
                            border.color: theme.border
                            border.width: 1

                            ColumnLayout {
                                id: infoContent
                                width: parent.width - 24
                                anchors.centerIn: parent
                                spacing: 16

                                // Main Info Row
                                RowLayout {
                                    spacing: 16
                                    Layout.fillWidth: true

                                    // Category Icon
                                    Rectangle {
                                        width: 60
                                        height: 60
                                        radius: 12
                                        color: getCategoryColor(selectedNode ? selectedNode.category : "")

                                        Text {
                                            text: selectedNode ? selectedNode.icon : "🧩"
                                            font.pixelSize: 24
                                            color: "white"
                                            anchors.centerIn: parent
                                        }
                                    }

                                    // Text Info
                                    ColumnLayout {
                                        spacing: 6
                                        Layout.fillWidth: true

                                        Text {
                                            text: selectedNode ? selectedNode.name : "Unknown"
                                            color: theme.textPrimary
                                            font.family: "Segoe UI Semibold"
                                            font.pixelSize: 16
                                            font.weight: Font.DemiBold
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            text: selectedNode ? selectedNode.category : "Unknown"
                                            color: getCategoryColor(selectedNode ? selectedNode.category : "")
                                            font.family: "Segoe UI"
                                            font.pixelSize: 12
                                            font.weight: Font.Medium
                                        }

                                        Text {
                                            text: selectedNode ? (selectedNode.description || "No description available") : "No description"
                                            color: theme.textSecondary
                                            font.family: "Segoe UI"
                                            font.pixelSize: 11
                                            wrapMode: Text.WordWrap
                                            Layout.fillWidth: true
                                        }
                                    }
                                }

                                // Status Grid
                                GridLayout {
                                    columns: 2
                                    columnSpacing: 20
                                    rowSpacing: 12
                                    Layout.fillWidth: true

                                    // Status
                                    StatusItem {
                                        label: "Status"
                                        value: getStatusText(selectedNode ? selectedNode.status : 0)
                                        color: getStatusColor(selectedNode ? selectedNode.status : 0)
                                        icon: getStatusIcon(selectedNode ? selectedNode.status : 0)
                                    }

                                    // Enabled
                                    StatusItem {
                                        label: "Enabled"
                                        value: selectedNode && selectedNode.enabled === false ? "Disabled" : "Enabled"
                                        color: selectedNode && selectedNode.enabled === false ? theme.error : theme.success
                                        icon: selectedNode && selectedNode.enabled === false ? "❌" : "✅"
                                    }

                                    // Node ID
                                    StatusItem {
                                        label: "Node ID"
                                        value: selectedNode ? selectedNode.nodeId.substring(0, 8) + "..." : "N/A"
                                        color: theme.textTertiary
                                        icon: "🆔"
                                        Layout.columnSpan: 2
                                    }
                                }
                            }
                        }
                    }

                    // Ports Section
                    ColumnLayout {
                        spacing: 16
                        Layout.fillWidth: true
                        visible: portsRepeater.count > 0

                        // Section Header
                        Text {
                            text: "PORTS"
                            color: theme.textSecondary
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            Layout.fillWidth: true
                        }

                        // Ports Card
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: portsColumn.height + 24
                            radius: 12
                            color: theme.backgroundCard
                            border.color: theme.border
                            border.width: 1

                            ColumnLayout {
                                id: portsColumn
                                width: parent.width - 24
                                anchors.centerIn: parent
                                spacing: 12

                                Repeater {
                                    id: portsRepeater
                                    model: selectedNode ? getPorts(selectedNode) : []

                                    delegate: PortItem {
                                        portName: modelData.name
                                        portType: modelData.dataType
                                        portDirection: modelData.direction
                                        isConnected: modelData.connected || false
                                        Layout.fillWidth: true
                                    }
                                }
                            }
                        }
                    }

                    // Parameters Section
                    ColumnLayout {
                        spacing: 16
                        Layout.fillWidth: true
                        visible: parametersRepeater.count > 0

                        // Section Header
                        Text {
                            text: "PARAMETERS"
                            color: theme.textSecondary
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            Layout.fillWidth: true
                        }

                        // Parameters Card
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: parametersColumn.height + 24
                            radius: 12
                            color: theme.backgroundCard
                            border.color: theme.border
                            border.width: 1

                            ColumnLayout {
                                id: parametersColumn
                                width: parent.width - 24
                                anchors.centerIn: parent
                                spacing: 16

                                Repeater {
                                    id: parametersRepeater
                                    model: selectedNode ? getEditableParameters(selectedNode.parameters) : []

                                    delegate: ParameterEditor {
                                        paramName: modelData.name
                                        paramValue: modelData.value
                                        paramType: modelData.type
                                        paramOptions: modelData.options
                                        paramMin: modelData.min
                                        paramMax: modelData.max
                                        paramStep: modelData.step
                                        paramDescription: modelData.description
                                        paramUnit: modelData.unit || ""
                                        paramAdvanced: modelData.advanced || false
                                        paramReadOnly: modelData.readOnly || false
                                        Layout.fillWidth: true

                                        onValueChanged: (newValue) => {
                                            propertiesPanel.hasChanges = true
                                            propertiesPanel.propertyChanged(selectedNode.nodeId, modelData.name, newValue)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Documentation Section
                    ColumnLayout {
                        spacing: 16
                        Layout.fillWidth: true
                        visible: selectedNode && selectedNode.documentation

                        // Section Header
                        Text {
                            text: "DOCUMENTATION"
                            color: theme.textSecondary
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            font.weight: Font.Medium
                            Layout.fillWidth: true
                        }

                        // Documentation Card
                        Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: docText.height + 24
                            radius: 12
                            color: theme.backgroundCard
                            border.color: theme.border
                            border.width: 1

                            Text {
                                id: docText
                                text: selectedNode ? selectedNode.documentation : ""
                                color: theme.textSecondary
                                font.family: "Segoe UI"
                                font.pixelSize: 12
                                wrapMode: Text.WordWrap
                                lineHeight: 1.4
                                width: parent.width - 24
                                anchors.centerIn: parent
                            }
                        }
                    }

                    // Action Buttons
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        visible: selectedNode !== null

                        // Reset Button
                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            radius: 8
                            color: "transparent"
                            border.color: theme.border
                            border.width: 1
                            opacity: hasChanges ? 1.0 : 0.5

                            Text {
                                text: "↶ Reset Changes"
                                color: hasChanges ? theme.textPrimary : theme.textDisabled
                                font.family: "Segoe UI"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: hasChanges ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: {
                                    if (hasChanges) {
                                        propertiesPanel.resetChanges()
                                    }
                                }
                            }
                        }

                        // Apply Button
                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            radius: 8
                            color: hasChanges ? theme.success : theme.backgroundTertiary
                            opacity: hasChanges ? 1.0 : 0.5

                            Text {
                                text: "✓ Apply Changes"
                                color: hasChanges ? "white" : theme.textDisabled
                                font.family: "Segoe UI"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                anchors.centerIn: parent
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: hasChanges ? Qt.PointingHandCursor : Qt.ArrowCursor
                                onClicked: {
                                    if (hasChanges) {
                                        propertiesPanel.applyChanges()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Confirmation Dialog for Delete
    Popup {
        id: deleteConfirmationDialog
        width: 400
        height: 200
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        anchors.centerIn: Overlay.overlay

        background: Rectangle {
            color: theme.backgroundCard
            radius: 16
            border.color: theme.border
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 16

            // Header
            RowLayout {
                spacing: 12
                Layout.fillWidth: true

                Rectangle {
                    width: 40
                    height: 40
                    radius: 20
                    color: theme.error

                    Text {
                        text: "⚠️"
                        font.pixelSize: 20
                        anchors.centerIn: parent
                    }
                }

                Text {
                    text: "Delete Node"
                    color: theme.textPrimary
                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 18
                    font.weight: Font.DemiBold
                    Layout.fillWidth: true
                }
            }

            // Message
            Text {
                text: "Are you sure you want to delete this node? This action cannot be undone."
                color: theme.textSecondary
                font.family: "Segoe UI"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            // Buttons
            RowLayout {
                spacing: 12
                Layout.fillWidth: true

                // Cancel Button
                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: 8
                    color: theme.backgroundTertiary

                    Text {
                        text: "Cancel"
                        color: theme.textPrimary
                        font.family: "Segoe UI"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: deleteConfirmationDialog.close()
                    }
                }

                // Delete Button
                Rectangle {
                    Layout.fillWidth: true
                    height: 40
                    radius: 8
                    color: theme.error

                    Text {
                        text: "Delete"
                        color: "white"
                        font.family: "Segoe UI"
                        font.pixelSize: 14
                        font.weight: Font.Medium
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            propertiesPanel.nodeDeleted(selectedNode.nodeId)
                            deleteConfirmationDialog.close()
                        }
                    }
                }
            }
        }
    }

    // کامپوننت Status Item
    component StatusItem: RowLayout {
        property string label: ""
        property string value: ""
        property color color: theme.textPrimary
        property string icon: ""

        spacing: 8
        Layout.fillWidth: true

        Text {
            text: parent.icon
            font.pixelSize: 14
            color: parent.color
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true

            Text {
                text: parent.parent.label
                color: theme.textSecondary
                font.family: "Segoe UI"
                font.pixelSize: 11
            }

            Text {
                text: parent.parent.value
                color: parent.parent.color
                font.family: "Segoe UI"
                font.pixelSize: 12
                font.weight: Font.Medium
                elide: Text.ElideRight
            }
        }
    }

    // کامپوننت Port Item
    component PortItem: RowLayout {
        property string portName: ""
        property string portType: ""
        property string portDirection: "input"
        property bool isConnected: false

        spacing: 12
        Layout.fillWidth: true

        // Port Circle
        Rectangle {
            width: 16
            height: 16
            radius: 8
            color: getPortColor()
            border.color: theme.border
            border.width: 1
            Layout.alignment: Qt.AlignVCenter

            // Connection Indicator
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: isConnected ? theme.success : theme.textDisabled
                anchors.centerIn: parent
                visible: isConnected
            }
        }

        // Port Info
        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true

            Text {
                text: portName
                color: theme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 12
                elide: Text.ElideRight
            }

            Text {
                text: getDataTypeAbbreviation(portType)
                color: theme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 10
            }
        }

        // Direction Indicator
        Text {
            text: portDirection === "input" ? "← IN" : "OUT →"
            color: theme.textTertiary
            font.family: "Segoe UI"
            font.pixelSize: 10
            font.weight: Font.Medium
            Layout.alignment: Qt.AlignVCenter
        }

        function getPortColor() {
            var colors = {
                "EEGSignal": theme.primary,
                "ECGSignal": theme.secondary,
                "EMGSignal": theme.accent,
                "FeatureVector": theme.success,
                "ClassificationResult": theme.warning,
                "ControlSignal": theme.info,
                "SignalData": theme.error
            }
            return colors[portType] || theme.textTertiary
        }

        function getDataTypeAbbreviation(dataType) {
            var abbreviations = {
                "EEGSignal": "EEG",
                "ECGSignal": "ECG",
                "EMGSignal": "EMG",
                "FeatureVector": "FEAT",
                "ClassificationResult": "CLASS",
                "ControlSignal": "CTRL",
                "SignalData": "SIG"
            }
            return abbreviations[dataType] || dataType
        }
    }

    // کامپوننت Parameter Editor
    component ParameterEditor: ColumnLayout {
        property string paramName: ""
        property var paramValue
        property string paramType: "string"
        property var paramOptions: []
        property real paramMin: 0
        property real paramMax: 100
        property real paramStep: 1
        property string paramDescription: ""
        property string paramUnit: ""
        property bool paramAdvanced: false
        property bool paramReadOnly: false

        signal valueChanged(var newValue)

        spacing: 8
        Layout.fillWidth: true

        // Parameter Header
        RowLayout {
            spacing: 8
            Layout.fillWidth: true

            Text {
                text: paramName
                color: theme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 14
                font.weight: Font.Medium
                Layout.fillWidth: true
            }

            Text {
                text: paramAdvanced ? "ADVANCED" : ""
                color: theme.warning
                font.family: "Segoe UI"
                font.pixelSize: 10
                font.weight: Font.Medium
                visible: paramAdvanced
            }
        }

        // Editor based on type
        Loader {
            sourceComponent: getEditorComponent()
            Layout.fillWidth: true
        }

        // Description
        Text {
            text: paramDescription
            color: theme.textSecondary
            font.family: "Segoe UI"
            font.pixelSize: 11
            wrapMode: Text.WordWrap
            visible: paramDescription !== ""
            Layout.fillWidth: true
        }

        function getEditorComponent() {
            switch(paramType) {
                case "number": return numberEditorComponent
                case "boolean": return booleanEditorComponent
                case "string": return stringEditorComponent
                case "options": return optionsEditorComponent
                default: return stringEditorComponent
            }
        }
    }

    // Number Editor Component
    Component {
        id: numberEditorComponent

        ColumnLayout {
            spacing: 8

            // Slider and Input
            RowLayout {
                spacing: 12
                Layout.fillWidth: true

                Slider {
                    id: slider
                    from: parent.parent.paramMin
                    to: parent.parent.paramMax
                    value: parent.parent.paramValue || 0
                    stepSize: parent.parent.paramStep
                    Layout.fillWidth: true
                    enabled: !parent.parent.paramReadOnly

                    background: Rectangle {
                        x: slider.leftPadding
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: 4
                        width: slider.availableWidth
                        height: implicitHeight
                        radius: 2
                        color: theme.border

                        Rectangle {
                            width: slider.visualPosition * parent.width
                            height: parent.height
                            color: theme.primary
                            radius: 2
                        }
                    }

                    handle: Rectangle {
                        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                        y: slider.topPadding + slider.availableHeight / 2 - height / 2
                        implicitWidth: 20
                        implicitHeight: 20
                        radius: 10
                        color: slider.pressed ? theme.primary : theme.backgroundCard
                        border.color: theme.primary
                        border.width: 2
                    }

                    onMoved: {
                        parent.parent.valueChanged(value)
                    }
                }

                // Number Input
                Rectangle {
                    width: 80
                    height: 36
                    radius: 6
                    color: theme.backgroundPrimary
                    border.color: theme.border
                    border.width: 1

                    TextInput {
                        anchors.fill: parent
                        anchors.margins: 8
                        text: slider.value.toFixed(2)
                        color: theme.textPrimary
                        font.family: "Segoe UI"
                        font.pixelSize: 12
                        verticalAlignment: Text.AlignVCenter
                        validator: DoubleValidator {
                            bottom: slider.from
                            top: slider.to
                        }
                        readOnly: parent.parent.parent.paramReadOnly

                        onEditingFinished: {
                            var newValue = Number(text)
                            if (!isNaN(newValue)) {
                                slider.value = newValue
                                parent.parent.parent.valueChanged(newValue)
                            }
                        }
                    }
                }
            }

            // Min/Max Labels
            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: parent.parent.paramMin
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 10
                }

                Text {
                    text: parent.parent.paramUnit || ""
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 10
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: parent.parent.paramMax
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 10
                    Layout.alignment: Qt.AlignRight
                }
            }
        }
    }

    // Boolean Editor Component
    Component {
        id: booleanEditorComponent

        RowLayout {
            spacing: 12

            // Toggle Switch
            Rectangle {
                width: 50
                height: 24
                radius: 12
                color: (parent.parent.paramValue ? theme.success : theme.backgroundTertiary)
                Layout.alignment: Qt.AlignVCenter

                Rectangle {
                    x: parent.parent.paramValue ? parent.width - width - 2 : 2
                    y: 2
                    width: 20
                    height: 20
                    radius: 10
                    color: "white"
                    Behavior on x { NumberAnimation { duration: 200 } }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: parent.parent.parent.paramReadOnly ? Qt.ArrowCursor : Qt.PointingHandCursor
                    onClicked: {
                        if (!parent.parent.parent.paramReadOnly) {
                            var newValue = !parent.parent.paramValue
                            parent.parent.valueChanged(newValue)
                        }
                    }
                }
            }

            Text {
                text: parent.parent.paramValue ? "Enabled" : "Disabled"
                color: theme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 12
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    // String Editor Component
    Component {
        id: stringEditorComponent

        Rectangle {
            height: 36
            radius: 6
            color: theme.backgroundPrimary
            border.color: theme.border
            border.width: 1
            Layout.fillWidth: true

            TextInput {
                anchors.fill: parent
                anchors.margins: 8
                text: parent.parent.parent.paramValue !== undefined ? String(parent.parent.parent.paramValue) : ""
                color: theme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter
                readOnly: parent.parent.parent.paramReadOnly

                onEditingFinished: {
                    if (!parent.parent.parent.paramReadOnly) {
                        parent.parent.parent.valueChanged(text)
                    }
                }
            }
        }
    }

    // Options Editor Component
    Component {
        id: optionsEditorComponent

        Rectangle {
            height: 36
            radius: 6
            color: theme.backgroundPrimary
            border.color: theme.border
            border.width: 1
            Layout.fillWidth: true

            RowLayout {
                anchors.fill: parent
                anchors.margins: 8

                Text {
                    text: parent.parent.parent.paramValue !== undefined ? String(parent.parent.parent.paramValue) : ""
                    color: theme.textPrimary
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    Layout.fillWidth: true
                }

                Text {
                    text: "▼"
                    color: theme.textTertiary
                    font.pixelSize: 10
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: parent.parent.parent.paramReadOnly ? Qt.ArrowCursor : Qt.PointingHandCursor
                onClicked: {
                    if (!parent.parent.parent.paramReadOnly) {
                        optionsMenu.popup()
                    }
                }
            }

            Menu {
                id: optionsMenu

                Repeater {
                    model: parent.parent.parent.paramOptions || []

                    delegate: MenuItem {
                        text: modelData
                        onTriggered: {
                            parent.parent.parent.parent.valueChanged(modelData)
                        }
                    }
                }
            }
        }
    }

    // توابع کمکی
    function getPorts(node) {
        if (!node || !node.ports) return []
        return node.ports
    }

    function getCategoryColor(category) {
        var colors = {
            "Data Acquisition": "#4ECDC4",
            "Preprocessing": "#FFD166",
            "Feature Extraction": "#06D6A0",
            "Classification": "#EF476F",
            "BCI Paradigms": "#118AB2",
            "Visualization": "#7209B7",
            "Control": "#F15BB5",
            "Utilities": "#8A8AA8"
        }
        return colors[category] || theme.primary
    }

    function getStatusText(status) {
        switch(status) {
            case 1: return "Running"
            case 2: return "Error"
            case 3: return "Warning"
            case 4: return "Processing"
            default: return "Ready"
        }
    }

    function getStatusColor(status) {
        switch(status) {
            case 1: return theme.success
            case 2: return theme.error
            case 3: return theme.warning
            case 4: return theme.info
            default: return theme.textTertiary
        }
    }

    function getStatusIcon(status) {
        switch(status) {
            case 1: return "⚡"
            case 2: return "❌"
            case 3: return "⚠️"
            case 4: return "🔄"
            default: return "✅"
        }
    }

    function getEditableParameters(parameters) {
        if (!parameters) return []
        var editable = []
        for (var key in parameters) {
            if (parameters[key].editable !== false) {
                editable.push({
                    name: key,
                    value: parameters[key].value,
                    type: parameters[key].type || typeof parameters[key].value,
                    options: parameters[key].options,
                    min: parameters[key].min,
                    max: parameters[key].max,
                    step: parameters[key].step,
                    description: parameters[key].description,
                    unit: parameters[key].unit,
                    advanced: parameters[key].advanced,
                    readOnly: parameters[key].readOnly
                })
            }
        }
        return editable
    }

    function resetChanges() {
        hasChanges = false
        // در اینجا باید مقادیر پارامترها به حالت اولیه بازگردند
        console.log("Changes reset")
    }

    function applyChanges() {
        hasChanges = false
        // در اینجا تغییرات اعمال می‌شوند
        console.log("Changes applied")
    }

    Component.onCompleted: {
        console.log("NodePropertiesPanel initialized with modern flat design")
    }
}
