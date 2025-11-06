import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
// کامپوننت سطر پارامتر
Rectangle {
    id: parameterRow
    height: 24
    color: "transparent"

    property string parameterName: ""
    property var parameterValue
    property string parameterType: "string"
    property var parameterOptions: null
    signal valueChanged(var newValue)

    RowLayout {
        anchors.fill: parent
        spacing: 6

        Text {
            text: parameterName + ":"
            color: theme.textSecondary
            font.family: "Segoe UI"
            font.pixelSize: 10
            font.bold: true
            Layout.preferredWidth: 70
            elide: Text.ElideRight
        }

        Loader {
            sourceComponent: getParameterEditor()
            Layout.fillWidth: true
            onLoaded: {
                if (item.setValue) {
                    item.setValue(parameterValue)
                }
            }
        }
    }

    function getParameterEditor() {
        switch(parameterType) {
            case "number": return numberEditorComponent
            case "boolean": return booleanEditorComponent
            case "string": return stringEditorComponent
            case "options": return optionsEditorComponent
            default: return stringEditorComponent
        }
    }

    Component {
        id: numberEditorComponent

        TextField {
            placeholderText: "Enter number..."
            font.family: "Segoe UI"
            font.pixelSize: 10
            validator: DoubleValidator { decimals: 6 }

            background: Rectangle {
                color: theme.backgroundPrimary
                radius: 4
                border.color: parent.activeFocus ? theme.primary : theme.border
                border.width: 1
            }

            function setValue(value) {
                text = value !== undefined ? value : ""
            }

            onEditingFinished: {
                if (text !== "") {
                    parameterRow.valueChanged(Number(text))
                }
            }
        }
    }

    Component {
        id: booleanEditorComponent

        CheckBox {
            font.family: "Segoe UI"
            font.pixelSize: 10

            function setValue(value) {
                checked = value || false
            }

            onCheckedChanged: {
                parameterRow.valueChanged(checked)
            }
        }
    }

    Component {
        id: stringEditorComponent

        TextField {
            placeholderText: "Enter value..."
            font.family: "Segoe UI"
            font.pixelSize: 10

            background: Rectangle {
                color: theme.backgroundPrimary
                radius: 4
                border.color: parent.activeFocus ? theme.primary : theme.border
                border.width: 1
            }

            function setValue(value) {
                text = value !== undefined ? value : ""
            }

            onEditingFinished: {
                parameterRow.valueChanged(text)
            }
        }
    }

    Component {
        id: optionsEditorComponent

        ComboBox {
            font.family: "Segoe UI"
            font.pixelSize: 10
            model: parameterOptions || []

            background: Rectangle {
                color: theme.backgroundPrimary
                radius: 4
                border.color: parent.activeFocus ? theme.primary : theme.border
                border.width: 1
            }

            function setValue(value) {
                currentIndex = model.indexOf(value)
            }

            onActivated: {
                parameterRow.valueChanged(model[currentIndex])
            }
        }
    }
}
