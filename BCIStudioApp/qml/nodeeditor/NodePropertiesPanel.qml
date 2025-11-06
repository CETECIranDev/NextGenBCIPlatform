import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects


Rectangle {
    id: propertiesPanel
    color: theme.backgroundSecondary
    border.color: theme.border
    border.width: 1

    property var selectedNode: null
    property var nodeGraph: null
    property var theme: ({})
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
            color: theme.backgroundTertiary
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
                        color: theme.primary
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
                            color: theme.textPrimary
                            font.family: "Segoe UI Semibold"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: selectedNode ? selectedNode.name : "No node selected"
                            color: theme.textSecondary
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            elide: Text.ElideRight
                        }
                    }

                    // Action Buttons
                    RowLayout {
                        spacing: 6
                        Layout.alignment: Qt.AlignVCenter

                        CustomActionButton {
                            buttonIcon: "📋"
                            tooltipText: "Duplicate Node"
                            enabled: selectedNode !== null
                            onClicked: propertiesPanel.nodeDuplicated(selectedNode.nodeId)
                        }

                        CustomActionButton {
                            buttonIcon: selectedNode && selectedNode.enabled === false ? "✅" : "⏸️"
                            tooltipText: selectedNode && selectedNode.enabled === false ? "Enable Node" : "Disable Node"
                            enabled: selectedNode !== null
                            isAccent: selectedNode && selectedNode.enabled === false
                            onClicked: {
                                if (selectedNode.enabled === false) {
                                    propertiesPanel.nodeEnabled(selectedNode.nodeId)
                                } else {
                                    propertiesPanel.nodeDisabled(selectedNode.nodeId)
                                }
                            }
                        }

                        CustomActionButton {
                            buttonIcon: "🗑️"
                            tooltipText: "Delete Node"
                            enabled: selectedNode !== null
                            isAccent: true
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
                    color: hasChanges ? theme.warning : "transparent"
                    visible: hasChanges

                    Text {
                        text: "● Unsaved Changes"
                        color: theme.warning
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
                anchors.margins: 16

                // Empty State
                EmptyStatePanel {
                    visible: !selectedNode
                    emptyTitle: "Select a Node"
                    emptyDescription: "Click on any node in the canvas to view and edit its properties"
                    emptyIcon: "🎯"
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
                        title: "NODE INFO"
                        icon: "📄"
                        cardColor: theme.info
                        Layout.fillWidth: true

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
                                        text: selectedNode ? selectedNode.description : "No description"
                                        color: theme.textSecondary
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
                                    badgeLabel: "Status"
                                    badgeValue: getStatusText(selectedNode ? selectedNode.status : 0)
                                    badgeColor: getStatusColor(selectedNode ? selectedNode.status : 0)
                                    badgeIcon: getStatusIcon(selectedNode ? selectedNode.status : 0)
                                }

                                StatusBadge {
                                    badgeLabel: "Enabled"
                                    badgeValue: selectedNode && selectedNode.enabled === false ? "Disabled" : "Enabled"
                                    badgeColor: selectedNode && selectedNode.enabled === false ? theme.error : theme.success
                                    badgeIcon: selectedNode && selectedNode.enabled === false ? "❌" : "✅"
                                }

                                StatusBadge {
                                    badgeLabel: "Node ID"
                                    badgeValue: selectedNode ? selectedNode.nodeId.substring(0, 8) + "..." : "N/A"
                                    badgeColor: theme.textTertiary
                                    badgeIcon: "🆔"
                                    Layout.columnSpan: 2
                                }
                            }
                        }
                    }

                    // Ports Card
                    InfoCard {
                        title: "PORTS"
                        icon: "🔌"
                        cardColor: theme.secondary
                        visible: portsRepeater.count > 0
                        Layout.fillWidth: true

                        ColumnLayout {
                            width: parent.width
                            spacing: 8

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

                    // Parameters Card
                    InfoCard {
                        title: "PARAMETERS"
                        icon: "🎛️"
                        cardColor: theme.primary
                        visible: parametersRepeater.count > 0
                        Layout.fillWidth: true

                        ColumnLayout {
                            width: parent.width
                            spacing: 12

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

                    // Documentation Card
                    InfoCard {
                        title: "DOCUMENTATION"
                        icon: "📖"
                        cardColor: theme.warning
                        visible: selectedNode && selectedNode.documentation
                        Layout.fillWidth: true

                        Text {
                            text: selectedNode ? selectedNode.documentation : ""
                            color: theme.textSecondary
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
                                propertiesPanel.resetChanges()
                            }

                            background: Rectangle {
                                color: "transparent"
                                border.color: theme.border
                                border.width: 1
                                radius: 6
                            }

                            contentItem: Text {
                                text: parent.text
                                color: theme.textPrimary
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
                                propertiesPanel.applyChanges()
                            }

                            background: Rectangle {
                                color: theme.success
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
        anchors.centerIn: Overlay.overlay

        background: Rectangle {
            color: theme.backgroundCard
            radius: 12
            border.color: theme.border
        }

        ColumnLayout {
            spacing: 16

            Text {
                text: "Are you sure you want to delete this node?"
                color: theme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 14
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Text {
                text: "This action cannot be undone."
                color: theme.error
                font.family: "Segoe UI"
                font.pixelSize: 12
                font.weight: Font.Medium
                Layout.fillWidth: true
            }
        }

        onAccepted: {
            propertiesPanel.nodeDeleted(selectedNode.nodeId)
        }
    }

    // کامپوننت‌های سفارشی
    // کامپوننت کارت اطلاعات
    Rectangle {
        id: infoCardComponent
        visible: false
    }

    // کامپوننت دکمه اقدام
    Rectangle {
        id: customActionButtonComponent
        visible: false
    }

    // کامپوننت وضعیت خالی
    Rectangle {
        id: emptyStateComponent
        visible: false
    }

    // کامپوننت نشان وضعیت
    Rectangle {
        id: statusBadgeComponent
        visible: false
    }

    // کامپوننت آیتم پورت
    Rectangle {
        id: portItemComponent
        visible: false
    }

    // کامپوننت ویرایشگر پارامتر
    Rectangle {
        id: parameterEditorComponent
        visible: false
    }

    // تعاریف کامپوننت‌ها
    Component {
        id: infoCardComp

        Rectangle {
            property string cardTitle: ""
            property string cardIcon: ""
            property color cardColor: theme.primary

            Layout.fillWidth: true
            implicitHeight: content.height + 24
            radius: 8
            color: theme.backgroundCard
            border.color: theme.border
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
                        color: cardColor

                        Text {
                            text: cardIcon
                            font.pixelSize: 12
                            color: "white"
                            anchors.centerIn: parent
                        }
                    }

                    Text {
                        text: cardTitle
                        color: theme.textPrimary
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
    }

    Component {
        id: customActionButtonComp

        Rectangle {
            property string buttonIcon: ""
            property string tooltipText: ""
            property bool enabled: true
            property bool isAccent: false

            width: 32
            height: 32
            radius: 6
            color: mouseArea.containsPress ?
                   (isAccent ? Qt.darker(theme.error, 1.2) : Qt.darker(theme.primary, 1.2)) :
                   (mouseArea.containsMouse ?
                    (isAccent ? Qt.lighter(theme.error, 1.1) : Qt.lighter(theme.primary, 1.1)) :
                    (isAccent ? theme.error : theme.backgroundTertiary))
            opacity: enabled ? 1.0 : 0.3

            Text {
                text: buttonIcon
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
                text: tooltipText
                visible: mouseArea.containsMouse && parent.enabled
            }

            signal clicked()

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }

    Component {
        id: emptyStatePanelComp

        ColumnLayout {
            property string emptyTitle: ""
            property string emptyDescription: ""
            property string emptyIcon: ""

            spacing: 16

            Rectangle {
                width: 80
                height: 80
                radius: 40
                color: theme.backgroundTertiary
                Layout.alignment: Qt.AlignCenter

                Text {
                    text: emptyIcon
                    font.pixelSize: 32
                    color: theme.textTertiary
                    anchors.centerIn: parent
                }
            }

            ColumnLayout {
                spacing: 4
                Layout.alignment: Qt.AlignCenter

                Text {
                    text: emptyTitle
                    color: theme.textPrimary
                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                    Layout.alignment: Qt.AlignCenter
                }

                Text {
                    text: emptyDescription
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.preferredWidth: 200
                }
            }
        }
    }

    Component {
        id: statusBadgeComp

        RowLayout {
            property string badgeLabel: ""
            property string badgeValue: ""
            property color badgeColor: theme.primary
            property string badgeIcon: ""

            spacing: 6

            Text {
                text: badgeIcon
                font.pixelSize: 12
                color: badgeColor
            }

            Text {
                text: badgeLabel + ":"
                color: theme.textSecondary
                font.family: "Segoe UI"
                font.pixelSize: 11
            }

            Text {
                text: badgeValue
                color: badgeColor
                font.family: "Segoe UI"
                font.pixelSize: 11
                font.weight: Font.Medium
                Layout.fillWidth: true
            }
        }
    }

    Component {
        id: portItemComp

        RowLayout {
            property string portName: ""
            property string portType: ""
            property string portDirection: "input" // "input" or "output"
            property bool isConnected: false

            spacing: 8

            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: getPortColor(portType)
                border.color: theme.border
                border.width: 1
                Layout.alignment: Qt.AlignVCenter
            }

            ColumnLayout {
                spacing: 1
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
                    color: isConnected ? theme.success : theme.textDisabled
                }

                Text {
                    text: portDirection === "input" ? "IN" : "OUT"
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    font.weight: Font.Medium
                }
            }
        }
    }

    Component {
        id: parameterEditorComp

        ColumnLayout {
            property string paramName: ""
            property var paramValue
            property string paramType: "string"
            property var paramOptions: []
            property real paramMin: 0
            property real paramMax: 100
            property real paramStep: 1
            property string paramDescription: ""

            signal valueChanged(var newValue)

            spacing: 6

            Text {
                text: paramName
                color: theme.textSecondary
                font.family: "Segoe UI"
                font.pixelSize: 12
                Layout.fillWidth: true
            }

            Loader {
                sourceComponent: getEditorComponent()
                Layout.fillWidth: true
            }

            Text {
                text: paramDescription
                color: theme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 10
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
    }

    // کامپوننت‌های ادیتور پارامتر
    Component {
        id: numberEditorComponent

        RowLayout {
            Slider {
                id: slider
                from: parent.parent.paramMin
                to: parent.parent.paramMax
                value: parent.parent.paramValue || 0
                stepSize: parent.parent.paramStep
                Layout.fillWidth: true

                onMoved: {
                    parent.parent.valueChanged(value)
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
                    color: theme.backgroundPrimary
                    radius: 3
                    border.color: parent.activeFocus ? theme.primary : theme.border
                    border.width: 1
                }
                onEditingFinished: {
                    var newValue = Number(text)
                    if (!isNaN(newValue)) {
                        slider.value = newValue
                        parent.parent.valueChanged(newValue)
                    }
                }
            }
        }
    }

    Component {
        id: booleanEditorComponent

        CheckBox {
            checked: parent.parent.paramValue || false
            font.family: "Segoe UI"
            font.pixelSize: 12
            onCheckedChanged: {
                parent.parent.valueChanged(checked)
            }
        }
    }

    Component {
        id: stringEditorComponent

        TextField {
            text: parent.parent.paramValue !== undefined ? parent.parent.paramValue : ""
            font.family: "Segoe UI"
            font.pixelSize: 11
            Layout.fillWidth: true
            background: Rectangle {
                color: theme.backgroundPrimary
                radius: 3
                border.color: parent.activeFocus ? theme.primary : theme.border
                border.width: 1
            }
            onEditingFinished: {
                parent.parent.valueChanged(text)
            }
        }
    }

    Component {
        id: optionsEditorComponent

        ComboBox {
            model: parent.parent.paramOptions || []
            currentIndex: model.indexOf(parent.parent.paramValue)
            font.family: "Segoe UI"
            font.pixelSize: 11
            Layout.fillWidth: true
            background: Rectangle {
                color: theme.backgroundPrimary
                radius: 3
                border.color: parent.activeFocus ? theme.primary : theme.border
                border.width: 1
            }
            onActivated: {
                parent.parent.valueChanged(model[currentIndex])
            }
        }
    }

    // Loaderها برای کامپوننت‌های داینامیک
    Loader {
        id: infoCardLoader
        sourceComponent: infoCardComp
    }

    Loader {
        id: customActionButtonLoader
        sourceComponent: customActionButtonComp
    }

    Loader {
        id: emptyStatePanelLoader
        sourceComponent: emptyStatePanelComp
    }

    Loader {
        id: statusBadgeLoader
        sourceComponent: statusBadgeComp
    }

    Loader {
        id: portItemLoader
        sourceComponent: portItemComp
    }

    Loader {
        id: parameterEditorLoader
        sourceComponent: parameterEditorComp
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
        return colors[dataType] || theme.primary
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
