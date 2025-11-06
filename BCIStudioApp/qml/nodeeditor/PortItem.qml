import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: portItem
    height: 28
    color: "transparent"

    // Propertyهای سازگار با delegate
    property var portModel: null
    property bool isInput: true

    // Propertyهای computed از portModel
    property string portName: portModel ? portModel.name : ""
    property string portType: portModel ? portModel.dataType : ""
    property string portDirection: portModel ? portModel.direction : "input"
    property bool isConnected: portModel ? (portModel.connected || false) : false
    property string portDescription: portModel ? portModel.description : ""
    property bool portOptional: portModel ? (portModel.optional || false) : false
    property bool portMultiple: portModel ? (portModel.multiple || false) : false
    property bool portCanConnect: portModel ? (portModel.canConnect !== false) : true
    property bool portShowConnectionStatus: portModel ? (portModel.showConnectionStatus !== false) : true

    property bool isHovered: false
    property var theme: ({
        "textPrimary": "#212529",
        "textSecondary": "#6C757D",
        "textTertiary": "#ADB5BD",
        "backgroundPrimary": "#FFFFFF",
        "border": "#DEE2E6",
        "primary": "#4361EE",
        "secondary": "#3A0CA3",
        "accent": "#7209B7",
        "success": "#4CC9F0",
        "warning": "#F72585",
        "error": "#EF476F",
        "info": "#4895EF",
        "brainWaveAlpha": "#4CAF50",
        "brainWaveBeta": "#2196F3",
        "brainWaveTheta": "#FF9800",
        "brainWaveDelta": "#9C27B0",
        "brainWaveGamma": "#F44336"
    })
    // در ابتدای PortItem.qml این propertyها را اضافه کنید
    property string portId: portModel ? portModel.portId : ("port_" + Math.random().toString(36).substr(2, 9))
    property alias portCircle: portCircle // برای دسترسی از خارج

    // تابع برای گرفتن موقعیت مرکز پورت
    function getCenterPosition() {
        return mapToItem(null, portCircle.x + portCircle.width/2, portCircle.y + portCircle.height/2)
    }

    // سیگنال‌ها
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
                visible: portMouseArea.containsMouse && portCanConnect
                scale: portMouseArea.containsPress ? 0.8 : 1.0
            }

            // آیکون غیرفعال
            Text {
                text: "⛔"
                font.pixelSize: 8
                color: "white"
                anchors.centerIn: parent
                visible: !portCanConnect
            }

            // نشانگر پورت اختیاری
            Rectangle {
                width: 6
                height: 6
                radius: 3
                color: theme.warning
                border.color: "white"
                border.width: 1
                visible: portOptional
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
                    text: portName || "Unknown Port"
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
                    visible: portShowConnectionStatus
                }
            }

            // نوع داده و اطلاعات
            RowLayout {
                Layout.fillWidth: true
                spacing: 6
                layoutDirection: isInput ? Qt.LeftToRight : Qt.RightToLeft

                Text {
                    text: getDataTypeDescription(portType)
                    color: theme.textSecondary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                    horizontalAlignment: isInput ? Text.AlignLeft : Text.AlignRight
                }

                // نشانگر چندتایی
                Text {
                    text: portMultiple ? "[]" : ""
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 8
                    font.bold: true
                    visible: portMultiple
                }
            }

            // توضیحات پورت
            Text {
                text: portDescription || ""
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
            if (mouse.button === Qt.LeftButton && portCanConnect) {
                portItem.connectionStarted(portModel, mouse)
                mouse.accepted = true
            } else if (mouse.button === Qt.RightButton) {
                portItem.portRightClicked(portModel)
                mouse.accepted = true
            }
        }

        onReleased: (mouse) => {
            if (mouse.button === Qt.LeftButton && portCanConnect) {
                portItem.connectionFinished(portModel)
            }
        }

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                portItem.portClicked(portModel)
            }
        }

        onDoubleClicked: {
            if (portCanConnect) {
                // ایجاد اتصال سریع با دابل کلیک
                portItem.connectionStarted(portModel, {x: portCircle.width/2, y: portCircle.height/2})
            }
        }

        function getCursorShape() {
            if (!portCanConnect) return Qt.ForbiddenCursor
            if (isConnected) return Qt.PointingHandCursor
            return Qt.CrossCursor
        }
    }

    // Tooltip برای اطلاعات بیشتر
    ToolTip {
        id: portTooltip
        delay: 500
        timeout: 4000
        visible: portMouseArea.containsMouse && portModel

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
                    text: portName || "Unknown Port"
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
                    text: getDataTypeDescription(portType)
                    color: theme.textSecondary
                    font.family: "Segoe UI"
                    font.pixelSize: 10
                    Layout.fillWidth: true
                }

                Text {
                    text: portDescription || "No description available"
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
                    visible: portOptional
                }

                Text {
                    text: "Yes"
                    color: theme.warning
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    Layout.fillWidth: true
                    visible: portOptional
                }

                // چندتایی
                Text {
                    text: "Multiple:"
                    color: theme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    font.bold: true
                    visible: portMultiple
                }

                Text {
                    text: "Yes"
                    color: theme.info
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    Layout.fillWidth: true
                    visible: portMultiple
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
                Layout.topMargin: 4
            }
        }
    }

    // توابع کمکی
    function getPortColor() {
        if (!portModel || !portCanConnect) return theme.error

        var dataType = portType || "Unknown"
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
            "String": "#795548",
            "Unknown": theme.primary
        }
        return colors[dataType] || theme.primary
    }

    function getBorderColor() {
        if (!portCanConnect) return theme.error
        if (isHovered && portCanConnect) return theme.textPrimary
        if (isConnected) return theme.backgroundPrimary
        return theme.border
    }

    function getDataTypeIcon() {
        if (!portModel) return "?"

        var dataType = portType || "Unknown"
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
            "String": "🔤",
            "Unknown": "📌"
        }
        return icons[dataType] || "📌"
    }

    function getDataTypeDescription(dataType) {
        if (!dataType) return "Unknown Data Type"

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

    function getStatusMessage() {
        if (!portCanConnect) return "Port is disabled"
        if (isConnected) return "Port is connected"
        if (portOptional) return "Optional port - connection not required"
        return "Click to connect or double-click for quick connect"
    }

    function getStatusColor() {
        if (!portCanConnect) return theme.error
        if (isConnected) return theme.success
        if (portOptional) return theme.warning
        return theme.info
    }

    // تابع برای بروزرسانی وضعیت اتصال
    function updateConnectionStatus(connected) {
        isConnected = connected
        if (portModel) {
            portModel.connected = connected
        }
    }

    // تابع برای غیرفعال کردن پورت
    function disablePort() {
        portCanConnect = false
        if (portModel) {
            portModel.canConnect = false
        }
    }

    // تابع برای فعال کردن پورت
    function enablePort() {
        portCanConnect = true
        if (portModel) {
            portModel.canConnect = true
        }
    }

    // تابع برای تنظیم وضعیت اختیاری
    function setOptional(optional) {
        portOptional = optional
        if (portModel) {
            portModel.optional = optional
        }
    }

    // تابع برای گرفتن موقعیت پورت در مختصات جهانی
    function getGlobalPosition() {
        return portItem.mapToItem(null, portCircle.x + portCircle.width/2, portCircle.y + portCircle.height/2)
    }

    // تابع برای بررسی سازگاری پورت‌ها
    function isCompatibleWith(otherPort) {
        if (!portModel || !otherPort || !portCanConnect || !otherPort.portCanConnect) return false

        // پورت‌های ورودی و خروجی باید مخالف جهت باشند
        if (isInput === otherPort.isInput) return false

        // بررسی نوع داده
        var thisDataType = portType || "Unknown"
        var otherDataType = otherPort.portType || "Unknown"
        return thisDataType === otherDataType
    }

    // // تابع برای گرفتن موقعیت مرکز پورت
    // function getCenterPosition() {
    //     var circleCenter = Qt.point(portCircle.width / 2, portCircle.height / 2)
    //     return portCircle.mapToItem(portItem.parent, circleCenter.x, circleCenter.y)
    // }

    Component.onCompleted: {
        if (portModel) {
            console.log("PortItem created:", portName, "Type:", portType, "Input:", isInput)
        }
    }

    Component.onDestruction: {
        if (portModel) {
            console.log("PortItem destroyed:", portName)
        }
    }
}
