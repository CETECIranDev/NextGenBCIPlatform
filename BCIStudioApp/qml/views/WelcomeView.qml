import QtQuick
import QtQuick.Layouts
import QtQuick.Controls // هنوز برای Button و SplitView لازم است


import "../components"
//import "../theme"

Item {
    id: root

    signal newProjectClicked()


    ColumnLayout {
        anchors.centerIn: parent
        spacing: themeManager.spacingLarge

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "BCI Studio"
            color: themeManager.textPrimary
            font: themeManager.fontDisplay
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            text: "The Next-Generation Platform for Biosignal Processing"
            color: themeManager.textSecondary
            font: themeManager.fontBase
            bottomPadding: themeManager.spacingLarge
        }

        GridLayout {
            columns: 2
            columnSpacing: themeManager.spacingLarge
            rowSpacing: themeManager.spacingLarge

            ActionButton {
                text: "New Project"
                iconSource: "qrc:/qml/assets/icons/plus-circle.svg"
                Layout.preferredWidth: 180
                Layout.preferredHeight: 120
                //onClicked: console.log("New Project clicked!")
                onClicked: root.newProjectClicked()
            }

            ActionButton {
                text: "Open Project"
                iconSource: "qrc:/qml/assets/icons/folder-open.svg"
                Layout.preferredWidth: 180
                Layout.preferredHeight: 120
                onClicked: console.log("Open Project clicked!")
            }

            ActionButton {
                text: "Documentation"
                iconSource: "qrc:/qml/assets/icons/book-open.svg"
                Layout.preferredWidth: 180
                Layout.preferredHeight: 120
                onClicked: console.log("Documentation clicked!")
            }

            ActionButton {
                text: "Settings"
                iconSource: "qrc:/qml/assets/icons/settings.svg"
                Layout.preferredWidth: 180
                Layout.preferredHeight: 120
                onClicked: console.log("Settings clicked!")
            }
        }
    }
}
