import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs

ColumnLayout {
    id: parameterEditor
    spacing: 6

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
    property var theme: ({
        "textPrimary": "#212529",
        "textSecondary": "#6C757D", 
        "textTertiary": "#ADB5BD",
        "backgroundPrimary": "#FFFFFF",
        "backgroundSecondary": "#F8F9FA",
        "border": "#DEE2E6",
        "primary": "#4361EE",
        "secondary": "#3A0CA3",
        "accent": "#7209B7",
        "success": "#4CC9F0", 
        "warning": "#F72585",
        "error": "#EF476F",
        "info": "#4895EF"
    })

    signal valueChanged(var newValue)
    signal valueEditingFinished()
    signal focusChanged(bool focused)

    // هدر پارامتر
    RowLayout {
        Layout.fillWidth: true
        spacing: 8

        // نام پارامتر
        Text {
            text: paramName
            color: theme.textPrimary
            font.family: "Segoe UI"
            font.pixelSize: 12
            font.bold: true
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        // نشانگر پیشرفته
        Rectangle {
            width: 6
            height: 6
            radius: 3
            color: theme.warning
            visible: paramAdvanced
            Layout.alignment: Qt.AlignVCenter
        }

        // نشانگر فقط خواندنی
        Text {
            text: "🔒"
            font.pixelSize: 10
            color: theme.textTertiary
            visible: paramReadOnly
            Layout.alignment: Qt.AlignVCenter
        }
    }

    // ویرایشگر داینامیک بر اساس نوع
    Loader {
        id: editorLoader
        sourceComponent: getEditorComponent()
        Layout.fillWidth: true

        onLoaded: {
            if (item) {
                // مقدار اولیه را تنظیم کن
                if (item.hasOwnProperty("currentValue")) {
                    item.currentValue = paramValue
                } else if (item.hasOwnProperty("value")) {
                    item.value = paramValue
                } else if (item.hasOwnProperty("text")) {
                    item.text = paramValue !== undefined ? String(paramValue) : ""
                }
            }
        }
    }

    // اطلاعات اضافی
    RowLayout {
        Layout.fillWidth: true
        spacing: 8
        visible: paramDescription !== "" || paramUnit !== ""

        Text {
            text: paramDescription
            color: theme.textTertiary
            font.family: "Segoe UI"
            font.pixelSize: 10
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
            visible: paramDescription !== ""
        }

        Text {
            text: paramUnit
            color: theme.info
            font.family: "Segoe UI"
            font.pixelSize: 10
            font.bold: true
            visible: paramUnit !== ""
        }
    }

    // کامپوننت‌های ویرایشگر
    Component {
        id: numberEditorComponent

        ColumnLayout {
            property real currentValue: 0
            spacing: 4

            // اسلایدر برای اعداد
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Slider {
                    id: numberSlider
                    from: paramMin
                    to: paramMax
                    value: currentValue
                    stepSize: paramStep
                    Layout.fillWidth: true
                    enabled: !paramReadOnly

                    background: Rectangle {
                        x: numberSlider.leftPadding
                        y: numberSlider.topPadding + numberSlider.availableHeight / 2 - height / 2
                        implicitWidth: 200
                        implicitHeight: 4
                        width: numberSlider.availableWidth
                        height: implicitHeight
                        radius: 2
                        color: theme.border

                        Rectangle {
                            width: numberSlider.visualPosition * parent.width
                            height: parent.height
                            color: theme.primary
                            radius: 2
                        }
                    }

                    handle: Rectangle {
                        x: numberSlider.leftPadding + numberSlider.visualPosition * (numberSlider.availableWidth - width)
                        y: numberSlider.topPadding + numberSlider.availableHeight / 2 - height / 2
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 8
                        color: numberSlider.pressed ? Qt.darker(theme.primary, 1.2) : theme.primary
                        border.color: theme.backgroundPrimary
                        border.width: 2
                    }

                    onMoved: {
                        currentValue = value
                        parameterEditor.valueChanged(value)
                    }

                    onPressedChanged: {
                        if (!pressed) {
                            parameterEditor.valueEditingFinished()
                        }
                    }
                }

                // فیلد عددی
                TextField {
                    id: numberField
                    text: currentValue.toFixed(getDecimalPlaces())
                    font.family: "Segoe UI"
                    font.pixelSize: 11
                    Layout.preferredWidth: 70
                    validator: DoubleValidator {
                        bottom: paramMin
                        top: paramMax
                    }
                    enabled: !paramReadOnly
                    selectByMouse: true

                    background: Rectangle {
                        color: theme.backgroundPrimary
                        radius: 4
                        border.color: numberField.activeFocus ? theme.primary : theme.border
                        border.width: 1
                    }

                    onEditingFinished: {
                        var newValue = parseFloat(text)
                        if (!isNaN(newValue)) {
                            // محدود کردن مقدار به بازه مجاز
                            newValue = Math.max(paramMin, Math.min(paramMax, newValue))
                            currentValue = newValue
                            numberSlider.value = newValue
                            parameterEditor.valueChanged(newValue)
                            parameterEditor.valueEditingFinished()
                        }
                    }

                    onFocusChanged: {
                        parameterEditor.focusChanged(numberField.activeFocus)
                    }
                }
            }

            // نمایش محدوده
            RowLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: paramMin.toFixed(getDecimalPlaces())
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "Current: " + currentValue.toFixed(getDecimalPlaces())
                    color: theme.textSecondary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    font.bold: true
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: paramMax.toFixed(getDecimalPlaces())
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                }
            }

            function getDecimalPlaces() {
                return paramStep < 1 ? 2 : (paramStep < 10 ? 1 : 0)
            }

            Component.onCompleted: {
                currentValue = paramValue !== undefined ? paramValue : paramMin
            }
        }
    }

    Component {
        id: booleanEditorComponent

        RowLayout {
            property bool currentValue: false
            Layout.fillWidth: true
            spacing: 8

            // سوئیچ بولین
            Switch {
                id: booleanSwitch
                checked: currentValue
                enabled: !paramReadOnly
                Layout.fillWidth: true

                indicator: Rectangle {
                    implicitWidth: 48
                    implicitHeight: 24
                    x: booleanSwitch.leftPadding
                    y: parent.height / 2 - height / 2
                    radius: 12
                    color: booleanSwitch.checked ? theme.primary : theme.backgroundSecondary
                    border.color: booleanSwitch.checked ? theme.primary : theme.border

                    Rectangle {
                        x: booleanSwitch.checked ? parent.width - width - 4 : 4
                        y: (parent.height - height) / 2
                        width: 16
                        height: 16
                        radius: 8
                        color: booleanSwitch.down ? Qt.darker(theme.backgroundPrimary, 1.1) : theme.backgroundPrimary
                        border.color: booleanSwitch.checked ? theme.primary : theme.border

                        Behavior on x {
                            NumberAnimation { duration: 200 }
                        }
                    }
                }

                contentItem: Text {
                    text: booleanSwitch.checked ? "Enabled" : "Disabled"
                    color: theme.textPrimary
                    font.family: "Segoe UI"
                    font.pixelSize: 11
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: booleanSwitch.indicator.width + booleanSwitch.spacing
                }

                onCheckedChanged: {
                    currentValue = checked
                    parameterEditor.valueChanged(checked)
                    parameterEditor.valueEditingFinished()
                }

                onFocusChanged: {
                    parameterEditor.focusChanged(booleanSwitch.activeFocus)
                }
            }

            // نمایش مقدار فعلی
            Text {
                text: currentValue ? "✓" : "✗"
                color: currentValue ? theme.success : theme.error
                font.family: "Segoe UI"
                font.pixelSize: 12
                font.bold: true
                Layout.alignment: Qt.AlignVCenter
            }

            Component.onCompleted: {
                currentValue = paramValue !== undefined ? paramValue : false
            }
        }
    }

    Component {
        id: stringEditorComponent

        ColumnLayout {
            property string currentValue: ""
            spacing: 4

            TextField {
                id: stringField
                text: currentValue
                font.family: "Segoe UI"
                font.pixelSize: 11
                Layout.fillWidth: true
                enabled: !paramReadOnly
                selectByMouse: true
                placeholderText: "Enter " + paramName.toLowerCase()

                background: Rectangle {
                    color: theme.backgroundPrimary
                    radius: 4
                    border.color: stringField.activeFocus ? theme.primary : theme.border
                    border.width: 1
                }

                onTextChanged: {
                    if (stringField.activeFocus) {
                        currentValue = text
                        parameterEditor.valueChanged(text)
                    }
                }

                onEditingFinished: {
                    parameterEditor.valueEditingFinished()
                }

                onFocusChanged: {
                    parameterEditor.focusChanged(stringField.activeFocus)
                }
            }

            // نمایش طول متن
            Text {
                text: "Length: " + currentValue.length
                color: theme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 9
                visible: currentValue.length > 0
                Layout.alignment: Qt.AlignRight
            }

            Component.onCompleted: {
                currentValue = paramValue !== undefined ? String(paramValue) : ""
            }
        }
    }

    Component {
        id: optionsEditorComponent

        ColumnLayout {
            property var currentValue: ""
            spacing: 4

            ComboBox {
                id: optionsCombo
                model: paramOptions || []
                currentIndex: model.indexOf(currentValue)
                font.family: "Segoe UI"
                font.pixelSize: 11
                Layout.fillWidth: true
                enabled: !paramReadOnly && model.length > 0

                background: Rectangle {
                    color: theme.backgroundPrimary
                    radius: 4
                    border.color: optionsCombo.activeFocus ? theme.primary : theme.border
                    border.width: 1
                }

                contentItem: Text {
                    text: optionsCombo.displayText
                    font: optionsCombo.font
                    color: theme.textPrimary
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                    leftPadding: 8
                    rightPadding: optionsCombo.indicator.width + optionsCombo.spacing
                }

                indicator: Canvas {
                    id: optionsIndicator
                    x: optionsCombo.width - width - optionsCombo.rightPadding
                    y: optionsCombo.topPadding + (optionsCombo.availableHeight - height) / 2
                    width: 12
                    height: 8
                    contextType: "2d"

                    Connections {
                        target: optionsCombo
                        function onPressedChanged() { optionsIndicator.requestPaint() }
                    }

                    onPaint: {
                        context.reset();
                        context.moveTo(0, 0);
                        context.lineTo(width, 0);
                        context.lineTo(width / 2, height);
                        context.closePath();
                        context.fillStyle = theme.textSecondary;
                        context.fill();
                    }
                }

                popup: Popup {
                    y: optionsCombo.height - 1
                    width: optionsCombo.width
                    implicitHeight: contentItem.implicitHeight
                    padding: 1

                    contentItem: ListView {
                        clip: true
                        implicitHeight: contentHeight
                        model: optionsCombo.popup.visible ? optionsCombo.delegateModel : null
                        currentIndex: optionsCombo.highlightedIndex

                        ScrollIndicator.vertical: ScrollIndicator { }
                    }

                    background: Rectangle {
                        color: theme.backgroundPrimary
                        border.color: theme.border
                        radius: 4
                    }
                }

                onActivated: {
                    currentValue = model[index]
                    parameterEditor.valueChanged(currentValue)
                    parameterEditor.valueEditingFinished()
                }

                onFocusChanged: {
                    parameterEditor.focusChanged(optionsCombo.activeFocus)
                }
            }

            // نمایش مقدار انتخاب شده
            Text {
                text: "Selected: " + (currentValue || "None")
                color: theme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 9
                Layout.alignment: Qt.AlignRight
            }

            Component.onCompleted: {
                currentValue = paramValue !== undefined ? paramValue : (paramOptions && paramOptions.length > 0 ? paramOptions[0] : "")
            }
        }
    }

    Component {
        id: colorEditorComponent

        ColumnLayout {
            property color currentValue: "black"
            spacing: 4

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                // پیش‌نمایش رنگ
                Rectangle {
                    width: 40
                    height: 24
                    radius: 4
                    color: currentValue
                    border.color: theme.border
                    border.width: 1

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        enabled: !paramReadOnly
                        onClicked: {
                            colorDialog.open()
                        }
                    }
                }

                // کد رنگ
                TextField {
                    id: colorField
                    text: currentValue.toString()
                    font.family: "Segoe UI"
                    font.pixelSize: 11
                    Layout.fillWidth: true
                    enabled: !paramReadOnly
                    selectByMouse: true

                    background: Rectangle {
                        color: theme.backgroundPrimary
                        radius: 4
                        border.color: colorField.activeFocus ? theme.primary : theme.border
                        border.width: 1
                    }

                    onEditingFinished: {
                        var newColor = text
                        if (Qt.colorEqual(Qt.color(newColor), currentValue)) return
                        
                        currentValue = newColor
                        parameterEditor.valueChanged(newColor)
                        parameterEditor.valueEditingFinished()
                    }

                    onFocusChanged: {
                        parameterEditor.focusChanged(colorField.activeFocus)
                    }
                }
            }

            // دایالوگ انتخاب رنگ
            ColorDialog {
                id: colorDialog
                title: "Choose color for " + paramName
                selectedColor: currentValue
                
                onAccepted: {
                    currentValue = selectedColor
                    colorField.text = selectedColor.toString()
                    parameterEditor.valueChanged(selectedColor)
                    parameterEditor.valueEditingFinished()
                }
            }

            Component.onCompleted: {
                currentValue = paramValue !== undefined ? paramValue : "#000000"
            }
        }
    }

    // تابع برای انتخاب کامپوننت ویرایشگر مناسب
    function getEditorComponent() {
        switch(paramType.toLowerCase()) {
            case "number":
            case "int":
            case "float":
            case "double":
                return numberEditorComponent
            
            case "boolean":
            case "bool":
                return booleanEditorComponent
            
            case "options":
            case "choice":
            case "select":
                return optionsEditorComponent
            
            case "color":
            case "colour":
                return colorEditorComponent
            
            case "string":
            case "text":
            default:
                return stringEditorComponent
        }
    }

    // تابع برای به‌روزرسانی مقدار
    function updateValue(newValue) {
        paramValue = newValue
        if (editorLoader.item && editorLoader.item.hasOwnProperty("currentValue")) {
            editorLoader.item.currentValue = newValue
        }
    }

    // تابع برای دریافت مقدار فعلی
    function getCurrentValue() {
        if (editorLoader.item && editorLoader.item.hasOwnProperty("currentValue")) {
            return editorLoader.item.currentValue
        }
        return paramValue
    }

    // تابع برای ریست کردن به مقدار پیش‌فرض
    function resetToDefault() {
        var defaultValue = getDefaultValue()
        updateValue(defaultValue)
        parameterEditor.valueChanged(defaultValue)
    }

    // تابع برای دریافت مقدار پیش‌فرض
    function getDefaultValue() {
        switch(paramType.toLowerCase()) {
            case "number":
            case "int":
            case "float":
            case "double":
                return paramMin
            
            case "boolean":
            case "bool":
                return false
            
            case "options":
            case "choice":
            case "select":
                return paramOptions && paramOptions.length > 0 ? paramOptions[0] : ""
            
            case "color":
            case "colour":
                return "#000000"
            
            case "string":
            case "text":
            default:
                return ""
        }
    }

    Component.onCompleted: {
        console.log("ParameterEditor created:", paramName, "Type:", paramType, "Value:", paramValue)
    }
}
