import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects

Rectangle {
    id: nodeToolbox
    color: theme.backgroundSecondary
    border.color: theme.border
    border.width: 1
    radius: 12

    property var theme
    signal nodeDragStarted(string nodeType, var mouse)
    signal categorySelected(string category)

    property var categories: [
        {
            name: "Data Acquisition",
            icon: "📊",
            color: "#4ECDC4",
            nodes: [
                {type: "eeg_input", name: "EEG Input", icon: "🧠", description: "Real-time EEG data acquisition"},
                {type: "file_reader", name: "File Reader", icon: "📁", description: "Read EEG data from files"},
                {type: "signal_generator", name: "Signal Generator", icon: "📡", description: "Generate synthetic EEG signals"}
            ]
        },
        {
            name: "Preprocessing",
            icon: "🔧",
            color: "#FFD166",
            nodes: [
                {type: "bandpass_filter", name: "Bandpass Filter", icon: "📈", description: "Filter specific frequency bands"},
                {type: "notch_filter", name: "Notch Filter", icon: "🔇", description: "Remove power line noise"},
                {type: "artifact_removal", name: "Artifact Removal", icon: "✨", description: "Remove eye blinks and artifacts"}
            ]
        }
    ]

    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 2
        verticalOffset: 2
        radius: 8
        samples: 17
        color: "#20000000"
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            height: 70
            color: theme.backgroundTertiary

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 6

                RowLayout {
                    spacing: 12
                    Layout.fillWidth: true

                    Rectangle {
                        width: 40
                        height: 40
                        radius: 8
                        color: theme.primary
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            text: "🧩"
                            font.pixelSize: 20
                            color: "white"
                            anchors.centerIn: parent
                        }
                    }

                    ColumnLayout {
                        spacing: 2
                        Layout.fillWidth: true

                        Text {
                            text: "Node Library"
                            color: theme.textPrimary
                            font.family: "Segoe UI Semibold"
                            font.pixelSize: 16
                            font.weight: Font.DemiBold
                        }

                        Text {
                            text: "Drag nodes to canvas"
                            color: theme.textSecondary
                            font.family: "Segoe UI"
                            font.pixelSize: 11
                        }
                    }
                }
            }
        }

        // Search Box
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: theme.backgroundSecondary

            TextField {
                id: searchBox
                anchors.fill: parent
                anchors.margins: 8
                placeholderText: "🔍 Search nodes..."
                font.family: "Segoe UI"
                font.pixelSize: 12
                background: Rectangle {
                    color: theme.backgroundPrimary
                    radius: 6
                    border.color: theme.border
                    border.width: 1
                }
            }
        }

        // Categories and Nodes
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                id: contentColumn
                width: parent.width
                spacing: 0

                Repeater {
                    id: categoryRepeater
                    model: categories

                    delegate: Rectangle {
                        id: categoryDelegate
                        Layout.fillWidth: true
                        implicitHeight: categoryColumn.height
                        color: "transparent"

                        property var categoryData: modelData

                        ColumnLayout {
                            id: categoryColumn
                            width: parent.width
                            spacing: 0

                            // Category Header
                            Rectangle {
                                id: categoryHeader
                                Layout.fillWidth: true
                                height: 45
                                color: Qt.lighter(modelData.color, 1.8)

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.leftMargin: 16
                                    anchors.rightMargin: 16
                                    spacing: 10

                                    Rectangle {
                                        width: 28
                                        height: 28
                                        radius: 6
                                        color: modelData.color
                                        Layout.alignment: Qt.AlignVCenter

                                        Text {
                                            text: modelData.icon
                                            font.pixelSize: 14
                                            color: "white"
                                            anchors.centerIn: parent
                                        }
                                    }

                                    Text {
                                        text: modelData.name
                                        color: theme.textPrimary
                                        font.family: "Segoe UI Semibold"
                                        font.pixelSize: 14
                                        font.bold: true
                                        Layout.fillWidth: true
                                    }

                                    Text {
                                        text: "(" + modelData.nodes.length + ")"
                                        color: theme.textSecondary
                                        font.family: "Segoe UI"
                                        font.pixelSize: 11
                                        Layout.alignment: Qt.AlignVCenter
                                    }
                                }
                            }

                            // Nodes List
                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 1

                                Repeater {
                                    model: modelData.nodes

                                    delegate: Rectangle {
                                        id: nodeItem
                                        Layout.fillWidth: true
                                        height: 70
                                        color: nodeMouseArea.containsMouse ?
                                               Qt.rgba(modelData.color.r, modelData.color.g, modelData.color.b, 0.1) :
                                               "transparent"

                                        property string nodeType: modelData.type
                                        property string nodeName: modelData.name
                                        property string nodeIcon: modelData.icon
                                        property string nodeDescription: modelData.description
                                        property color nodeColor: modelData.color

                                        // Drag item
                                        Drag.active: nodeMouseArea.drag.active
                                        Drag.hotSpot: Qt.point(width / 2, height / 2)
                                        Drag.keys: ['node/' + nodeType]

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: 12
                                            spacing: 12

                                            // Node Icon with Drag Handle
                                            Rectangle {
                                                width: 44
                                                height: 44
                                                radius: 8
                                                color: nodeColor
                                                Layout.alignment: Qt.AlignVCenter

                                                Text {
                                                    text: nodeIcon
                                                    font.pixelSize: 18
                                                    color: "white"
                                                    anchors.centerIn: parent
                                                }

                                                // Drag Handle
                                                Rectangle {
                                                    width: 16
                                                    height: 16
                                                    radius: 8
                                                    color: "white"
                                                    opacity: 0.9
                                                    anchors {
                                                        top: parent.top
                                                        right: parent.right
                                                        margins: -4
                                                    }

                                                    Text {
                                                        text: "⤴️"
                                                        font.pixelSize: 8
                                                        color: nodeColor
                                                        anchors.centerIn: parent
                                                    }
                                                }
                                            }

                                            // Node Info
                                            ColumnLayout {
                                                spacing: 4
                                                Layout.fillWidth: true

                                                Text {
                                                    text: nodeName
                                                    color: theme.textPrimary
                                                    font.family: "Segoe UI"
                                                    font.pixelSize: 13
                                                    font.bold: true
                                                    elide: Text.ElideRight
                                                    Layout.fillWidth: true
                                                }

                                                Text {
                                                    text: nodeDescription
                                                    color: theme.textSecondary
                                                    font.family: "Segoe UI"
                                                    font.pixelSize: 10
                                                    wrapMode: Text.WordWrap
                                                    maximumLineCount: 2
                                                    elide: Text.ElideRight
                                                    lineHeight: 1.2
                                                    Layout.fillWidth: true
                                                }
                                            }

                                            // Drag Indicator
                                            Text {
                                                text: "≡"
                                                color: theme.textTertiary
                                                font.pixelSize: 16
                                                rotation: 90
                                                Layout.alignment: Qt.AlignVCenter
                                                Layout.rightMargin: 8
                                            }
                                        }

                                        // Mouse Area for Drag - کاملاً اصلاح شده
                                        MouseArea {
                                            id: nodeMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            drag.target: nodeItem
                                            drag.axis: Drag.XAndYAxis

                                            property bool dragging: false
                                            property point startPos

                                            onPressed: (mouse) => {
                                                console.log("🖱️ Node pressed for drag:", nodeType);
                                                startPos = Qt.point(mouse.x, mouse.y);
                                                dragging = false;
                                                forceActiveFocus();
                                            }

                                            onPositionChanged: (mouse) => {
                                                if (pressed && !dragging &&
                                                    (Math.abs(mouse.x - startPos.x) > 5 ||
                                                     Math.abs(mouse.y - startPos.y) > 5)) {
                                                    dragging = true;
                                                    console.log("🚀 Starting drag for:", nodeType);

                                                    // شروع درگ رسمی
                                                    nodeItem.Drag.active = true;
                                                    nodeItem.Drag.hotSpot = Qt.point(mouse.x, mouse.y);

                                                    // سیگنال به EditorView
                                                    var globalPos = mapToItem(null, mouse.x, mouse.y);
                                                    nodeToolbox.nodeDragStarted(nodeType, {
                                                        x: globalPos.x,
                                                        y: globalPos.y,
                                                        source: "toolbox"
                                                    });
                                                }
                                            }

                                            onReleased: (mouse) => {
                                                console.log("🖱️ Mouse released");
                                                if (dragging) {
                                                    nodeItem.Drag.active = false;
                                                    dragging = false;
                                                    console.log("🧹 Drag ended");
                                                }
                                            }

                                            onClicked: {
                                                if (!dragging) {
                                                    console.log("👆 Node clicked:", nodeType);
                                                }
                                            }
                                        }

                                        // Bottom border
                                        Rectangle {
                                            anchors.bottom: parent.bottom
                                            width: parent.width
                                            height: 1
                                            color: theme.border
                                            opacity: 0.3
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        console.log("🧩 NodeToolbox initialized with drag support");
    }
}
