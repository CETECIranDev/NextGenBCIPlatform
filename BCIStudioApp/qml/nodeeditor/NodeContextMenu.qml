import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Popup {
    id: nodeContextMenu
    width: 220
    height: contentColumn.height + 20
    padding: 0
    modal: true
    dim: false
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    property var node: null
    property var theme: ({
        "backgroundPrimary": "#FFFFFF",
        "backgroundSecondary": "#F8F9FA",
        "backgroundTertiary": "#E9ECEF",
        "primary": "#4361EE",
        "secondary": "#3A0CA3",
        "accent": "#7209B7",
        "success": "#4CC9F0",
        "warning": "#F72585",
        "error": "#EF476F",
        "info": "#4895EF",
        "textPrimary": "#212529",
        "textSecondary": "#6C757D",
        "textTertiary": "#ADB5BD",
        "border": "#DEE2E6"
    })

    signal deleteNode()
    signal cloneNode()
    signal editProperties()
    signal editNode()
    signal copyNode()
    signal cutNode()
    signal disableNode()
    signal enableNode()
    signal duplicateNode()
    signal exportNode()
    signal inspectNode()
    signal createTemplate()

    background: Rectangle {
        color: theme.backgroundSecondary
        radius: 12
        border.color: theme.border
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
            height: 60
            color: "transparent"

            Row {
                anchors.centerIn: parent
                spacing: 12

                Rectangle {
                    width: 36
                    height: 36
                    radius: 8
                    color: node ? getNodeColor(node.category) : theme.primary
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: node ? node.icon : "⚙️"
                        font.pixelSize: 16
                        color: "white"
                        anchors.centerIn: parent
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    Text {
                        text: node ? node.name : "Node Menu"
                        color: theme.textPrimary
                        font.family: "Segoe UI Semibold"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: node ? node.category : "Context actions"
                        color: theme.textTertiary
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
            color: theme.border
        }

        // Edit Section
        MenuSection {
            title: "EDIT"
            icon: "✏️"

            ModernMenuItem {
                text: "Edit Properties"
                shortcut: "F2"
                icon: "⚙️"
                enabled: node !== null
                onClicked: nodeContextMenu.editProperties()
            }

            ModernMenuItem {
                text: "Inspect Node"
                shortcut: "F3"
                icon: "🔍"
                enabled: node !== null
                onClicked: nodeContextMenu.inspectNode()
            }
        }

        // Duplicate Section
        MenuSection {
            title: "DUPLICATE"
            icon: "📋"

            ModernMenuItem {
                text: "Duplicate"
                shortcut: "Ctrl+D"
                icon: "📄"
                enabled: node !== null
                onClicked: nodeContextMenu.duplicateNode()
            }

            ModernMenuItem {
                text: "Clone"
                shortcut: "Ctrl+Shift+D"
                icon: "🧬"
                enabled: node !== null
                onClicked: nodeContextMenu.cloneNode()
            }

            ModernMenuItem {
                text: "Create Template"
                icon: "📁"
                enabled: node !== null
                onClicked: nodeContextMenu.createTemplate()
            }
        }

        // Clipboard Section
        MenuSection {
            title: "CLIPBOARD"
            icon: "📋"

            ModernMenuItem {
                text: "Copy"
                shortcut: "Ctrl+C"
                icon: "📋"
                enabled: node !== null
                onClicked: nodeContextMenu.copyNode()
            }

            ModernMenuItem {
                text: "Cut"
                shortcut: "Ctrl+X"
                icon: "✂️"
                enabled: node !== null
                onClicked: nodeContextMenu.cutNode()
            }

            ModernMenuItem {
                text: "Export Node"
                icon: "📤"
                enabled: node !== null
                onClicked: nodeContextMenu.exportNode()
            }
        }

        // State Section
        MenuSection {
            title: "STATE"
            icon: "🔧"

            ModernMenuItem {
                text: (node && node.enabled === false) ? "Enable Node" : "Disable Node"
                shortcut: "Ctrl+E"
                icon: (node && node.enabled === false) ? "✅" : "⏸️"
                enabled: node !== null
                onClicked: {
                    if (node.enabled === false) {
                        nodeContextMenu.enableNode()
                    } else {
                        nodeContextMenu.disableNode()
                    }
                }
            }

            ModernMenuItem {
                text: "Reset Parameters"
                shortcut: "Ctrl+R"
                icon: "↶"
                enabled: node !== null
                onClicked: nodeContextMenu.resetParameters()
            }
        }

        // Danger Section
        MenuSection {
            title: "DANGER ZONE"
            icon: "⚠️"

            ModernMenuItem {
                text: "Delete Node"
                shortcut: "Delete"
                icon: "🗑️"
                accent: true
                enabled: node !== null
                onClicked: nodeContextMenu.deleteNode()
            }
        }
    }

    // کامپوننت‌های سفارشی
    component MenuSection: Column {
        property string title: ""
        property string icon: ""

        width: parent.width
        spacing: 0

        // Section Header
        Rectangle {
            width: parent.width
            height: 28
            color: Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)

            Row {
                anchors.left: parent.left
                anchors.leftMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                spacing: 8

                Text {
                    text: parent.parent.icon
                    font.pixelSize: 10
                    color: theme.primary
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: parent.parent.title
                    color: theme.primary
                    font.family: "Segoe UI"
                    font.pixelSize: 10
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

    component ModernMenuItem: Rectangle {
        property string text: ""
        property string shortcut: ""
        property string icon: ""
        property bool accent: false
        property bool enabled: true

        width: parent.width
        height: 36
        color: mouseArea.containsMouse ?
               (accent ? Qt.rgba(theme.error.r, theme.error.g, theme.error.b, 0.1) :
                         Qt.rgba(theme.primary.r, theme.primary.g, theme.primary.b, 0.1)) :
               "transparent"

        Row {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12

            // Icon
            Text {
                text: parent.parent.icon
                font.pixelSize: 12
                color: parent.parent.accent ? theme.error :
                       !parent.parent.enabled ? theme.textDisabled :
                       theme.textSecondary
                anchors.verticalCenter: parent.verticalCenter
                width: 16
            }

            // Text
            Text {
                text: parent.parent.text
                color: parent.parent.accent ? theme.error :
                       !parent.parent.enabled ? theme.textDisabled :
                       theme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 12
                anchors.verticalCenter: parent.verticalCenter
                elide: Text.ElideRight
            }

            // Spacer
            Item { width: 1; height: 1; Layout.fillWidth: true }

            // Shortcut
            Text {
                text: parent.parent.shortcut
                color: parent.parent.accent ? theme.error :
                       !parent.parent.enabled ? theme.textDisabled :
                       theme.textTertiary
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
            cursorShape: parent.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            enabled: parent.enabled
            onClicked: parent.clicked()
        }

        signal clicked()
    }

    // توابع کمکی
    function getNodeColor(category) {
        if (!category) return theme.primary

        var colors = {
            "Data Acquisition": "#4ECDC4",
            "Preprocessing": "#FFD166",
            "Feature Extraction": "#06D6A0",
            "Classification": "#EF476F",
            "BCI Paradigms": "#118AB2",
            "Visualization": "#7209B7",
            "Control": "#F15BB5",
            "Utilities": "#8A8AA8"
        }
        return colors[category] || theme.primary
    }

    function open(mouse) {
        if (node) {
            // موقعیت‌یابی هوشمند - اطمینان از نمایش در viewport
            var x = mouse ? mouse.x : 0
            var y = mouse ? mouse.y : 0

            // بررسی که منو خارج از صفحه نرود
            var maxX = nodeContextMenu.parent.width - nodeContextMenu.width - 10
            var maxY = nodeContextMenu.parent.height - nodeContextMenu.height - 10

            x = Math.max(10, Math.min(x, maxX))
            y = Math.max(10, Math.min(y, maxY))

            popup(x, y)
        }
    }

    function closeMenu() {
        close()
    }

    function updateNode(newNode) {
        node = newNode
    }

    function showForNode(targetNode, mouseX, mouseY) {
        node = targetNode
        open({x: mouseX, y: mouseY})
    }

    // سیگنال‌های اضافی
    signal resetParameters()

    // Animation on open
    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 150 }
        NumberAnimation { property: "scale"; from: 0.9; to: 1.0; duration: 150 }
    }

    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 100 }
    }

    // مدیریت رویدادهای کیبورد
    Shortcut {
        sequence: "F2"
        onActivated: {
            if (nodeContextMenu.visible && nodeContextMenu.node) {
                nodeContextMenu.editProperties()
            }
        }
    }

    Shortcut {
        sequence: "Delete"
        onActivated: {
            if (nodeContextMenu.visible && nodeContextMenu.node) {
                nodeContextMenu.deleteNode()
            }
        }
    }

    Shortcut {
        sequence: "Ctrl+D"
        onActivated: {
            if (nodeContextMenu.visible && nodeContextMenu.node) {
                nodeContextMenu.duplicateNode()
            }
        }
    }

    Component.onCompleted: {
        console.log("NodeContextMenu initialized")
    }

    onOpened: {
        console.log("NodeContextMenu opened for node:", node ? node.name : "null")
    }

    onClosed: {
        console.log("NodeContextMenu closed")
    }
}
