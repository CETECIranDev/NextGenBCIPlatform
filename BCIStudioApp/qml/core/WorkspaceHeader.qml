import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
Rectangle {
    id: workspaceHeader
    height: 60
    color: appTheme.backgroundSecondary
    border.color: appTheme.border
    border.width: 1

    property string currentWorkspace: "dashboard"

    RowLayout {
        anchors.fill: parent
        spacing: 20

        // عنوان workspace
        Text {
            text: {
                switch(currentWorkspace) {
                    case "dashboard": return "📊 Dashboard"
                    case "nodeeditor": return "🧩 Node Editor"
                    case "pipeline": return "⚡ Pipeline Executor"
                    case "bci": return "🎯 BCI Paradigms"
                    default: return "BCI Studio Pro"
                }
            }
            color: appTheme.textPrimary
            font.bold: true
            font.pixelSize: 18
            Layout.leftMargin: 20
        }

        Item { Layout.fillWidth: true }

        // کنترل‌های سریع
        Row {
            spacing: 10
            Layout.rightMargin: 20

            Button {
                text: "▶️ Run"
                background: Rectangle {
                    color: appTheme.success
                    radius: appTheme.radiusSmall
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }
                onClicked: console.log("Pipeline execution started")
            }

            Button {
                text: "⏹️ Stop"
                background: Rectangle {
                    color: appTheme.error
                    radius: appTheme.radiusSmall
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Button {
                text: "💾 Save"
                background: Rectangle {
                    color: appTheme.primary
                    radius: appTheme.radiusSmall
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
}
