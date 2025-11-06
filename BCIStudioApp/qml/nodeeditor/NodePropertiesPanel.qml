import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: nodePropertiesPanel
    color: appTheme.backgroundSecondary
    radius: 12

    property var selectedNode: null
    property var nodeGraph: null
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
        verticalOffset: 2
        radius: 8
        samples: 17
        color: "#20000000"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header با طراحی مدرن
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: appTheme.backgroundTertiary
            radius: 12

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Rectangle {
                        width: 40
                        height: 40
                        radius: 8
                        color: appTheme.primary
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            text: "⚙️"
                            font.pixelSize: 18
                            color: "white"
                            anchors.centerIn: parent
                        }
                    }

                    ColumnLayout {
                        spacing: 2
                        Layout.fillWidth: true

                        Text {
                            text: "Node Properties"
                            color: appTheme.textPrimary
                            font.family: "Segoe UI Semibold"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: selectedNode ? selectedNode.name : "No node selected"
                            color: appTheme.textTertiary
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                    }

                    // Action Buttons
                    RowLayout {
                        spacing: 6
                        Layout.alignment: Qt.AlignVCenter

                        ActionButton {
                            icon: "📋"
                            tooltip: "Duplicate Node"
                            enabled: selectedNode !== null
                            onClicked: nodePropertiesPanel.nodeDuplicated(selectedNode.nodeId)
                        }

                        ActionButton {
                            icon: selectedNode && selectedNode.enabled === false ? "✅" : "⏸️"
                            tooltip: selectedNode && selectedNode.enabled === false ? "Enable Node" : "Disable Node"
                            enabled: selectedNode !== null
                            accent: selectedNode && selectedNode.enabled === false
                            onClicked: {
                                if (selectedNode.enabled === false) {
                                    nodePropertiesPanel.nodeEnabled(selectedNode.nodeId)
                                } else {
                                    nodePropertiesPanel.nodeDisabled(selectedNode.nodeId)
                                }
                            }
                        }

                        ActionButton {
                            icon: "🗑️"
                            tooltip: "Delete Node"
                            enabled: selectedNode !== null
                            accent: true
                            onClicked: {
                                deleteConfirmationDialog.open()
                            }
                        }
                    }
                }

                // Changes Indicator
                Rectangle {
                    Layout.fillWidth: true
                    height: 3
                    radius: 2
                    color: hasChanges ? appTheme.warning : "transparent"
                    visible: hasChanges

                    Text {
                        text: "● Unsaved Changes"
                        color: appTheme.warning
                        font.family: "Segoe UI"
                        font.pixelSize: 9
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
                spacing: 16
                anchors.margins: 12


                // Empty State
                EmptyState {
                    visible: !selectedNode
                    title: "Select a Node"
                    description: "Click on any node in the canvas to view and edit its properties"
                    icon: "🎯"
                    Layout.fillWidth: true
                    Layout.topMargin: 40
                }

                // Node Content
                ColumnLayout {
                    visible: selectedNode !== null
                    spacing: 16
                    Layout.fillWidth: true

                    // Node Info Card
                    InfoCard {
                        Layout.fillWidth: true
                        title: "NODE INFO"
                        icon: "📄"
                        color: appTheme.info

                        ColumnLayout {
                            width: parent.width
                            spacing: 12

                            RowLayout {
                                spacing: 12
                                Layout.fillWidth: true

                                Rectangle {
                                    width: 48
                                    height: 48
                                    radius: 8
                                    color: getCategoryColor(selectedNode ? selectedNode.category : "")

                                    Text {
                                        text: selectedNode ? selectedNode.icon : "🧩"
                                        font.pixelSize: 20
                                        color: "white"
                                        anchors.centerIn: parent
                                    }
                                }

                                ColumnLayout {
                                    spacing: 4
                                    Layout.fillWidth: true

                                    Text {
                                        text: selectedNode ? selectedNode.name : "Unknown"
                                        color: appTheme.textPrimary
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
                                        text: selectedNode ? selectedNode.description : "No description"
                                        color: appTheme.textSecondary
                                        font.family: "Segoe UI"
                                        font.pixelSize: 11
                                        wrapMode: Text.WordWrap
                                        Layout.fillWidth: true
                                    }
                                }
                            }

                            // Status & ID
                            GridLayout {
                                columns: 2
                                columnSpacing: 16
                                rowSpacing: 8
                                Layout.fillWidth: true

                                StatusBadge {
                                    label: "Status"
                                    value: getStatusText(selectedNode ? selectedNode.status : 0)
                                    color: getStatusColor(selectedNode ? selectedNode.status : 0)
                                    icon: getStatusIcon(selectedNode ? selectedNode.status : 0)
                                }

                                StatusBadge {
                                    label: "Enabled"
                                    value: selectedNode && selectedNode.enabled === false ? "Disabled" : "Enabled"
                                    color: selectedNode && selectedNode.enabled === false ? appTheme.error : appTheme.success
                                    icon: selectedNode && selectedNode.enabled === false ? "❌" : "✅"
                                }

                                StatusBadge {
                                    label: "Node ID"
                                    value: selectedNode ? selectedNode.nodeId.substring(0, 8) + "..." : "N/A"
                                    color: appTheme.textTertiary
                                    icon: "🆔"
                                    Layout.columnSpan: 2
                                }
                            }
                        }
                    }

                    // Ports Card
                    InfoCard {
                        Layout.fillWidth: true
                        title: "PORTS"
                        icon: "🔌"
                        color: appTheme.secondary
                        visible: portsRepeater.count > 0

                        ColumnLayout {
                            width: parent.width
                            spacing: 8

                            Repeater {
                                id: portsRepeater
                                model: selectedNode ? getPorts(selectedNode) : []

                                delegate: PortItem {
                                    portName: modelData.name
                                    portType: modelData.dataType
                                    direction: modelData.direction
                                    isConnected: modelData.connected || false
                                    Layout.fillWidth: true
                                }
                            }
                        }
                    }

                    // Parameters Card
                    InfoCard {
                        Layout.fillWidth: true
                        title: "PARAMETERS"
                        icon: "🎛️"
                        color: appTheme.primary
                        visible: parametersRepeater.count > 0

                        ColumnLayout {
                            width: parent.width
                            spacing: 12

                            Repeater {
                                id: parametersRepeater
                                model: selectedNode ? getEditableParameters(selectedNode.parameters) : []

                                delegate: ParameterEditor {
                                    parameterName: modelData.name
                                    parameterValue: modelData.value
                                    parameterType: modelData.type
                                    parameterOptions: modelData.options
                                    parameterMin: modelData.min
                                    parameterMax: modelData.max
                                    parameterStep: modelData.step
                                    parameterDescription: modelData.description
                                    Layout.fillWidth: true

                                    onValueChanged: (newValue) => {
                                        nodePropertiesPanel.hasChanges = true
                                        nodePropertiesPanel.propertyChanged(selectedNode.nodeId, modelData.name, newValue)
                                    }
                                }
                            }
                        }
                    }

                    // Documentation Card
                    InfoCard {
                        Layout.fillWidth: true
                        title: "DOCUMENTATION"
                        icon: "📖"
                        color: appTheme.warning
                        visible: selectedNode && selectedNode.documentation

                        Text {
                            text: selectedNode ? selectedNode.documentation : ""
                            color: appTheme.textSecondary
                            font.family: "Segoe UI"
                            font.pixelSize: 11
                            wrapMode: Text.WordWrap
                            lineHeight: 1.4
                            Layout.fillWidth: true
                        }
                    }

                    // Action Buttons
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        visible: selectedNode !== null

                        // Reset Button با آیکون متن
                        Button {
                            text: "↶ Reset"
                            enabled: hasChanges
                            Layout.fillWidth: true
                            onClicked: {
                                nodePropertiesPanel.resetChanges()
                            }

                            background: Rectangle {
                                color: "transparent"
                                border.color: appTheme.border
                                border.width: 1
                                radius: 6
                            }

                            contentItem: Text {
                                text: parent.text
                                color: appTheme.textPrimary
                                font.family: "Segoe UI"
                                font.pixelSize: 12
                                font.weight: Font.Medium
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                        // Apply Button با آیکون متن
                        Button {
                            text: "✓ Apply"
                            enabled: hasChanges
                            Layout.fillWidth: true
                            onClicked: {
                                nodePropertiesPanel.applyChanges()
                            }

                            background: Rectangle {
                                color: appTheme.success
                                radius: 6
                            }

                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.family: "Segoe UI"
                                font.pixelSize: 12
                                font.weight: Font.Medium
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }
        }
    }

    // Confirmation Dialog for Delete
    Dialog {
        id: deleteConfirmationDialog
        title: "Delete Node"
        modal: true
        standardButtons: Dialog.Yes | Dialog.No

        ColumnLayout {
            spacing: 16

            Text {
                text: "Are you sure you want to delete this node?"
                color: appTheme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Text {
                text: "This action cannot be undone."
                color: appTheme.error
                font.family: "Segoe UI"
                font.pixelSize: 12
                font.weight: Font.Medium
                Layout.fillWidth: true
            }
        }

        onAccepted: {
            nodePropertiesPanel.nodeDeleted(selectedNode.nodeId)
        }
    }

    // Custom Components
    component InfoCard: Rectangle {
        property string title: ""
        property string icon: ""
        //property color color: appTheme.primary

        Layout.fillWidth: true
        implicitHeight: content.height + 24
        radius: 8
        color: appTheme.backgroundCard
        border.color: appTheme.border
        border.width: 1

        ColumnLayout {
            id: content
            width: parent.width - 24
            anchors.centerIn: parent
            spacing: 12

            // Header
            RowLayout {
                spacing: 8
                Layout.fillWidth: true

                Rectangle {
                    width: 24
                    height: 24
                    radius: 6
                    color: parent.parent.parent.color

                    Text {
                        text: parent.parent.parent.icon
                        font.pixelSize: 12
                        color: "white"
                        anchors.centerIn: parent
                    }
                }

                Text {
                    text: parent.parent.parent.title
                    color: appTheme.textPrimary
                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 12
                    font.weight: Font.DemiBold
                    Layout.fillWidth: true
                }
            }

            // Content
            ColumnLayout {
                spacing: 8
                Layout.fillWidth: true
            }
        }
    }

    component ActionButton: Rectangle {
        property string icon: ""
        property string tooltip: ""
        property bool enabled: true
        property bool accent: false

        width: 32
        height: 32
        radius: 6
        color: mouseArea.containsPress ?
               (accent ? Qt.darker(appTheme.error, 1.2) : Qt.darker(appTheme.primary, 1.2)) :
               (mouseArea.containsMouse ?
                (accent ? Qt.lighter(appTheme.error, 1.1) : Qt.lighter(appTheme.primary, 1.1)) :
                (accent ? appTheme.error : appTheme.backgroundTertiary))
        opacity: enabled ? 1.0 : 0.3

        Text {
            text: parent.icon
            font.pixelSize: 12
            color: "white"
            anchors.centerIn: parent
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: parent.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: if (parent.enabled) parent.clicked()
        }

        ToolTip {
            text: parent.tooltip
            visible: mouseArea.containsMouse && parent.enabled
        }

        signal clicked()

        Behavior on color {
            ColorAnimation { duration: 200 }
        }
    }

    component EmptyState: ColumnLayout {
        property string title: ""
        property string description: ""
        property string icon: ""

        spacing: 16

        Rectangle {
            width: 80
            height: 80
            radius: 40
            color: appTheme.backgroundTertiary
            Layout.alignment: Qt.AlignCenter

            Text {
                text: parent.parent.icon
                font.pixelSize: 32
                color: appTheme.textTertiary
                anchors.centerIn: parent
            }
        }

        ColumnLayout {
            spacing: 4
            Layout.alignment: Qt.AlignCenter

            Text {
                text: parent.parent.title
                color: appTheme.textPrimary
                font.family: "Segoe UI Semibold"
                font.pixelSize: 16
                font.weight: Font.DemiBold
                Layout.alignment: Qt.AlignCenter
            }

            Text {
                text: parent.parent.description
                color: appTheme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                Layout.preferredWidth: 200
            }
        }
    }

    component StatusBadge: RowLayout {
        property string label: ""
        property string value: ""
        property color color: appTheme.primary
        property string icon: ""

        spacing: 6

        Text {
            text: parent.icon
            font.pixelSize: 12
            color: parent.color
        }

        Text {
            text: parent.label + ":"
            color: appTheme.textSecondary
            font.family: "Segoe UI"
            font.pixelSize: 11
        }

        Text {
            text: parent.value
            color: parent.color
            font.family: "Segoe UI"
            font.pixelSize: 11
            font.weight: Font.Medium
            Layout.fillWidth: true
        }
    }

    component PortItem: RowLayout {
        property string portName: ""
        property string portType: ""
        property int direction: 0 // 0: input, 1: output
        property bool isConnected: false

        spacing: 8

        Rectangle {
            width: 8
            height: 8
            radius: 4
            color: getPortColor(parent.portType)
            border.color: appTheme.border
            border.width: 1
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            spacing: 1
            Layout.fillWidth: true

            Text {
                text: parent.parent.portName
                color: appTheme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 12
                elide: Text.ElideRight
            }

            Text {
                text: getDataTypeAbbreviation(parent.parent.portType)
                color: appTheme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 9
            }
        }

        RowLayout {
            spacing: 4
            Layout.alignment: Qt.AlignVCenter

            Rectangle {
                width: 6
                height: 6
                radius: 3
                color: parent.parent.isConnected ? appTheme.success : appTheme.textDisabled
            }

            Text {
                text: parent.parent.direction === 0 ? "IN" : "OUT"
                color: appTheme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 9
                font.weight: Font.Medium
            }
        }
    }

    component ParameterEditor: ColumnLayout {
        property string parameterName: ""
        property var parameterValue
        property string parameterType: "string"
        property var parameterOptions: []
        property real parameterMin: 0
        property real parameterMax: 100
        property real parameterStep: 1
        property string parameterDescription: ""

        signal valueChanged(var newValue)

        spacing: 6

        Text {
            text: parameterName
            color: appTheme.textSecondary
            font.family: "Segoe UI"
            font.pixelSize: 12
            Layout.fillWidth: true
        }

        Loader {
            sourceComponent: getEditorComponent()
            Layout.fillWidth: true
        }

        Text {
            text: parameterDescription
            color: appTheme.textTertiary
            font.family: "Segoe UI"
            font.pixelSize: 10
            wrapMode: Text.WordWrap
            visible: parameterDescription !== ""
            Layout.fillWidth: true
        }

        function getEditorComponent() {
            switch(parameterType) {
                case "number": return numberEditorComponent
                case "boolean": return booleanEditorComponent
                case "string": return stringEditorComponent
                case "options": return optionsEditorComponent
                default: return stringEditorComponent
            }
        }
    }

    // Parameter Editor Components
    Component {
        id: numberEditorComponent

        RowLayout {
            property var editor: parent.parent

            Slider {
                id: slider
                from: editor.parameterMin
                to: editor.parameterMax
                value: editor.parameterValue || 0
                stepSize: editor.parameterStep
                Layout.fillWidth: true

                onMoved: {
                    editor.valueChanged(value)
                }
            }

            TextField {
                text: slider.value.toFixed(2)
                font.family: "Segoe UI"
                font.pixelSize: 11
                Layout.preferredWidth: 60
                validator: DoubleValidator {
                    bottom: slider.from
                    top: slider.to
                }
                background: Rectangle {
                    color: appTheme.backgroundPrimary
                    radius: 3
                    border.color: parent.activeFocus ? appTheme.primary : appTheme.border
                    border.width: 1
                }
                onEditingFinished: {
                    var newValue = Number(text)
                    if (!isNaN(newValue)) {
                        slider.value = newValue
                        editor.valueChanged(newValue)
                    }
                }
            }
        }
    }

    Component {
        id: booleanEditorComponent

        CheckBox {
            property var editor: parent.parent

            checked: editor.parameterValue || false
            font.family: "Segoe UI"
            font.pixelSize: 12
            onCheckedChanged: {
                editor.valueChanged(checked)
            }
        }
    }

    Component {
        id: stringEditorComponent

        TextField {
            property var editor: parent.parent

            text: editor.parameterValue !== undefined ? editor.parameterValue : ""
            font.family: "Segoe UI"
            font.pixelSize: 11
            Layout.fillWidth: true
            background: Rectangle {
                color: appTheme.backgroundPrimary
                radius: 3
                border.color: parent.activeFocus ? appTheme.primary : appTheme.border
                border.width: 1
            }
            onEditingFinished: {
                editor.valueChanged(text)
            }
        }
    }

    Component {
        id: optionsEditorComponent

        ComboBox {
            property var editor: parent.parent

            model: editor.parameterOptions || []
            currentIndex: model.indexOf(editor.parameterValue)
            font.family: "Segoe UI"
            font.pixelSize: 11
            Layout.fillWidth: true
            background: Rectangle {
                color: appTheme.backgroundPrimary
                radius: 3
                border.color: parent.activeFocus ? appTheme.primary : appTheme.border
                border.width: 1
            }
            onActivated: {
                editor.valueChanged(model[currentIndex])
            }
        }
    }

    // Helper functions
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
        return colors[category] || appTheme.primary
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
            case 1: return appTheme.success
            case 2: return appTheme.error
            case 3: return appTheme.warning
            case 4: return appTheme.info
            default: return appTheme.textTertiary
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

    function getPortColor(dataType) {
        var colors = {
            "EEGSignal": "#6C63FF",
            "ECGSignal": "#EF476F",
            "EMGSignal": "#06D6A0",
            "FeatureVector": "#FFD166",
            "ClassificationResult": "#7209B7",
            "ControlSignal": "#F15BB5",
            "SignalData": "#118AB2",
            "MatrixData": "#4ECDC4"
        }
        return colors[dataType] || appTheme.primary
    }

    function getDataTypeAbbreviation(dataType) {
        var abbreviations = {
            "EEGSignal": "EEG",
            "ECGSignal": "ECG",
            "EMGSignal": "EMG",
            "FeatureVector": "FEAT",
            "ClassificationResult": "CLASS",
            "ControlSignal": "CTRL",
            "SignalData": "SIG",
            "MatrixData": "MAT"
        }
        return abbreviations[dataType] || "??"
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
                    description: parameters[key].description
                })
            }
        }
        return editable
    }

    function resetChanges() {
        hasChanges = false
        // Reset parameter values to original
    }

    function applyChanges() {
        hasChanges = false
        // Apply changes to node
    }

    Component.onCompleted: {
        console.log("NodePropertiesPanel initialized with modern design")
    }
}
