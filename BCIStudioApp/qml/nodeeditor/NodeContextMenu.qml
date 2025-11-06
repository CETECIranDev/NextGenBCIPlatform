import QtQuick 2.15
import QtQuick.Controls 2.15

Menu {
    id: nodeContextMenu
    
    property var node: null
    
    signal deleteNode()
    signal cloneNode()
    signal editProperties()
    signal editNode()
    signal copyNode()
    signal cutNode()
    signal disableNode()
    signal enableNode()

    MenuItem {
        text: "Edit Properties"
        enabled: node !== null
        onTriggered: nodeContextMenu.editProperties()
    }

    MenuItem {
        text: "Clone Node"
        enabled: node !== null
        onTriggered: nodeContextMenu.cloneNode()
    }

    MenuSeparator {}

    MenuItem {
        text: "Copy"
        enabled: node !== null
        onTriggered: nodeContextMenu.copyNode()
    }

    MenuItem {
        text: "Cut"
        enabled: node !== null
        onTriggered: nodeContextMenu.cutNode()
    }

    MenuSeparator {}

    MenuItem {
        text: (node && node.enabled === false) ? "Enable Node" : "Disable Node"
        enabled: node !== null
        onTriggered: {
            if (node.enabled === false) {
                nodeContextMenu.enableNode()
            } else {
                nodeContextMenu.disableNode()
            }
        }
    }

    MenuSeparator {}

    MenuItem {
        text: "Delete Node"
        enabled: node !== null
        onTriggered: nodeContextMenu.deleteNode()
    }

    function open(mouse) {
        if (node) {
            popup(mouse ? mouse.x : 0, mouse ? mouse.y : 0)
        }
    }
}
