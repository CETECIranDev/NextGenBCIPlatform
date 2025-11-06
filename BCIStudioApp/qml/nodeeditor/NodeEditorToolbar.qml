import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: editorToolbar
    height: 70
    color: appTheme.backgroundSecondary
    radius: 12

    property var nodeGraph
    property var selectedNodes: []
    property var canvas
    property bool isExecuting: false
    property real executionProgress: 0.0
    property bool leftSidebarCollapsed: false
    property bool rightSidebarCollapsed: false

    signal zoomIn()
    signal zoomOut()
    signal zoomReset()
    signal fitToView()
    signal layoutGraph()
    signal clearGraph()
    signal runGraph()
    signal stopGraph()
    signal saveGraph()
    signal loadGraph()
    signal newGraph()
    signal validateGraph()
    signal exportGraph()
    signal undo()
    signal redo()
    signal toggleLeftSidebar()
    signal toggleRightSidebar()

    // Shadow effect
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 2
        radius: 8
        samples: 17
        color: "#20000000"
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // File Controls
        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            ToolButton {
                text: "📄"
                ToolTip.text: "New Graph (Ctrl+N)"
                ToolTip.delay: 300
                onClicked: editorToolbar.newGraph()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }

            ToolButton {
                text: "📂"
                ToolTip.text: "Load Graph (Ctrl+O)"
                ToolTip.delay: 300
                onClicked: editorToolbar.loadGraph()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }

            ToolButton {
                text: "💾"
                ToolTip.text: "Save Graph (Ctrl+S)"
                ToolTip.delay: 300
                enabled: nodeGraph && nodeGraph.nodes.length > 0
                onClicked: editorToolbar.saveGraph()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }
        }

        // Edit Controls
        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            ToolButton {
                text: "↶"
                ToolTip.text: "Undo (Ctrl+Z)"
                ToolTip.delay: 300
                onClicked: editorToolbar.undo()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }

            ToolButton {
                text: "↷"
                ToolTip.text: "Redo (Ctrl+Y)"
                ToolTip.delay: 300
                onClicked: editorToolbar.redo()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }
        }

        // Execution Controls
        Row {
            spacing: 12
            Layout.alignment: Qt.AlignVCenter

            Button {
                text: isExecuting ? "⏹️ Stop" : "🚀 Run Pipeline"
                ToolTip.text: isExecuting ? "Stop Execution (Esc)" : "Run Pipeline (F5)"
                ToolTip.delay: 300
                enabled: nodeGraph && nodeGraph.nodes.length > 0 && (!isExecuting || true)
                implicitHeight: 36
                implicitWidth: 140

                background: Rectangle {
                    color: isExecuting ? appTheme.error : appTheme.success
                    radius: 8
                    opacity: parent.enabled ? 1.0 : 0.5

                    layer.enabled: true
                    layer.effect: DropShadow {
                        transparentBorder: true
                        horizontalOffset: 0
                        verticalOffset: 2
                        radius: 4
                        samples: 9
                        color: isExecuting ? "#40EF476F" : "#404ECDC4"
                    }
                }

                contentItem: Row {
                    spacing: 6
                    anchors.centerIn: parent

                    Text {
                        text: isExecuting ? "⏹️" : "🚀"
                        font.pixelSize: 14
                        color: "white"
                    }

                    Text {
                        text: isExecuting ? "Stop" : "Run"
                        color: "white"
                        font.family: "Segoe UI Semibold"
                        font.pixelSize: 12
                        font.weight: Font.DemiBold
                    }
                }

                onClicked: isExecuting ? editorToolbar.stopGraph() : editorToolbar.runGraph()
            }

            // Progress bar during execution
            ProgressBar {
                width: 120
                height: 6
                value: executionProgress
                visible: isExecuting
                Layout.alignment: Qt.AlignVCenter

                background: Rectangle {
                    color: appTheme.backgroundTertiary
                    radius: 3
                }

                contentItem: Rectangle {
                    color: appTheme.success
                    radius: 3

                    Behavior on width {
                        NumberAnimation { duration: 200 }
                    }
                }
            }
        }

        // View Controls
        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            ToolButton {
                text: "🔍+"
                ToolTip.text: "Zoom In (Ctrl++)"
                ToolTip.delay: 300
                onClicked: editorToolbar.zoomIn()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }

            ToolButton {
                text: "🔍-"
                ToolTip.text: "Zoom Out (Ctrl+-)"
                ToolTip.delay: 300
                onClicked: editorToolbar.zoomOut()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }

            ToolButton {
                text: "🔍"
                ToolTip.text: "Reset Zoom (Ctrl+0)"
                ToolTip.delay: 300
                onClicked: editorToolbar.zoomReset()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }

            ToolButton {
                text: "📐"
                ToolTip.text: "Fit to View (Ctrl+F)"
                ToolTip.delay: 300
                enabled: nodeGraph && nodeGraph.nodes.length > 0
                onClicked: editorToolbar.fitToView()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }
        }

        // Graph Controls
        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            ToolButton {
                text: "🔄"
                ToolTip.text: "Auto Layout"
                ToolTip.delay: 300
                enabled: nodeGraph && nodeGraph.nodes.length > 0
                onClicked: editorToolbar.layoutGraph()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }

            ToolButton {
                text: "✓"
                ToolTip.text: "Validate Pipeline"
                ToolTip.delay: 300
                enabled: nodeGraph && nodeGraph.nodes.length > 0
                onClicked: editorToolbar.validateGraph()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }

            ToolButton {
                text: "🧹"
                ToolTip.text: "Clear Graph"
                ToolTip.delay: 300
                enabled: nodeGraph && nodeGraph.nodes.length > 0
                onClicked: editorToolbar.clearGraph()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.error.r, appTheme.error.g, appTheme.error.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.error : "transparent"
                    border.width: 1
                }
            }
        }

        // Sidebar Controls
        Row {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter

            ToolButton {
                text: leftSidebarCollapsed ? "◀" : "▶"
                ToolTip.text: leftSidebarCollapsed ? "Show Toolbox" : "Hide Toolbox"
                ToolTip.delay: 300
                onClicked: editorToolbar.toggleLeftSidebar()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }

            ToolButton {
                text: rightSidebarCollapsed ? "▶" : "◀"
                ToolTip.text: rightSidebarCollapsed ? "Show Properties" : "Hide Properties"
                ToolTip.delay: 300
                onClicked: editorToolbar.toggleRightSidebar()

                background: Rectangle {
                    color: parent.hovered ? Qt.rgba(appTheme.primary.r, appTheme.primary.g, appTheme.primary.b, 0.15) : "transparent"
                    radius: 8
                    border.color: parent.hovered ? appTheme.primary : "transparent"
                    border.width: 1
                }
            }
        }

        // Spacer
        Item { Layout.fillWidth: true }

        // Status Information
        Row {
            spacing: 20
            Layout.alignment: Qt.AlignVCenter

            // Nodes Count
            StatusItem {
                icon: "🧩"
                value: nodeGraph ? nodeGraph.nodes.length : 0
                label: "Nodes"
                tooltip: "Total nodes in pipeline"
                color: appTheme.primary
            }

            // Connections Count
            StatusItem {
                icon: "🔗"
                value: nodeGraph ? nodeGraph.connections.length : 0
                label: "Connections"
                tooltip: "Total connections"
                color: appTheme.secondary
            }

            // Selected Nodes
            StatusItem {
                icon: "📍"
                value: selectedNodes.length
                label: "Selected"
                tooltip: "Selected nodes"
                visible: selectedNodes.length > 0
                color: appTheme.accent
            }

            // Zoom Level
            StatusItem {
                icon: "🔍"
                value: canvas ? Math.round(canvas.zoomLevel * 100) + "%" : "100%"
                label: "Zoom"
                tooltip: "Current zoom level"
                color: appTheme.info
            }

            // Execution Status
            StatusItem {
                icon: isExecuting ? "⚡" : "✅"
                value: isExecuting ? "Running" : "Ready"
                label: "Status"
                tooltip: isExecuting ? "Pipeline is executing" : "Pipeline is ready"
                color: isExecuting ? appTheme.warning : appTheme.success
            }
        }
    }

    // Status Item Component
    component StatusItem: ColumnLayout {
        property string icon: "⚙️"
        property string value: "0"
        property string label: "Label"
        property string tooltip: ""
        property color color: appTheme.textPrimary

        spacing: 2

        RowLayout {
            spacing: 6
            Layout.alignment: Qt.AlignHCenter

            Text {
                text: parent.parent.icon
                font.pixelSize: 12
                color: parent.parent.color
            }

            Text {
                text: parent.parent.value
                color: appTheme.textPrimary
                font.family: "Segoe UI Semibold"
                font.pixelSize: 12
                font.weight: Font.DemiBold
            }
        }

        Text {
            text: parent.parent.label
            color: appTheme.textTertiary
            font.family: "Segoe UI"
            font.pixelSize: 9
            font.weight: Font.Medium
            Layout.alignment: Qt.AlignHCenter
        }

        ToolTip.text: parent.parent.tooltip
        ToolTip.delay: 300
        ToolTip.visible: ma.containsMouse

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    // Keyboard shortcuts
    Shortcut {
        sequence: "Ctrl++"
        onActivated: editorToolbar.zoomIn()
    }

    Shortcut {
        sequence: "Ctrl+-"
        onActivated: editorToolbar.zoomOut()
    }

    Shortcut {
        sequence: "Ctrl+0"
        onActivated: editorToolbar.zoomReset()
    }

    Shortcut {
        sequence: "Ctrl+F"
        onActivated: editorToolbar.fitToView()
    }

    Shortcut {
        sequence: "F5"
        onActivated: if (!isExecuting) editorToolbar.runGraph()
    }

    Shortcut {
        sequence: "Escape"
        onActivated: if (isExecuting) editorToolbar.stopGraph()
    }

    Shortcut {
        sequence: "Ctrl+N"
        onActivated: editorToolbar.newGraph()
    }

    Shortcut {
        sequence: "Ctrl+O"
        onActivated: editorToolbar.loadGraph()
    }

    Shortcut {
        sequence: "Ctrl+S"
        onActivated: editorToolbar.saveGraph()
    }

    Shortcut {
        sequence: "Ctrl+Z"
        onActivated: editorToolbar.undo()
    }

    Shortcut {
        sequence: "Ctrl+Y"
        onActivated: editorToolbar.redo()
    }

    // Animations
    Behavior on height {
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }

    // Function to update execution status
    function updateExecutionStatus(executing, progress) {
        isExecuting = executing
        executionProgress = progress
    }

    // Function to show message
    function showMessage(message, type) {
        console.log("Toolbar Message [" + type + "]:", message)
        // Could integrate with a notification system here
    }

    Component.onCompleted: {
        console.log("Modern NodeEditorToolbar initialized")
    }
}
