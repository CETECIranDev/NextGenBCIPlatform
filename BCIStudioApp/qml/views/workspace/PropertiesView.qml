import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
    background: Rectangle { color: themeManager.surfaceDark }

    // Mock data for a selected node
    property var selectedNode: ({
        "name": "Bandpass Filter",
        "params": [
            { "name": "Lower Cutoff (Hz)", "type": "double", "value": 1.0 },
            { "name": "Higher Cutoff (Hz)", "type": "double", "value": 40.0 },
            { "name": "Filter Order", "type": "int", "value": 4 },
            { "name": "Method", "type": "enum", "value": "Butterworth", "options": ["Butterworth", "Chebyshev", "Bessel"] }
        ]
    })

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8

        Label {
            text: selectedNode ? `Properties: ${selectedNode.name}` : "No node selected"
            font: themeManager.fontLarge
            color: themeManager.primary
            Layout.bottomMargin: 8
        }

        GridLayout {
            visible: selectedNode !== null
            columns: 2
            columnSpacing: 8
            rowSpacing: 8

            Repeater {
                model: selectedNode.params

                Label {
                    text: modelData.name
                    color: themeManager.textSecondary
                    font: themeManager.fontBase
                    Layout.alignment: Qt.AlignVCenter
                }

                // Dynamically create control based on type
                Loader {
                    Layout.fillWidth: true
                    sourceComponent: {
                        if (modelData.type === "enum") {
                            return comboBoxComponent;
                        } else {
                            return spinBoxComponent;
                        }
                    }
                    // Pass data to the loaded component
                    onLoaded: { item.parameterData = modelData; }
                }
            }
        }
    }

    // --- Components for the Loader ---
    Component {
        id: spinBoxComponent
        SpinBox {
            property var parameterData // To receive data from Loader
            from: 0
            to: 1000
            value: parameterData.value
            editable: true
        }
    }

    Component {
        id: comboBoxComponent
        ComboBox {
            property var parameterData
            model: parameterData.options
            currentIndex: model.indexOf(parameterData.value)
        }
    }
}
