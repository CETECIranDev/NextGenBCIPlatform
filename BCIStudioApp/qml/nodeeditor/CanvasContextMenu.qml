import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects


Popup {
    id: canvasContextMenu
    width: 280
    height: contentColumn.height + 32
    padding: 0
    modal: true
    dim: false
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property var canvas: null
    property point clickPos: Qt.point(0, 0)
    property var nodeRegistry: null

    signal pasteNodes()
    signal selectAll()
    signal deselectAll()
    signal createNode(string nodeType)
    signal importGraph()
    signal exportGraph()
    signal layoutGraph()
    signal clearGraph()

    background: Rectangle {
        color: appTheme.backgroundSecondary
        radius: 12
        border.color: appTheme.border
        border.width: 1

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 4
            radius: 20
            samples: 25
            color: "#40000000"
        }
    }

    Column {
        id: contentColumn
        width: parent.width
        spacing: 0

        // Header
        Rectangle {
            width: parent.width
            height: 48
            color: "transparent"

            Row {
                anchors.centerIn: parent
                spacing: 12

                Rectangle {
                    width: 32
                    height: 32
                    radius: 8
                    color: appTheme.primary
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: "🎛️"
                        font.pixelSize: 16
                        anchors.centerIn: parent
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        text: "Canvas Menu"
                        color: appTheme.textPrimary
                        font.family: "Segoe UI Semibold"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: "Quick actions & tools"
                        color: appTheme.textTertiary
                        font.family: "Segoe UI"
                        font.pixelSize: 11
                    }
                }
            }
        }

        // Divider
        Rectangle {
            width: parent.width
            height: 1
            color: appTheme.border
        }

        // Edit Section
        MenuSection {
            title: "EDIT"
            icon: "✏️"

            ModernMenuItem {
                text: "Paste Nodes"
                shortcut: "Ctrl+V"
                icon: "📋"
                enabled: canvas && canvas.hasNodesInClipboard
                onClicked: canvasContextMenu.pasteNodes()
            }

            ModernMenuItem {
                text: "Select All"
                shortcut: "Ctrl+A"
                icon: "☑️"
                enabled: canvas && canvas.nodeCount > 0
                onClicked: canvasContextMenu.selectAll()
            }

            ModernMenuItem {
                text: "Deselect All"
                shortcut: "Ctrl+Shift+A"
                icon: "🔲"
                enabled: canvas && canvas.selectedNodesCount > 0
                onClicked: canvasContextMenu.deselectAll()
            }
        }

        // Create Nodes Section
        MenuSection {
            title: "CREATE NODES"
            icon: "➕"

            // Data Acquisition
            MenuItemGroup {
                title: "Data Acquisition"
                icon: "📊"

                ModernMenuItem {
                    text: "EEG Input"
                    icon: "🧠"
                    onClicked: canvasContextMenu.createNode("eeg_input")
                }

                ModernMenuItem {
                    text: "Signal Generator"
                    icon: "📡"
                    onClicked: canvasContextMenu.createNode("signal_generator")
                }

                ModernMenuItem {
                    text: "File Reader"
                    icon: "📁"
                    onClicked: canvasContextMenu.createNode("file_reader")
                }
            }

            // Preprocessing
            MenuItemGroup {
                title: "Preprocessing"
                icon: "🔧"

                ModernMenuItem {
                    text: "Bandpass Filter"
                    icon: "📈"
                    onClicked: canvasContextMenu.createNode("bandpass_filter")
                }

                ModernMenuItem {
                    text: "Notch Filter"
                    icon: "🔇"
                    onClicked: canvasContextMenu.createNode("notch_filter")
                }

                ModernMenuItem {
                    text: "Artifact Removal"
                    icon: "✨"
                    onClicked: canvasContextMenu.createNode("artifact_removal")
                }
            }

            // Feature Extraction
            MenuItemGroup {
                title: "Feature Extraction"
                icon: "🎯"

                ModernMenuItem {
                    text: "CSP Features"
                    icon: "🧩"
                    onClicked: canvasContextMenu.createNode("csp_features")
                }

                ModernMenuItem {
                    text: "PSD Features"
                    icon: "📊"
                    onClicked: canvasContextMenu.createNode("psd_features")
                }

                ModernMenuItem {
                    text: "Wavelet Features"
                    icon: "🌊"
                    onClicked: canvasContextMenu.createNode("wavelet_features")
                }
            }

            // Classification
            MenuItemGroup {
                title: "Classification"
                icon: "🤖"

                ModernMenuItem {
                    text: "LDA Classifier"
                    icon: "📐"
                    onClicked: canvasContextMenu.createNode("lda_classifier")
                }

                ModernMenuItem {
                    text: "SVM Classifier"
                    icon: "⚡"
                    onClicked: canvasContextMenu.createNode("svm_classifier")
                }

                ModernMenuItem {
                    text: "Neural Network"
                    icon: "🕸️"
                    onClicked: canvasContextMenu.createNode("neural_network")
                }
            }

            // Visualization
            MenuItemGroup {
                title: "Visualization"
                icon: "📉"

                ModernMenuItem {
                    text: "Signal Plot"
                    icon: "📈"
                    onClicked: canvasContextMenu.createNode("signal_plot")
                }

                ModernMenuItem {
                    text: "Spectrogram"
                    icon: "🌈"
                    onClicked: canvasContextMenu.createNode("spectrogram")
                }

                ModernMenuItem {
                    text: "Topographic Map"
                    icon: "🗺️"
                    onClicked: canvasContextMenu.createNode("topographic_map")
                }
            }
        }

        // Graph Management Section
        MenuSection {
            title: "GRAPH MANAGEMENT"
            icon: "🔗"

            ModernMenuItem {
                text: "Auto Layout"
                icon: "🔄"
                enabled: canvas && canvas.nodeCount > 0
                onClicked: canvasContextMenu.layoutGraph()
            }

            ModernMenuItem {
                text: "Import Graph..."
                icon: "📥"
                onClicked: canvasContextMenu.importGraph()
            }

            ModernMenuItem {
                text: "Export Graph..."
                icon: "📤"
                enabled: canvas && canvas.nodeCount > 0
                onClicked: canvasContextMenu.exportGraph()
            }

            ModernMenuItem {
                text: "Clear Graph"
                icon: "🗑️"
                accent: true
                enabled: canvas && canvas.nodeCount > 0
                onClicked: canvasContextMenu.clearGraph()
            }
        }
    }

    // Custom Components
    component MenuSection: Column {
        property string title: ""
        property string icon: ""

        width: parent.width
        spacing: 0

        // Section Header
        Rectangle {
            width: parent.width
            height: 32
            color: Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.1)

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Text {
                    text: parent.parent.icon
                    font.pixelSize: 12
                    color: appTheme.primary
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: parent.parent.title
                    color: appTheme.primary
                    font.family: "Segoe UI"
                    font.pixelSize: 11
                    font.weight: Font.Medium
                    font.letterSpacing: 1
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Section Content
        Column {
            width: parent.width
            spacing: 0
        }
    }

    component MenuItemGroup: Column {
        property string title: ""
        property string icon: ""

        width: parent.width
        spacing: 0

        // Group Header (optional - can be removed for flatter design)
        Rectangle {
            width: parent.width
            height: 28
            color: Qt.rgba(appTheme.textTertiary.r, appTheme.textTertiary.g, appTheme.textTertiary.b, 0.1)
            visible: parent.parent.title !== ""

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 32
                anchors.verticalCenter: parent.verticalCenter
                text: parent.parent.title
                color: appTheme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 10
                font.weight: Font.Medium
            }
        }
    }

    component ModernMenuItem: Rectangle {
        property string text: ""
        property string shortcut: ""
        property string icon: ""
        property bool accent: false
        property bool enabled: true

        width: parent.width
        height: 40
        color: mouseArea.containsMouse ?
               (accent ? Qt.rgba(appTheme.error.r, appTheme.error.g, appTheme.error.b, 0.1) :
                         Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.1)) :
               "transparent"

        Row {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12

            // Icon
            Text {
                text: parent.parent.icon
                font.pixelSize: 14
                color: parent.parent.accent ? appTheme.error :
                       !parent.parent.enabled ? appTheme.textDisabled :
                       appTheme.textSecondary
                anchors.verticalCenter: parent.verticalCenter
                width: 20
            }

            // Text
            Text {
                text: parent.parent.text
                color: parent.parent.accent ? appTheme.error :
                       !parent.parent.enabled ? appTheme.textDisabled :
                       appTheme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 13
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
            }

            // Spacer
            Item { width: 1; height: 1; Layout.fillWidth: true }

            // Shortcut
            Text {
                text: parent.parent.shortcut
                color: parent.parent.accent ? appTheme.error :
                       !parent.parent.enabled ? appTheme.textDisabled :
                       appTheme.textTertiary
                font.family: "Segoe UI"
                font.pixelSize: 10
                anchors.verticalCenter: parent.verticalCenter
                visible: parent.parent.shortcut !== ""
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            enabled: parent.enabled
            onClicked: parent.clicked()
        }

        signal clicked()
    }

    // Open function
    function open(x, y) {
        if (canvas) {
            clickPos = canvas.getMousePosition()
            popup(x, y)
        }
    }

    // Close function
    function closeMenu() {
        close()
    }

    // Animation on open
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
        NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 150 }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
    }
}
