import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    id: propertiesPanel
    width: 350
    color: appTheme.backgroundSecondary
    border.color: appTheme.border

    property var selectedNode: null

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // هدر
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: appTheme.backgroundTertiary

            Text {
                text: "⚙️ Properties"
                color: appTheme.textPrimary
                font.bold: true
                font.pixelSize: 16
                anchors.centerIn: parent
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width
                spacing: 15
                anchors.margins: 15

                // وقتی نودی انتخاب نشده
                Text {
                    text: "Select a node to view its properties"
                    color: appTheme.textSecondary
                    font.italic: true
                    Layout.alignment: Qt.AlignCenter
                    visible: !propertiesPanel.selectedNode
                }

                // وقتی نودی انتخاب شده
                ColumnLayout {
                    visible: propertiesPanel.selectedNode
                    spacing: 10
                    width: parent.width

                    Text {
                        text: propertiesPanel.selectedNode ? propertiesPanel.selectedNode.name : ""
                        color: appTheme.textPrimary
                        font.bold: true
                        font.pixelSize: 16
                        Layout.fillWidth: true
                    }

                    Text {
                        text: propertiesPanel.selectedNode ? propertiesPanel.selectedNode.type : ""
                        color: appTheme.textSecondary
                        font.pixelSize: 12
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: appTheme.divider
                        Layout.topMargin: 5
                        Layout.bottomMargin: 5
                    }

                    // پارامترهای نمونه
                    Repeater {
                        model: propertiesPanel.selectedNode ? [
                            { name: "Sampling Rate", value: "250 Hz", type: "number" },
                            { name: "Channels", value: "8", type: "number" },
                            { name: "Buffer Size", value: "1000", type: "number" },
                            { name: "Filter Type", value: "Bandpass", type: "string" }
                        ] : []

                        delegate: ColumnLayout {
                            spacing: 5
                            Layout.fillWidth: true

                            Text {
                                text: modelData.name
                                color: appTheme.textSecondary
                                font.pixelSize: 12
                            }

                            TextField {
                                text: modelData.value
                                Layout.fillWidth: true
                                background: Rectangle {
                                    color: appTheme.backgroundCard
                                    radius: appTheme.radiusSmall
                                }
                                color: appTheme.textPrimary
                            }
                        }
                    }
                }
            }
        }
    }
}
