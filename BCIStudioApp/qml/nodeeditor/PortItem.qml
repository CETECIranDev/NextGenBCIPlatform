import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: portItem
    height: 28
    color: "transparent"

    property var portModel
    property bool isInput: true
    property bool isConnected: portModel ? portModel.isConnected : false
    property bool isHovered: false
    property bool canConnect: portModel ? portModel.canConnect : true
    property bool isOptional: portModel ? portModel.optional : false

    signal connectionStarted(var port, var mouse)
    signal connectionFinished(var port)
    signal portClicked(var port)
    signal portRightClicked(var port)
    signal portHovered(var port, bool hovered)

    // انیمیشن‌ها
    Behavior on scale {
        NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
    }

    Behavior on opacity {
        NumberAnimation { duration: 200 }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 8
        layoutDirection: isInput ? Qt.LeftToRight : Qt.RightToLeft

        // دایره پورت - بخش اصلی
        Rectangle {
            id: portCircle
            width: 18
            height: 18
            radius: 9
            color: getPortColor()
            border.color: getBorderColor()
            border.width: isConnected ? 3 : 2
            
            // سایه برای پورت‌های متصل
            layer.enabled: isConnected
            layer.effect: DropShadow {
                transparentBorder: true
                radius: 8
                samples: 16
                color: getPortColor()
                spread: 0.3
            }

            // پالس انیمیشن برای پورت‌های متصل
            SequentialAnimation on scale {
                running: isConnected && portMouseArea.containsMouse
                loops: Animation.Infinite
                NumberAnimation { to: 1.3; duration: 800; easing.type: Easing.InOutQuad }
                NumberAnimation { to: 1.0; duration: 800; easing.type: Easing.InOutQuad }
            }

            // آیکون نوع داده
            Text {
                text: getDataTypeIcon()
                font.pixelSize: 8
                color: "white"
                anchors.centerIn: parent
                visible: !portMouseArea.containsMouse
            }

            // آیکون hover
            Text {
                text: "🔗"
                font.pixelSize: 8
                color: "white"
                anchors.centerIn: parent
                visible: portMouseArea.containsMouse && canConnect
                scale: portMouseArea.containsPress ? 0.8 : 1.0
            }

            // آیکون غیرفعال
            Text {
                text: "⛔"
                font.pixelSize: 8
                color: "white"
                anchors.centerIn: parent
                visible: !canConnect
            }

            // نشانگر پورت اختیاری
            Rectangle {
                width: 6
                height: 6
                radius: 3
                color: theme.warning
                border.color: "white"
                border.width: 1
                visible: isOptional
                anchors {
                    top: parent.top
                    right: parent.right
                    margins: -2
                }
            }
        }

        // اطلاعات پورت
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            Layout.alignment: Qt.AlignVCenter

            // نام پورت
            RowLayout {
                Layout.fillWidth: true
                spacing: 4

                Text {
                    text: portModel ? portModel.name : "Unknown Port"
                    color: theme.textPrimary
                    font.family: "Segoe UI"
                    font.pixelSize: 11
                    font.bold: true
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    horizontalAlignment: isInput ? Text.AlignLeft : Text.AlignRight
                }

                // نشانگر اتصال
                Text {
                    text: isConnected ? "●" : "○"
                    color: isConnected ? theme.success : theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 8
                    font.bold: true
                    visible: portModel && portModel.showConnectionStatus !== false
                }
            }

            // نوع داده و اطلاعات
            RowLayout {
                Layout.fillWidth: true
                spacing: 6
                layoutDirection: isInput ? Qt.LeftToRight : Qt.RightToLeft

                Text {
                    text: portModel ? getDataTypeDescription(portModel.dataType) : "Unknown"
                    color: theme.textSecondary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    horizontalAlignment: isInput ? Text.AlignLeft : Text.AlignRight
                }

                // نشانگر چندتایی
                Text {
                    text: portModel && portModel.multiple ? "[]" : ""
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 8
                    font.bold: true
                    visible: portModel && portModel.multiple
                }
            }

            // توضیحات پورت
            Text {
                text: portModel && portModel.description ? portModel.description : ""
                color: theme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 8
                wrapMode: Text.Wrap
                maximumLineCount: 2
                elide: Text.ElideRight
                Layout.fillWidth: true
                horizontalAlignment: isInput ? Text.AlignLeft : Text.AlignRight
                visible: text !== ""
            }
        }
    }

    // ناحیه قابل کلیک
    MouseArea {
        id: portMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: getCursorShape()
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        propagateComposedEvents: true

        onEntered: {
            isHovered = true
            portItem.scale = 1.05
            portItem.z = 10
            portHovered(portModel, true)
        }

        onExited: {
            isHovered = false
            portItem.scale = 1.0
            portItem.z = 0
            portHovered(portModel, false)
        }

        onPressed: (mouse) => {
            if (mouse.button === Qt.LeftButton && canConnect) {
                portItem.connectionStarted(portModel, mouse)
                mouse.accepted = true
            } else if (mouse.button === Qt.RightButton) {
                portItem.portRightClicked(portModel)
                mouse.accepted = true
            }
        }

        onReleased: (mouse) => {
            if (mouse.button === Qt.LeftButton && canConnect) {
                portItem.connectionFinished(portModel)
            }
        }

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                portItem.portClicked(portModel)
            }
        }

        onDoubleClicked: {
            if (canConnect) {
                // ایجاد اتصال سریع با دابل کلیک
                portItem.connectionStarted(portModel, {x: portCircle.width/2, y: portCircle.height/2})
                // اینجا می‌توانید منطق اتصال سریع را پیاده‌سازی کنید
            }
        }

        function getCursorShape() {
            if (!canConnect) return Qt.ForbiddenCursor
            if (isConnected) return Qt.PointingHandCursor
            return Qt.CrossCursor
        }
    }

    // Tooltip برای اطلاعات بیشتر
    ToolTip {
        id: portTooltip
        delay: 500
        timeout: 4000
        
        contentItem: ColumnLayout {
            spacing: 6
            width: 240

            // هدر Tooltip
            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    width: 16
                    height: 16
                    radius: 8
                    color: getPortColor()
                    border.color: getBorderColor()
                    border.width: 2

                    Text {
                        text: getDataTypeIcon()
                        font.pixelSize: 7
                        color: "white"
                        anchors.centerIn: parent
                    }
                }

                Text {
                    text: portModel ? portModel.name : "Unknown Port"
                    color: theme.textPrimary
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    font.bold: true
                    Layout.fillWidth: true
                }
            }

            // اطلاعات اصلی
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: getDataTypeDescription(portModel ? portModel.dataType : "")
                    color: theme.textSecondary
                    font.family: "Segoe UI"
                    font.pixelSize: 10
                    Layout.fillWidth: true
                }

                Text {
                    text: portModel && portModel.description ? portModel.description : "No description available"
                    color: theme.textSecondary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }
            }

            // اطلاعات فنی
            GridLayout {
                columns: 2
                rowSpacing: 4
                columnSpacing: 8
                Layout.fillWidth: true

                // جهت
                Text {
                    text: "Direction:"
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    font.bold: true
                }

                Text {
                    text: isInput ? "Input" : "Output"
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    Layout.fillWidth: true
                }

                // وضعیت اتصال
                Text {
                    text: "Connected:"
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    font.bold: true
                }

                Text {
                    text: isConnected ? "Yes" : "No"
                    color: isConnected ? theme.success : theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    Layout.fillWidth: true
                }

                // اختیاری
                Text {
                    text: "Optional:"
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    font.bold: true
                    visible: isOptional
                }

                Text {
                    text: "Yes"
                    color: theme.warning
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    Layout.fillWidth: true
                    visible: isOptional
                }

                // چندتایی
                Text {
                    text: "Multiple:"
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    font.bold: true
                    visible: portModel && portModel.multiple
                }

                Text {
                    text: "Yes"
                    color: theme.info
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    Layout.fillWidth: true
                    visible: portModel && portModel.multiple
                }
            }

            // پیام وضعیت
            Text {
                text: getStatusMessage()
                color: getStatusColor()
                font.family: "Segoe UI"
                font.pixelSize: 9
                font.bold: true
                wrapMode: Text.Wrap
                Layout.fillWidth: true
                visible: text !== ""
            }
        }
    }

    // مدیریت نمایش Tooltip
    onIsHoveredChanged: {
        if (isHovered && portModel) {
            portTooltip.show()
        } else {
            portTooltip.hide()
        }
    }

    // توابع کمکی
    function getPortColor() {
        if (!portModel || !canConnect) return theme.error
        
        var dataType = portModel.dataType
        var colors = {
            "EEGSignal": theme.brainWaveAlpha,
            "ECGSignal": theme.brainWaveBeta, 
            "EMGSignal": theme.brainWaveTheta,
            "FeatureVector": theme.brainWaveDelta,
            "ClassificationResult": theme.brainWaveGamma,
            "ControlSignal": theme.accent,
            "Configuration": theme.secondary,
            "Trigger": theme.warning,
            "AudioSignal": "#FF6D00",
            "VideoSignal": "#9C27B0",
            "Boolean": "#757575",
            "Number": "#009688",
            "String": "#795548"
        }
        return colors[dataType] || theme.primary
    }

    function getBorderColor() {
        if (!canConnect) return theme.error
        if (isHovered && canConnect) return theme.textPrimary
        if (isConnected) return theme.backgroundPrimary
        return theme.border
    }

    function getDataTypeIcon() {
        if (!portModel) return "?"
        
        var dataType = portModel.dataType
        var icons = {
            "EEGSignal": "🧠",
            "ECGSignal": "❤️",
            "EMGSignal": "💪",
            "FeatureVector": "📊",
            "ClassificationResult": "🎯",
            "ControlSignal": "🎮",
            "Configuration": "⚙️",
            "Trigger": "🔔",
            "AudioSignal": "🔊",
            "VideoSignal": "📹",
            "Boolean": "🔲",
            "Number": "🔢",
            "String": "🔤"
        }
        return icons[dataType] || "📌"
    }

    function getDataTypeDescription(dataType) {
        var descriptions = {
            "EEGSignal": "EEG Signal Data",
            "ECGSignal": "ECG Signal Data",
            "EMGSignal": "EMG Signal Data", 
            "FeatureVector": "Feature Vector",
            "ClassificationResult": "Classification Result",
            "ControlSignal": "Control Signal",
            "Configuration": "Configuration Data",
            "Trigger": "Trigger Signal",
            "AudioSignal": "Audio Signal",
            "VideoSignal": "Video Signal",
            "Boolean": "Boolean Value",
            "Number": "Numeric Value",
            "String": "Text String"
        }
        return descriptions[dataType] || dataType
    }

    function getDataTypeAbbreviation(dataType) {
        var abbreviations = {
            "EEGSignal": "EEG",
            "ECGSignal": "ECG",
            "EMGSignal": "EMG",
            "FeatureVector": "FT",
            "ClassificationResult": "CLS",
            "ControlSignal": "CTL",
            "Configuration": "CFG",
            "Trigger": "TRG",
            "AudioSignal": "AUD",
            "VideoSignal": "VID",
            "Boolean": "BOOL",
            "Number": "NUM",
            "String": "STR"
        }
        return abbreviations[dataType] || "??"
    }

    function getStatusMessage() {
        if (!canConnect) return "Port is disabled"
        if (isConnected) return "Port is connected"
        if (isOptional) return "Optional port - connection not required"
        return "Click to connect or double-click for quick connect"
    }

    function getStatusColor() {
        if (!canConnect) return theme.error
        if (isConnected) return theme.success
        if (isOptional) return theme.warning
        return theme.info
    }

    // تابع برای بروزرسانی وضعیت اتصال
    function updateConnectionStatus(connected) {
        isConnected = connected
    }

    // تابع برای غیرفعال کردن پورت
    function disablePort() {
        canConnect = false
    }

    // تابع برای فعال کردن پورت
    function enablePort() {
        canConnect = true
    }

    // تابع برای تنظیم وضعیت اختیاری
    function setOptional(optional) {
        isOptional = optional
    }

    // تابع برای گرفتن موقعیت پورت در مختصات جهانی
    function getGlobalPosition() {
        return portItem.mapToItem(null, portCircle.x + portCircle.width/2, portCircle.y + portCircle.height/2)
    }

    // تابع برای بررسی سازگاری پورت‌ها
    function isCompatibleWith(otherPort) {
        if (!portModel || !otherPort || !canConnect || !otherPort.canConnect) return false
        
        // پورت‌های ورودی و خروجی باید مخالف جهت باشند
        if (isInput === otherPort.isInput) return false
        
        // بررسی نوع داده
        return portModel.dataType === otherPort.dataType
    }

    Component.onCompleted: {
        if (portModel) {
            console.log("PortItem created:", portModel.name, "Type:", portModel.dataType)
        }
    }
}
