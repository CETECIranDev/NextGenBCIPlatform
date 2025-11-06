// NodeToolbox.qml
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: nodeToolbox
    color: theme.backgroundSecondary
    border.color: theme.border
    border.width: 1

    // Properties
    property var nodeRegistry
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

    signal nodeDragStarted(string nodeType, var mouse)
    signal categorySelected(string category)

    // دسته‌بندی‌های نودهای BCI
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
                {type: "artifact_removal", name: "Artifact Removal", icon: "✨", description: "Remove eye blinks and artifacts"},
                {type: "rereferencing", name: "Re-referencing", icon: "🔄", description: "Change EEG reference"}
            ]
        },
        {
            name: "Feature Extraction",
            icon: "🎯",
            color: "#06D6A0",
            nodes: [
                {type: "psd_features", name: "PSD Features", icon: "📊", description: "Power Spectral Density features"},
                {type: "csp_features", name: "CSP Features", icon: "🧩", description: "Common Spatial Patterns"},
                {type: "wavelet_features", name: "Wavelet Features", icon: "🌊", description: "Wavelet transform features"},
                {type: "erp_features", name: "ERP Features", icon: "⚡", description: "Event-Related Potential features"}
            ]
        },
        {
            name: "Classification",
            icon: "🤖",
            color: "#EF476F",
            nodes: [
                {type: "lda_classifier", name: "LDA Classifier", icon: "📐", description: "Linear Discriminant Analysis"},
                {type: "svm_classifier", name: "SVM Classifier", icon: "⚡", description: "Support Vector Machine"},
                {type: "neural_network", name: "Neural Network", icon: "🕸️", description: "Deep learning classifier"},
                {type: "knn_classifier", name: "KNN Classifier", icon: "📏", description: "K-Nearest Neighbors"}
            ]
        },
        {
            name: "BCI Paradigms",
            icon: "🧠",
            color: "#118AB2",
            nodes: [
                {type: "p300_speller", name: "P300 Speller", icon: "🔤", description: "P300-based spelling interface"},
                {type: "ssvep_detector", name: "SSVEP Detector", icon: "📊", description: "Steady-State Visual Evoked Potential"},
                {type: "motor_imagery", name: "Motor Imagery", icon: "💪", description: "Motor imagery classification"},
                {type: "ern_detector", name: "ERN Detector", icon: "❌", description: "Error-Related Negativity detection"}
            ]
        },
        {
            name: "Visualization",
            icon: "📉",
            color: "#7209B7",
            nodes: [
                {type: "signal_plot", name: "Signal Plot", icon: "📈", description: "Real-time signal visualization"},
                {type: "spectrogram", name: "Spectrogram", icon: "🌈", description: "Time-frequency analysis"},
                {type: "topographic_map", name: "Topographic Map", icon: "🗺️", description: "Brain activity mapping"},
                {type: "erp_plot", name: "ERP Plot", icon: "⚡", description: "Event-Related Potential visualization"}
            ]
        }
    ]

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // هدر toolbox
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: theme.backgroundTertiary

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4

                Text {
                    text: "🧩 Node Library"
                    color: theme.textPrimary
                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 16
                    font.bold: true
                }

                Text {
                    text: "Drag nodes to canvas"
                    color: theme.textSecondary
                    font.family: "Segoe UI"
                    font.pixelSize: 11
                }
            }
        }

        // جستجو
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: theme.backgroundSecondary

            TextField {
                id: searchField
                anchors.fill: parent
                anchors.margins: 8
                placeholderText: "🔍 Search nodes..."
                font.family: "Segoe UI"
                font.pixelSize: 12
                background: Rectangle {
                    color: theme.backgroundPrimary
                    radius: 8
                    border.color: theme.border
                    border.width: 1
                }
            }
        }

        // لیست دسته‌بندی‌ها
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ColumnLayout {
                width: parent.width
                spacing: 0

                Repeater {
                    model: nodeToolbox.categories

                    delegate: CategorySection {
                        categoryName: modelData.name
                        categoryIcon: modelData.icon
                        categoryColor: modelData.color
                        nodes: modelData.nodes
                        Layout.fillWidth: true
                        onNodeDragStarted: (nodeType, mouse) => {
                            nodeToolbox.nodeDragStarted(nodeType, mouse)
                        }
                        onCategorySelected: (category) => {
                            nodeToolbox.categorySelected(category)
                        }
                    }
                }
            }
        }
    }

    // کامپوننت بخش دسته‌بندی
    component CategorySection: ColumnLayout {
        property string categoryName: ""
        property string categoryIcon: ""
        property color categoryColor: "gray"
        property var nodes: []
        property var theme: nodeToolbox.theme

        signal nodeDragStarted(string nodeType, var mouse)
        signal categorySelected(string category)

        Layout.fillWidth: true
        spacing: 0

        // هدر دسته‌بندی
        Rectangle {
            id: categoryHeader
            Layout.fillWidth: true
            height: 40
            color: Qt.lighter(categoryColor, 1.8)

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 8

                Rectangle {
                    width: 24
                    height: 24
                    radius: 6
                    color: categoryColor
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        text: categoryIcon
                        font.pixelSize: 12
                        color: "white"
                        anchors.centerIn: parent
                    }
                }

                Text {
                    text: categoryName
                    color: theme.textPrimary
                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 13
                    font.bold: true
                    Layout.fillWidth: true
                }

                Text {
                    text: "▼"
                    color: theme.textTertiary
                    font.pixelSize: 10
                    Layout.alignment: Qt.AlignVCenter
                    rotation: categoryContent.visible ? 0 : -90
                    Behavior on rotation { NumberAnimation { duration: 200 } }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    categoryContent.visible = !categoryContent.visible
                    categorySelected(categoryName)
                }
            }
        }

        // محتوای دسته‌بندی
        ColumnLayout {
            id: categoryContent
            Layout.fillWidth: true
            visible: true
            spacing: 1

            Repeater {
                model: nodes

                delegate: NodeToolboxItem {
                    nodeType: modelData.type
                    nodeName: modelData.name
                    nodeIcon: modelData.icon
                    nodeDescription: modelData.description
                    nodeColor: categoryColor
                    Layout.fillWidth: true
                    onDragStarted: (mouse) => {
                        nodeDragStarted(nodeType, mouse)
                    }
                }
            }
        }
    }

    // کامپوننت آیتم نود در toolbox
    component NodeToolboxItem: Rectangle {
        property string nodeType: ""
        property string nodeName: ""
        property string nodeIcon: ""
        property string nodeDescription: ""
        property color nodeColor: "gray"
        property var theme: nodeToolbox.theme

        signal dragStarted(var mouse)

        width: parent.width
        height: 60
        color: mouseArea.containsMouse ? Qt.rgba(nodeColor.r, nodeColor.g, nodeColor.b, 0.1) : "transparent"

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 10

            // آیکون نود
            Rectangle {
                width: 36
                height: 36
                radius: 8
                color: nodeColor
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: nodeIcon
                    font.pixelSize: 16
                    color: "white"
                    anchors.centerIn: parent
                }
            }

            // اطلاعات نود
            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                Text {
                    text: nodeName
                    color: theme.textPrimary
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                    font.bold: true
                    elide: Text.ElideRight
                }

                Text {
                    text: nodeDescription
                    color: theme.textSecondary
                    font.family: "Segoe UI"
                    font.pixelSize: 10
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            drag.target: dragProxy
            drag.threshold: 1

            onPressed: (mouse) => {
                // ایجاد proxy برای درگ
                var proxy = dragProxyComponent.createObject(nodeToolbox, {
                    nodeType: parent.nodeType,
                    nodeName: parent.nodeName,
                    nodeIcon: parent.nodeIcon,
                    nodeColor: parent.nodeColor
                })
                proxy.startDrag(mouse)
                parent.dragStarted(mouse)
            }
        }

        // کامپوننت proxy برای درگ
        Component {
            id: dragProxyComponent

            Rectangle {
                id: dragProxy
                property string nodeType: ""
                property string nodeName: ""
                property string nodeIcon: ""
                property color nodeColor: "gray"
                width: 120
                height: 40
                radius: 8
                color: nodeColor
                opacity: 0.9
                z: 1000

                Row {
                    anchors.centerIn: parent
                    spacing: 6

                    Text {
                        text: nodeIcon
                        font.pixelSize: 14
                        color: "white"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: nodeName
                        color: "white"
                        font.family: "Segoe UI"
                        font.pixelSize: 11
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                function startDrag(mouse) {
                    // موقعیت اولیه
                    var globalPos = nodeToolbox.mapToGlobal(mouse.x, mouse.y)
                    var canvasPos = nodeEditorView.mapFromGlobal(globalPos)
                    x = canvasPos.x - width/2
                    y = canvasPos.y - height/2
                }

                Drag.active: true
                Drag.hotSpot: Qt.point(width/2, height/2)
                Drag.keys: ["node/new"]
                Drag.mimeData: {
                    "node/type": nodeType,
                    "node/name": nodeName
                }
            }
        }
    }

    // توابع عمومی
    function filterNodes(searchText) {
        // فیلتر کردن نودها بر اساس متن جستجو
        if (!searchText) {
            // بازگشت به حالت عادی
            return
        }

        // پیاده‌سازی منطق فیلتر کردن
        console.log("Filtering nodes with:", searchText)
    }

    function expandAllCategories() {
        // باز کردن تمام دسته‌بندی‌ها
        for (var i = 0; i < categories.length; i++) {
            // منطق باز کردن دسته‌بندی‌ها
        }
    }

    function collapseAllCategories() {
        // بستن تمام دسته‌بندی‌ها
        for (var i = 0; i < categories.length; i++) {
            // منطق بستن دسته‌بندی‌ها
        }
    }

    function getNodeCount() {
        var count = 0
        for (var i = 0; i < categories.length; i++) {
            count += categories[i].nodes.length
        }
        return count
    }

    Component.onCompleted: {
        console.log("NodeToolbox initialized with", getNodeCount(), "nodes across", categories.length, "categories")
    }
}
