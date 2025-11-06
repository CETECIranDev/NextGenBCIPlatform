import QtQuick
import QtQuick.Controls

import "../../components"

Item {
    id: canvasRoot
    clip: true
    focus: true

    // =========================================================================
    // --- Signals & Properties ---
    // =========================================================================

    signal nodeSelected(var nodeProperties)

    property list<variant> nodeData: [
        { id: "n1", name: "EEG Source", color: "#4E79A7", icon:"cpu", x: 200, y: 300, inputs: [{"name": "Device"}], outputs: [{"name": "Signal"}], params: [{name: "Device", type: "enum", value: "Emotiv EPOC+", options: ["Emotiv EPOC+", "OpenBCI Cyton"]}] },
        { id: "n2", name: "Bandpass Filter", color: "#59A14F", icon:"filter", x: 550, y: 250, inputs: [{"name": "In"}], outputs: [{"name": "Out"}], params: [{ "name": "Lower Cutoff (Hz)", "type": "double", "value": 1.0 }, { "name": "Higher Cutoff (Hz)", "type": "double", "value": 40.0 }] },
        { id: "n3", name: "Epoching", color: "#EDC948", icon:"scissors", x: 900, y: 350, inputs: [{"name": "In"}], outputs: [{"name": "Out"}], params: [{name: "Duration (ms)", type: "int", value: 800}] }
    ]
    property list<variant> connectionData: [
        { from: "n1", fromPort: 0, to: "n2", toPort: 0 },
        { from: "n2", fromPort: 0, to: "n3", toPort: 0 }
    ]

    property real currentScale: 1.0
    property bool isConnecting: false
    property point connectionStartPoint: Qt.point(0, 0)
    property point connectionEndPoint: Qt.point(0, 0)
    property var startNodeRef: null
    property int startPortIndex: -1

    property string currentAction: "none"
    property var activeItem: null
    property point lastMousePos

    // =========================================================================
    // --- Event-based Update Logic ---
    // =========================================================================

    onNodeDataChanged: updateAllConnections()
    onConnectionDataChanged: updateAllConnections()
    Component.onCompleted: {
        centerOn(700, 300);
        updateAllConnections();
    }

    // =========================================================================
    // --- Main UI Components ---
    // =========================================================================

    Flickable {
        id: flickable
        anchors.fill: parent
        contentWidth: 4000; contentHeight: 3000

        DropArea {
            anchors.fill: parent
            onDropped: (drop) => {
                if (drop.drag.payload) {
                    const scenePos = mapToItem(scene, drop.x, drop.y);
                    canvasRoot.addNode(drop.drag.payload, scenePos);
                    drop.acceptProposedAction();
                }
            }
        }

        Rectangle {
            width: flickable.contentWidth; height: flickable.contentHeight
            color: themeManager.backgroundMedium
        }

        Item {
            id: scene
            width: flickable.contentWidth; height: flickable.contentHeight
            scale: canvasRoot.currentScale

            Item {
                id: connectionsLayer
                z: 0
                Repeater {
                    id: connectionRepeater
                    model: canvasRoot.connectionData
                    delegate: Connection {
                        property var startNode: scene.findNodeById(modelData.from)
                        property var endNode: scene.findNodeById(modelData.to)
                        visible: startNode && endNode
                        startPoint: { if (startNode) { let pos = startNode.getOutputPortPosition(modelData.fromPort); return startNode.mapToItem(scene, pos.x, pos.y); } return Qt.point(0,0); }
                        endPoint: { if (endNode) { let pos = endNode.getInputPortPosition(modelData.toPort); return endNode.mapToItem(scene, pos.x, pos.y); } return Qt.point(0,0); }
                    }
                }
            }

            Item {
                id: nodesLayer
                z: 1
                Repeater {
                    id: nodeRepeater
                    model: canvasRoot.nodeData
                    delegate: Node {
                        id: nodeDelegate
                        x: modelData.x; y: modelData.y;
                        nodeName: modelData.name; nodeColor: modelData.color; nodeIcon: modelData.icon;
                        inputs: modelData.inputs; outputs: modelData.outputs;

                        onXChanged: canvasRoot.updateConnectionsForNode(modelData.id)
                        onYChanged: canvasRoot.updateConnectionsForNode(modelData.id)
                    }
                }
            }

            function findNodeById(nodeId) {
                let repeater = nodesLayer.children[0];
                if (!repeater) return null;
                for (var i = 0; i < repeater.count; i++) {
                    let nodeItem = repeater.itemAt(i);
                    if (nodeItem && nodeItem.modelData.id === nodeId) {
                        return nodeItem;
                    }
                }
                return null;
            }
        }
    }

    Connection {
        visible: canvasRoot.isConnecting
        startPoint: scene.mapToItem(canvasRoot, connectionStartPoint.x, connectionStartPoint.y)
        endPoint: connectionEndPoint
        connectionColor: themeManager.primaryHover
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onPressed: (mouse) => {
            lastMousePos = Qt.point(mouse.x, mouse.y);
            let scenePos = scene.mapFromItem(canvasRoot, mouse.x, mouse.y);

            if (mouse.button === Qt.RightButton || mouse.button === Qt.MiddleButton) {
                currentAction = "panning";
                cursorShape = Qt.ClosedHandCursor;
                return;
            }

            if (mouse.button === Qt.LeftButton) {
                let hitResult = canvasRoot.findItemAt(scenePos);
                if (hitResult) {
                    activeItem = hitResult;
                    if (hitResult.type === 'port' && hitResult.portType === 'output') {
                        currentAction = "connecting";
                        isConnecting = true;
                        startNodeRef = hitResult.node.modelData;
                        startPortIndex = hitResult.portIndex;
                        let portPos = hitResult.node.getOutputPortPosition(hitResult.portIndex);
                        connectionStartPoint = hitResult.node.mapToItem(scene, portPos.x, portPos.y);
                        connectionEndPoint = connectionStartPoint;
                    } else if (hitResult.type === 'node') {
                        currentAction = "movingNode";
                        hitResult.node.isSelected = true;
                        canvasRoot.deselectAllExcept(hitResult.node.modelData.id);
                        canvasRoot.nodeSelected(hitResult.node.modelData);
                    }
                } else {
                    currentAction = "panning";
                    canvasRoot.deselectAllExcept(null);
                    canvasRoot.nodeSelected(null);
                }
            }
        }

        onPositionChanged: (mouse) => {
            const delta = Qt.point(mouse.x - lastMousePos.x, mouse.y - lastMousePos.y);
            lastMousePos = Qt.point(mouse.x, mouse.y);

            if (currentAction === "panning") {
                flickable.contentX -= delta.x;
                flickable.contentY -= delta.y;
            } else if (currentAction === "movingNode" && activeItem) {
                activeItem.node.x += delta.x / currentScale;
                activeItem.node.y += delta.y / currentScale;
            } else if (currentAction === "connecting") {
                connectionEndPoint = scene.mapFromItem(canvasRoot, mouse.x, mouse.y);
            }
        }

        onReleased: (mouse) => {
            if (currentAction === "connecting") {
                let scenePos = scene.mapFromItem(canvasRoot, mouse.x, mouse.y);
                let hitResult = canvasRoot.findItemAt(scenePos);
                if (hitResult && hitResult.type === 'port' && hitResult.portType === 'input') {
                    canvasRoot.addConnection(startNodeRef, startPortIndex, hitResult.node.modelData, hitResult.portIndex);
                }
                isConnecting = false;
            }
            currentAction = "none";
            activeItem = null;
            cursorShape = Qt.ArrowCursor;
        }

        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                canvasRoot.currentScale = Math.min(2.0, canvasRoot.currentScale * 1.1);
            } else {
                canvasRoot.currentScale = Math.max(0.2, canvasRoot.currentScale * 0.9);
            }
        }
    }

    Row {
        anchors.bottom: parent.bottom; anchors.right: parent.right; anchors.margins: 10; spacing: 5; z: 1
        Button { text: "+"; onClicked: canvasRoot.currentScale = Math.min(2.0, canvasRoot.currentScale * 1.2) }
        Button { text: "-"; onClicked: canvasRoot.currentScale = Math.max(0.2, canvasRoot.currentScale * 0.8) }
        Button { text: "Reset View"; onClicked: { canvasRoot.currentScale = 1.0; canvasRoot.centerOn(700, 300); } }
    }

    // =========================================================================
    // --- Public & Private Functions ---
    // =========================================================================

    property var centerOn: (x, y) => {
        flickable.contentX = (x * currentScale) - (flickable.width / 2);
        flickable.contentY = (y * currentScale) - (flickable.height / 2);
    }

    property var deselectAllExcept: (nodeIdToKeep) => {
        let repeater = nodesLayer.children[0];
        if (!repeater) return;
        for (var i = 0; i < repeater.count; i++) {
            let item = repeater.itemAt(i);
            if (item && item.modelData.id !== nodeIdToKeep) {
                item.isSelected = false;
            }
        }
    }

    property var addNode: (payload, position) => {
        var newNode = {
            id: "node_" + Date.now(),
            name: payload.name, color: payload.color, icon: payload.icon,
            x: position.x - 100, y: position.y - 60,
            inputs: payload.inputs, outputs: payload.outputs, params: payload.params
        };
        nodeData.push(newNode);
    }

    property var addConnection: (startNode, startPort, endNode, endPort) => {
        if (!startNode || !endNode || startNode.id === endNode.id) return;
        var newConnection = { from: startNode.id, fromPort: startPort, to: endNode.id, toPort: endPort };
        connectionData.push(newConnection);
    }

    function updateAllConnections() {
        if (!connectionRepeater || !scene) return;
        for (var i = 0; i < connectionRepeater.count; i++) {
            let connectionItem = connectionRepeater.itemAt(i);
            if (!connectionItem) continue;
            let modelData = connectionRepeater.model[i];

            let startNode = scene.findNodeById(modelData.from);
            let endNode = scene.findNodeById(modelData.to);

            if (startNode && endNode) {
                let startPos = startNode.getOutputPortPosition(modelData.fromPort);
                let endPos = endNode.getInputPortPosition(modelData.toPort);

                connectionItem.startPoint = startNode.mapToItem(scene, startPos.x, startPos.y);
                connectionItem.endPoint = endNode.mapToItem(scene, endPos.x, endPos.y);
                connectionItem.visible = true;
            } else {
                connectionItem.visible = false;
            }
        }
    }

    function updateConnectionsForNode(nodeId) {
        if (!connectionRepeater || !scene) return;
        for (var i = 0; i < connectionRepeater.count; i++) {
            let modelData = connectionRepeater.model[i];
            if (modelData.from === nodeId || modelData.to === nodeId) {
                let connectionItem = connectionRepeater.itemAt(i);
                if (!connectionItem) continue;
                let startNode = scene.findNodeById(modelData.from);
                let endNode = scene.findNodeById(modelData.to);

                if (startNode && endNode) {
                    let startPos = startNode.getOutputPortPosition(modelData.fromPort);
                    let endPos = endNode.getInputPortPosition(modelData.toPort);
                    connectionItem.startPoint = startNode.mapToItem(scene, startPos.x, startPos.y);
                    connectionItem.endPoint = endNode.mapToItem(scene, endPos.x, endPos.y);
                }
            }
        }
    }

    property var findItemAt: (scenePoint) => {
        let repeater = nodesLayer.children[0];
        if (!repeater) return null;
        for (var i = repeater.count - 1; i >= 0; i--) {
            let node = repeater.itemAt(i);
            if (node.x <= scenePoint.x && scenePoint.x <= node.x + node.width &&
                node.y <= scenePoint.y && scenePoint.y <= node.y + node.height)
            {
                let localPoint = node.mapFromItem(scene, scenePoint.x, scenePoint.y);
                let portHit = node.portAt(localPoint);
                if (portHit) {
                    return { type: 'port', portType: portHit.type, portIndex: portHit.index, node: node };
                }
                return { type: 'node', node: node };
            }
        }
        return null;
    }
}
