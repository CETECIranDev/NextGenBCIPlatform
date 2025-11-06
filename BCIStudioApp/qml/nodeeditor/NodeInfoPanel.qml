import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: infoPanel
    height: 140
    color: appTheme.backgroundSecondary
    radius: 12

    property string currentNodeType: ""
    property var nodeRegistry: null
    property real executionProgress: 0.0
    property bool isExecuting: false

    // سیگنال‌ها - فقط سیگنال‌های custom تعریف کنید
    signal nodeInfoRequested(string nodeType)
    signal parametersChanged(string nodeType, var parameters)
    signal executionStateChanged(bool executing)

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
        anchors.margins: 16
        spacing: 12

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Rectangle {
                width: 32
                height: 32
                radius: 8
                color: isExecuting ? appTheme.success : appTheme.primary
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: isExecuting ? "⚡" : "💡"
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                // Animation for execution state
                Behavior on color {
                    ColorAnimation { duration: 300 }
                }
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                Text {
                    text: "Node Information"
                    color: appTheme.textPrimary
                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }

                Text {
                    text: isExecuting ?
                          "Executing pipeline..." :
                          "Details about selected node"
                    color: appTheme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                }
            }

            // Progress indicator when executing
            ProgressBar {
                value: executionProgress
                visible: isExecuting
                Layout.preferredWidth: 80
                Layout.alignment: Qt.AlignVCenter

                background: Rectangle {
                    implicitWidth: 80
                    implicitHeight: 6
                    color: appTheme.backgroundTertiary
                    radius: 3
                }

                contentItem: Item {
                    implicitWidth: 80
                    implicitHeight: 6

                    Rectangle {
                        width: parent.width * parent.parent.visualPosition
                        height: parent.height
                        radius: 3
                        color: appTheme.success
                    }
                }
            }
        }

        // Content
        Loader {
            sourceComponent: {
                if (isExecuting) return executionContent
                else if (infoPanel.currentNodeType) return nodeInfoContent
                else return placeholderContent
            }
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Component {
        id: placeholderContent

        ColumnLayout {
            spacing: 16

            Rectangle {
                width: 64
                height: 64
                radius: 32
                color: appTheme.backgroundTertiary
                Layout.alignment: Qt.AlignCenter

                Text {
                    text: "⚡"
                    font.pixelSize: 24
                    anchors.centerIn: parent
                }
            }

            ColumnLayout {
                spacing: 4
                Layout.alignment: Qt.AlignCenter

                Text {
                    text: "Select a Node"
                    color: appTheme.textSecondary
                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 14
                    font.weight: Font.Medium
                    Layout.alignment: Qt.AlignCenter
                }

                Text {
                    text: "Click on any node to view its details and parameters"
                    color: appTheme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 11
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }
            }
        }
    }

    Component {
        id: executionContent

        ColumnLayout {
            spacing: 16
            Layout.alignment: Qt.AlignCenter

            Text {
                text: "Pipeline Execution"
                color: appTheme.textPrimary
                font.family: "Segoe UI Semibold"
                font.pixelSize: 16
                font.weight: Font.DemiBold
                Layout.alignment: Qt.AlignCenter
            }

            Text {
                text: Math.round(executionProgress * 100) + "% Complete"
                color: appTheme.success
                font.family: "Segoe UI"
                font.pixelSize: 14
                font.weight: Font.Medium
                Layout.alignment: Qt.AlignCenter
            }

            Button {
                text: "Stop Execution"
                Layout.alignment: Qt.AlignCenter
                onClicked: infoPanel.executionStateChanged(false)

                background: Rectangle {
                    color: appTheme.error
                    radius: 6
                }

                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    Component {
        id: nodeInfoContent

        ColumnLayout {
            spacing: 16

            property var nodeInfo: nodeRegistry ? nodeRegistry.getNodeInfo(currentNodeType) : null

            // Node Title and Description
            ColumnLayout {
                spacing: 8
                Layout.fillWidth: true

                RowLayout {
                    spacing: 8
                    Layout.fillWidth: true

                    Rectangle {
                        width: 24
                        height: 24
                        radius: 6
                        color: getCategoryColor(nodeInfo ? nodeInfo.category : "General")
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            text: nodeInfo ? nodeInfo.icon : "⚙️"
                            font.pixelSize: 12
                            color: "white"
                            anchors.centerIn: parent
                        }
                    }

                    ColumnLayout {
                        spacing: 2
                        Layout.fillWidth: true

                        Text {
                            text: nodeInfo ? nodeInfo.name : "Unknown Node"
                            color: appTheme.textPrimary
                            font.family: "Segoe UI Semibold"
                            font.pixelSize: 14
                            font.weight: Font.DemiBold
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        Text {
                            text: nodeInfo ? nodeInfo.category : "General"
                            color: appTheme.primary
                            font.family: "Segoe UI"
                            font.pixelSize: 10
                            font.weight: Font.Medium
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                    }
                }

                Text {
                    text: nodeInfo ? nodeInfo.description : "No description available."
                    color: appTheme.textSecondary
                    font.family: "Segoe UI"
                    font.pixelSize: 11
                    wrapMode: Text.WordWrap
                    lineHeight: 1.4
                    Layout.fillWidth: true
                }
            }

            // Ports and Parameters Grid
            GridLayout {
                columns: 2
                columnSpacing: 16
                rowSpacing: 12
                Layout.fillWidth: true

                // Input Ports
                InfoCard {
                    title: "INPUT PORTS"
                    icon: "⬅️"
                    value: nodeInfo ? getPortsCount(nodeInfo.ports, 0) : "0"
                    description: getPortsText(nodeInfo ? nodeInfo.ports : null, 0)
                    cardColor: appTheme.success
                    Layout.fillWidth: true
                }

                // Output Ports
                InfoCard {
                    title: "OUTPUT PORTS"
                    icon: "➡️"
                    value: nodeInfo ? getPortsCount(nodeInfo.ports, 1) : "0"
                    description: getPortsText(nodeInfo ? nodeInfo.ports : null, 1)
                    cardColor: appTheme.warning
                    Layout.fillWidth: true
                }

                // Parameters
                InfoCard {
                    title: "PARAMETERS"
                    icon: "⚙️"
                    value: nodeInfo ? getParametersCount(nodeInfo.parameters) : "0"
                    description: getParametersPreview(nodeInfo ? nodeInfo.parameters : null)
                    cardColor: appTheme.info
                    Layout.columnSpan: 2
                    Layout.fillWidth: true
                }
            }
        }
    }

    // Helper functions
    function getPortsCount(ports, direction) {
        if (!ports) return "0"
        var filteredPorts = ports.filter(port => port.direction === direction)
        return filteredPorts.length.toString()
    }

    function getPortsText(ports, direction) {
        if (!ports) return "No ports"

        var filteredPorts = ports.filter(port => port.direction === direction)
        if (filteredPorts.length === 0) return "No ports"

        var portTexts = []
        for (var i = 0; i < filteredPorts.length; i++) {
            var port = filteredPorts[i]
            portTexts.push(port.name + " (" + getDataTypeAbbreviation(port.dataType) + ")")
        }
        return portTexts.join(", ")
    }

    function getParametersCount(parameters) {
        if (!parameters) return "0"
        var visibleParams = 0
        for (var key in parameters) {
            if (parameters[key].visible !== false) visibleParams++
        }
        return visibleParams.toString()
    }

    function getParametersPreview(parameters) {
        if (!parameters) return "No parameters"

        var paramList = []
        for (var key in parameters) {
            if (parameters[key].visible !== false) {
                paramList.push(key)
            }
        }
        return paramList.length > 0 ? paramList.join(", ") : "No parameters"
    }

    function getDataTypeAbbreviation(dataType) {
        var abbreviations = {
            "EEGSignal": "EEG",
            "ECGSignal": "ECG",
            "EMGSignal": "EMG",
            "FeatureVector": "FT",
            "ClassificationResult": "CLS",
            "ControlSignal": "CTL",
            "SignalData": "SIG",
            "MatrixData": "MAT",
            "Number": "NUM",
            "Boolean": "BOOL",
            "String": "STR"
        }
        return abbreviations[dataType] || dataType || "??"
    }

    function getCategoryColor(category) {
        var colors = {
            "Data Acquisition": appTheme.primary,
            "Preprocessing": appTheme.secondary,
            "Feature Extraction": appTheme.success,
            "Classification": appTheme.warning,
            "BCI Paradigms": appTheme.info,
            "Visualization": "#FF6B35",
            "Control": "#9C27B0",
            "Utilities": "#00BCD4"
        }
        return colors[category] || appTheme.primary
    }

    // Animations
    Behavior on executionProgress {
        NumberAnimation { duration: 200 }
    }

    Behavior on isExecuting {
        PropertyAnimation { duration: 300 }
    }

    Behavior on currentNodeType {
        SequentialAnimation {
            PropertyAnimation { duration: 150 }
        }
    }
}

