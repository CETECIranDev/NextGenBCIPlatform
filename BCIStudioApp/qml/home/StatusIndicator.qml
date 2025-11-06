import QtQuick 2.15

Rectangle {
    id: statusIndicator
    height: 50
    radius: 8
    color: appTheme.backgroundTertiary
    border.color: appTheme.borderLight
    border.width: 1

    property string label: "Status"
    property string status: "normal" // normal, good, warning, error
    property string value: "0"
    property string icon: "📊"

    Row {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // Status icon with color coding
        Rectangle {
            width: 30
            height: 30
            radius: 6
            color: getStatusColor()
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: statusIndicator.icon
                font.pixelSize: 14
                anchors.centerIn: parent
            }
        }

        // Text content
        Column {
            width: parent.width - 50
            spacing: 2
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: statusIndicator.label
                color: appTheme.textSecondary
                font.family: robotoRegular.name
                font.pixelSize: 12
                width: parent.width
                elide: Text.ElideRight
            }

            Text {
                text: statusIndicator.value
                color: appTheme.textPrimary
                font.family: robotoBold.name
                font.pixelSize: 14
                width: parent.width
                elide: Text.ElideRight
            }
        }
    }

    function getStatusColor() {
        switch(statusIndicator.status) {
            case "connected":
            case "good":
                return appTheme.success + "40"
            case "warning":
                return appTheme.warning + "40"
            case "error":
                return appTheme.error + "40"
            default:
                return appTheme.primary + "40"
        }
    }
}