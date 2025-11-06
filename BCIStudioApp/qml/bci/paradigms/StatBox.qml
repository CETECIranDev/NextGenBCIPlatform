// Stat Box Component

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {

    id: statBox

    property string label: ""
    property string value: ""
    property string unit: ""
    //property color color: "#7C4DFF"

    Layout.fillWidth: true
    height: 30
    radius: 4
    color: theme.backgroundLight

    RowLayout {
        anchors.fill: parent
        anchors.margins: 4

        ColumnLayout {
            spacing: 0

            Text {
                text: statBox.label
                color: theme.textSecondary
                font.pixelSize: 8
                font.bold: true
            }

            RowLayout {
                spacing: 2

                Text {
                    text: statBox.value
                    color: statBox.color
                    font.bold: true
                    font.pixelSize: 12
                }

                Text {
                    text: statBox.unit
                    color: theme.textTertiary
                    font.pixelSize: 8
                }
            }
        }

        Item { Layout.fillWidth: true }
    }
}
