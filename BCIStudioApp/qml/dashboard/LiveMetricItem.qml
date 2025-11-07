// QualityDistributionItem.qml

// SignalQualityMap.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects


// LiveMetricItem.qml
Rectangle {
    height: 40
    radius: 8
    color: Qt.rgba(parent.parent.color.r, parent.parent.color.g, parent.parent.color.b, 0.1)
    border.color: parent.parent.color
    border.width: 1

    property string label: ""
    property real value: 0
    property string unit: ""
    property color color: theme.primary
    property string icon: "📊"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Text {
            text: parent.parent.icon
            font.pixelSize: 14
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true

            Text {
                text: parent.parent.label
                color: theme.textSecondary
                font.pixelSize: 9
                Layout.fillWidth: true
            }

            Text {
                text: parent.parent.value + parent.parent.unit
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: 12
                Layout.fillWidth: true
            }
        }
    }
}