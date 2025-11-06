import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    id: portItem
    height: 20
    color: "transparent"

    property var portModel
    property bool isInput: true
    property bool isConnected: portModel ? portModel.connected : false
    property bool isHovered: false

    signal connectionStarted(var mouse)
    signal connectionFinished()

    RowLayout {
        anchors.fill: parent
        spacing: 6
        layoutDirection: isInput ? Qt.LeftToRight : Qt.RightToLeft

        // دایره پورت
        Rectangle {
            id: portCircle
            width: 12
            height: 12
            radius: 6
            color: getPortColor()
            border.color: isHovered ? appTheme.textPrimary : appTheme.border
            border.width: 1

            // انیمیشن hover
            Behavior on scale {
                NumberAnimation { duration: 100 }
            }

            scale: portMouseArea.containsMouse ? 1.2 : 1.0
        }

        // نام پورت
        Text {
            text: portModel ? portModel.name : "Unknown"
            color: appTheme.textSecondary
            font.pixelSize: 10
            elide: Text.ElideRight
            Layout.fillWidth: true
            horizontalAlignment: isInput ? Text.AlignLeft : Text.AlignRight
        }

        // نوع داده
        Text {
            text: portModel ? getDataTypeAbbreviation(portModel.dataType) : "?"
            color: appTheme.textDisabled
            font.pixelSize: 8
            font.bold: true
            Layout.preferredWidth: 16
        }
    }

    MouseArea {
        id: portMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.CrossCursor
        acceptedButtons: Qt.LeftButton

        onEntered: isHovered = true
        onExited: isHovered = false

        onPressed: (mouse) => {
            portItem.connectionStarted(mouse)
            mouse.accepted = true
        }

        onReleased: {
            portItem.connectionFinished()
        }
    }

    function getPortColor() {
        if (!portModel) return appTheme.textDisabled

        var dataType = portModel.dataType
        var colors = {
            "EEGSignal": appTheme.primary,
            "ECGSignal": appTheme.error,
            "EMGSignal": appTheme.warning,
            "FeatureVector": appTheme.success,
            "ClassificationResult": appTheme.secondary,
            "ControlSignal": appTheme.accent
        }
        return colors[dataType] || appTheme.textDisabled
    }

    function getDataTypeAbbreviation(dataType) {
        var abbreviations = {
            "EEGSignal": "EEG",
            "ECGSignal": "ECG",
            "EMGSignal": "EMG",
            "FeatureVector": "FT",
            "ClassificationResult": "CLS",
            "ControlSignal": "CTL"
        }
        return abbreviations[dataType] || "??"
    }
}
