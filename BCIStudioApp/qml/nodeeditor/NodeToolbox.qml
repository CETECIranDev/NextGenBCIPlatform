import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects



Rectangle {
    id: nodeToolbox
    color: "transparent"

    property var categories: []
    property string currentCategory: "All"
    property var filteredNodes: []
    property string searchText: ""
    property bool isCollapsed: false

    signal nodeDragStarted(string nodeType, var mouse)
    signal categorySelected(string category)

    // دسته‌بندی‌های اصلی BCI با تعداد واقعی
    Component.onCompleted: {
        console.log("📦 NodeToolbox initialized")

        categories = [
            {
                name: "All",
                icon: "🌐",
                description: "All available nodes",
                color: appTheme.primary,
                count: 28
            },
            {
                name: "Data Acquisition",
                icon: "📡",
                description: "EEG/EMG/ECG data acquisition",
                color: "#4361EE",
                count: 6
            },
            {
                name: "Preprocessing",
                icon: "🔧",
                description: "Signal preprocessing & filtering",
                color: "#4895EF",
                count: 8
            },
            {
                name: "Feature Extraction",
                icon: "📊",
                description: "Feature extraction algorithms",
                color: "#4CC9F0",
                count: 7
            },
            {
                name: "Classification",
                icon: "🤖",
                description: "Machine learning classifiers",
                color: "#7209B7",
                count: 5
            },
            {
                name: "BCI Paradigms",
                icon: "🧠",
                description: "BCI paradigm implementations",
                color: "#3A0CA3",
                count: 4
            },
            {
                name: "Visualization",
                icon: "📈",
                description: "Data visualization tools",
                color: "#F72585",
                count: 5
            },
            {
                name: "Control",
                icon: "🎮",
                description: "Control & output interfaces",
                color: "#EF476F",
                count: 3
            },
            {
                name: "Utilities",
                icon: "⚙️",
                description: "Utility & helper nodes",
                color: "#6C757D",
                count: 4
            }
        ]

        Qt.callLater(function() {
            loadNodesFromRegistry()
        })
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header فلت
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 70
            color: appTheme.backgroundCard
            border.color: appTheme.border
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    Rectangle {
                        width: 40
                        height: 40
                        radius: 8
                        color: appTheme.primary
                        Layout.alignment: Qt.AlignVCenter

                        Text {
                            text: "🧩"
                            font.pixelSize: 18
                            color: "white"
                            anchors.centerIn: parent
                        }
                    }

                    ColumnLayout {
                        spacing: 2
                        Layout.fillWidth: true

                        Text {
                            text: "Node Library"
                            color: appTheme.textPrimary
                            font.family: "Segoe UI"
                            font.pixelSize: 16
                            font.bold: true
                        }

                        Text {
                            text: (filteredNodes.length) + " nodes available"
                            color: appTheme.textSecondary
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                        }
                    }
                }

                // Search Box فلت
                Rectangle {
                    Layout.fillWidth: true
                    height: 36
                    radius: 6
                    color: appTheme.backgroundTertiary
                    border.color: appTheme.border
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 8

                        Text {
                            text: "🔍"
                            color: appTheme.textTertiary
                            font.pixelSize: 14
                            Layout.alignment: Qt.AlignVCenter
                        }

                        TextField {
                            id: searchField
                            Layout.fillWidth: true
                            placeholderText: "Search nodes..."
                            font.family: "Segoe UI"
                            font.pixelSize: 12
                            color: appTheme.textPrimary
                            background: Rectangle {
                                color: "transparent"
                            }

                            onTextChanged: {
                                nodeToolbox.searchText = text
                                filterNodes(text)
                            }
                        }
                    }
                }
            }
        }

        // Categories Scroll فلت
        ScrollView {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            Layout.topMargin: 8
            clip: true

            Row {
                width: parent.width - 16
                spacing: 8
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 8

                Repeater {
                    model: nodeToolbox.categories

                    delegate: Rectangle {
                        width: 110
                        height: 60
                        radius: 8
                        color: nodeToolbox.currentCategory === modelData.name ? modelData.color : appTheme.backgroundCard
                        border.color: nodeToolbox.currentCategory === modelData.name ? modelData.color : appTheme.border
                        border.width: 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 4

                            Text {
                                text: modelData.icon
                                font.pixelSize: 16
                                color: nodeToolbox.currentCategory === modelData.name ? "white" : modelData.color
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: modelData.name
                                color: nodeToolbox.currentCategory === modelData.name ? "white" : appTheme.textPrimary
                                font.family: "Segoe UI"
                                font.pixelSize: 9
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: modelData.count
                                color: nodeToolbox.currentCategory === modelData.name ? "white" : appTheme.textSecondary
                                font.family: "Segoe UI"
                                font.pixelSize: 9
                                font.bold: true
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                nodeToolbox.currentCategory = modelData.name
                                nodeToolbox.categorySelected(modelData.name)
                                filterNodes(nodeToolbox.searchText)
                            }
                        }
                    }
                }
            }
        }

        // Nodes Grid فلت
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.topMargin: 8
            clip: true

            GridLayout {
                width: parent.width - 16
                columns: 2
                columnSpacing: 8
                rowSpacing: 8
                anchors.horizontalCenter: parent.horizontalCenter

                Repeater {
                    model: nodeToolbox.filteredNodes

                    delegate: Rectangle {
                        id: nodeCard
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                        radius: 8
                        color: appTheme.backgroundCard
                        border.color: appTheme.border
                        border.width: 1

                        // افکت ساده فلت
                        layer.enabled: true
                        layer.effect: DropShadow {
                            transparentBorder: true
                            horizontalOffset: 0
                            verticalOffset: 1
                            radius: 3
                            samples: 8
                            color: "#10000000"
                        }

                        Row {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 10

                            // Icon
                            Rectangle {
                                width: 40
                                height: 40
                                radius: 6
                                color: modelData.color || getCategoryColor(modelData.category)
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    text: modelData.icon
                                    font.pixelSize: 16
                                    color: "white"
                                    anchors.centerIn: parent
                                }
                            }

                            // Content
                            Column {
                                width: parent.width - 60
                                spacing: 2
                                anchors.verticalCenter: parent.verticalCenter

                                Text {
                                    text: modelData.name
                                    color: appTheme.textPrimary
                                    font.family: "Segoe UI"
                                    font.pixelSize: 12
                                    font.bold: true
                                    elide: Text.ElideRight
                                    width: parent.width
                                }

                                Text {
                                    text: modelData.description
                                    color: appTheme.textSecondary
                                    font.family: "Segoe UI"
                                    font.pixelSize: 10
                                    elide: Text.ElideRight
                                    width: parent.width
                                }

                                Text {
                                    text: modelData.category
                                    color: modelData.color || getCategoryColor(modelData.category)
                                    font.family: "Segoe UI"
                                    font.pixelSize: 9
                                    font.bold: true
                                }
                            }
                        }

                        // درگ اند دراپ واقعی
                        MouseArea {
                            id: dragArea
                            anchors.fill: parent
                            cursorShape: Qt.OpenHandCursor
                            drag.target: dragItem

                            onPressed: {
                                // ایجاد drag item
                                dragItem.parent = nodeToolbox.parent
                                dragItem.x = mouseX + nodeCard.x
                                dragItem.y = mouseY + nodeCard.y
                                dragItem.opacity = 0.9
                                dragItem.nodeData = modelData

                                console.log("🔄 Starting drag for:", modelData.name)
                                nodeToolbox.nodeDragStarted(modelData.type, mouse)
                            }

                            onPositionChanged: {
                                if (drag.active) {
                                    dragItem.x = dragArea.mouseX + nodeCard.x - dragItem.width/2
                                    dragItem.y = dragArea.mouseY + nodeCard.y - dragItem.height/2
                                }
                            }

                            onReleased: {
                                dragItem.opacity = 0
                                dragItem.parent = null
                                console.log("✅ Drag finished for:", modelData.name)
                            }
                        }
                    }
                }
            }
        }
    }

    // Drag Item برای پیش‌نمایش
    Rectangle {
        id: dragItem
        width: 120
        height: 60
        radius: 8
        color: appTheme.backgroundCard
        border.color: appTheme.primary
        border.width: 2
        opacity: 0
        visible: opacity > 0

        property var nodeData: null

        Row {
            anchors.centerIn: parent
            spacing: 6

            Rectangle {
                width: 24
                height: 24
                radius: 4
                color: dragItem.nodeData ? (dragItem.nodeData.color || getCategoryColor(dragItem.nodeData.category)) : appTheme.primary
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    text: dragItem.nodeData ? dragItem.nodeData.icon : "🧩"
                    font.pixelSize: 12
                    color: "white"
                    anchors.centerIn: parent
                }
            }

            Text {
                text: dragItem.nodeData ? dragItem.nodeData.name : "Node"
                color: appTheme.textPrimary
                font.family: "Segoe UI"
                font.pixelSize: 11
                font.bold: true
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Behavior on opacity {
            NumberAnimation { duration: 150 }
        }
    }

    // Helper functions
    function filterNodes(searchText) {
        var allNodes = getBCINodes()
        filteredNodes = allNodes.filter(function(node) {
            var matchesSearch = !searchText ||
                node.name.toLowerCase().includes(searchText.toLowerCase()) ||
                (node.description && node.description.toLowerCase().includes(searchText.toLowerCase())) ||
                node.category.toLowerCase().includes(searchText.toLowerCase())

            var matchesCategory = currentCategory === "All" || node.category === currentCategory

            return matchesSearch && matchesCategory
        })
    }

    function setCurrentCategory(category) {
        currentCategory = category
        filterNodes(searchText)
    }

    function loadNodesFromRegistry() {
        filterNodes("")
    }

    function getCategoryColor(categoryName) {
        var category = categories.find(function(cat) {
            return cat.name === categoryName
        })
        return category ? category.color : appTheme.primary
    }

    // کتابخانه کامل نودهای BCI واقعی
    function getBCINodes() {
        return [
            // Data Acquisition
            {
                type: "eeg_input",
                name: "EEG Input",
                icon: "🧠",
                description: "Acquire EEG signals from device",
                category: "Data Acquisition",
                color: "#4361EE"
            },
            {
                type: "emg_input",
                name: "EMG Input",
                icon: "💪",
                description: "Acquire EMG signals from muscles",
                category: "Data Acquisition",
                color: "#4361EE"
            },
            {
                type: "ecg_input",
                name: "ECG Input",
                icon: "❤️",
                description: "Acquire ECG heart signals",
                category: "Data Acquisition",
                color: "#4361EE"
            },
            {
                type: "file_reader",
                name: "File Reader",
                icon: "📁",
                description: "Read signals from data files",
                category: "Data Acquisition",
                color: "#4361EE"
            },
            {
                type: "signal_generator",
                name: "Signal Generator",
                icon: "📡",
                description: "Generate synthetic signals",
                category: "Data Acquisition",
                color: "#4361EE"
            },
            {
                type: "stream_reader",
                name: "Stream Reader",
                icon: "🌊",
                description: "Read real-time data streams",
                category: "Data Acquisition",
                color: "#4361EE"
            },

            // Preprocessing
            {
                type: "bandpass_filter",
                name: "Bandpass Filter",
                icon: "📈",
                description: "Filter signal between frequency range",
                category: "Preprocessing",
                color: "#4895EF"
            },
            {
                type: "notch_filter",
                name: "Notch Filter",
                icon: "🔇",
                description: "Remove power line interference",
                category: "Preprocessing",
                color: "#4895EF"
            },
            {
                type: "artifact_removal",
                name: "Artifact Removal",
                icon: "✨",
                description: "Remove eye blink and movement artifacts",
                category: "Preprocessing",
                color: "#4895EF"
            },
            {
                type: "normalization",
                name: "Normalization",
                icon: "⚖️",
                description: "Normalize signal amplitude",
                category: "Preprocessing",
                color: "#4895EF"
            },
            {
                type: "rereferencing",
                name: "Re-referencing",
                icon: "🔄",
                description: "Change EEG reference montage",
                category: "Preprocessing",
                color: "#4895EF"
            },
            {
                type: "epoching",
                name: "Epoching",
                icon: "⏱️",
                description: "Segment data into epochs",
                category: "Preprocessing",
                color: "#4895EF"
            },
            {
                type: "baseline_correction",
                name: "Baseline Correction",
                icon: "📉",
                description: "Remove baseline drift",
                category: "Preprocessing",
                color: "#4895EF"
            },
            {
                type: "resampling",
                name: "Resampling",
                icon: "🎛️",
                description: "Change sampling rate",
                category: "Preprocessing",
                color: "#4895EF"
            },

            // Feature Extraction
            {
                type: "csp_features",
                name: "CSP Features",
                icon: "🎯",
                description: "Common Spatial Pattern features",
                category: "Feature Extraction",
                color: "#4CC9F0"
            },
            {
                type: "psd_features",
                name: "PSD Features",
                icon: "📊",
                description: "Power Spectral Density features",
                category: "Feature Extraction",
                color: "#4CC9F0"
            },
            {
                type: "wavelet_features",
                name: "Wavelet Features",
                icon: "🌊",
                description: "Wavelet transform coefficients",
                category: "Feature Extraction",
                color: "#4CC9F0"
            },
            {
                type: "erp_features",
                name: "ERP Features",
                icon: "⚡",
                description: "Event-Related Potential features",
                category: "Feature Extraction",
                color: "#4CC9F0"
            },
            {
                type: "time_features",
                name: "Time Features",
                icon: "⏰",
                description: "Time-domain statistical features",
                category: "Feature Extraction",
                color: "#4CC9F0"
            },
            {
                type: "frequency_features",
                name: "Frequency Features",
                icon: "📶",
                description: "Frequency-domain features",
                category: "Feature Extraction",
                color: "#4CC9F0"
            },
            {
                type: "entropy_features",
                name: "Entropy Features",
                icon: "🎲",
                description: "Signal complexity measures",
                category: "Feature Extraction",
                color: "#4CC9F0"
            },

            // Classification
            {
                type: "lda_classifier",
                name: "LDA Classifier",
                icon: "📐",
                description: "Linear Discriminant Analysis",
                category: "Classification",
                color: "#7209B7"
            },
            {
                type: "svm_classifier",
                name: "SVM Classifier",
                icon: "⚡",
                description: "Support Vector Machine",
                category: "Classification",
                color: "#7209B7"
            },
            {
                type: "neural_network",
                name: "Neural Network",
                icon: "🕸️",
                description: "Deep learning classifier",
                category: "Classification",
                color: "#7209B7"
            },
            {
                type: "random_forest",
                name: "Random Forest",
                icon: "🌲",
                description: "Ensemble tree-based classifier",
                category: "Classification",
                color: "#7209B7"
            },
            {
                type: "knn_classifier",
                name: "KNN Classifier",
                icon: "📍",
                description: "K-Nearest Neighbors",
                category: "Classification",
                color: "#7209B7"
            },

            // BCI Paradigms
            {
                type: "p300_detector",
                name: "P300 Detector",
                icon: "🎯",
                description: "P300 ERP detection and classification",
                category: "BCI Paradigms",
                color: "#3A0CA3"
            },
            {
                type: "ssvep_detector",
                name: "SSVEP Detector",
                icon: "🌀",
                description: "Steady-State VEP frequency detection",
                category: "BCI Paradigms",
                color: "#3A0CA3"
            },
            {
                type: "motor_imagery",
                name: "Motor Imagery",
                icon: "💭",
                description: "Motor imagery CSP classification",
                category: "BCI Paradigms",
                color: "#3A0CA3"
            },
            {
                type: "ern_detector",
                name: "ERN Detector",
                icon: "❌",
                description: "Error-Related Negativity detection",
                category: "BCI Paradigms",
                color: "#3A0CA3"
            },

            // Visualization
            {
                type: "signal_plot",
                name: "Signal Plot",
                icon: "📈",
                description: "Real-time signal visualization",
                category: "Visualization",
                color: "#F72585"
            },
            {
                type: "spectrogram",
                name: "Spectrogram",
                icon: "🌈",
                description: "Time-frequency analysis plot",
                category: "Visualization",
                color: "#F72585"
            },
            {
                type: "topomap",
                name: "Topographic Map",
                icon: "🗺️",
                description: "Spatial distribution visualization",
                category: "Visualization",
                color: "#F72585"
            },
            {
                type: "erp_plot",
                name: "ERP Plot",
                icon: "⚡",
                description: "Event-Related Potential visualization",
                category: "Visualization",
                color: "#F72585"
            },
            {
                type: "feature_plot",
                name: "Feature Plot",
                icon: "📊",
                description: "Feature space visualization",
                category: "Visualization",
                color: "#F72585"
            },

            // Control
            {
                type: "cursor_control",
                name: "Cursor Control",
                icon: "🖱️",
                description: "2D cursor movement control",
                category: "Control",
                color: "#EF476F"
            },
            {
                type: "speller_control",
                name: "Speller Control",
                icon: "🔤",
                description: "P300 speller interface",
                category: "Control",
                color: "#EF476F"
            },
            {
                type: "game_control",
                name: "Game Control",
                icon: "🎮",
                description: "BCI game controller",
                category: "Control",
                color: "#EF476F"
            },

            // Utilities
            {
                type: "data_logger",
                name: "Data Logger",
                icon: "📝",
                description: "Record and save experimental data",
                category: "Utilities",
                color: "#6C757D"
            },
            {
                type: "performance_metrics",
                name: "Performance Metrics",
                icon: "📏",
                description: "Calculate accuracy and ITR",
                category: "Utilities",
                color: "#6C757D"
            },
            {
                type: "pipeline_optimizer",
                name: "Pipeline Optimizer",
                icon: "⚡",
                description: "Optimize pipeline parameters",
                category: "Utilities",
                color: "#6C757D"
            },
            {
                type: "export_node",
                name: "Export Results",
                icon: "📤",
                description: "Export analysis results",
                category: "Utilities",
                color: "#6C757D"
            }
        ]
    }
}
