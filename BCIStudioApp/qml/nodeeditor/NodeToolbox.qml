import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects


Rectangle {
    id: nodeToolbox
    color: theme.backgroundSecondary
    border.color: theme.border
    border.width: 1

    property var theme
    signal nodeDragStarted(string nodeType, var mouse)
    signal categorySelected(string category)
    signal toolboxCategoriesChanged() // تغییر نام سیگنال

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
        },
        {
            name: "Feature Extraction",
            icon: "🔍",
            color: "#06D6A0",
            nodes: [
                {type: "psd_features", name: "PSD Features", icon: "📊", description: "Power Spectral Density features"},
                {type: "csp_features", name: "CSP Features", icon: "🧩", description: "Common Spatial Patterns features"},
                {type: "time_features", name: "Time Features", icon: "⏱️", description: "Time-domain features"}
            ]
        },
        {
            name: "BCI Paradigms",
            icon: "🧠",
            color: "#7209B7",
            nodes: [
                {type: "p300_speller", name: "P300 Speller", icon: "🔤", description: "P300 spelling interface"},
                {type: "ssvep_detector", name: "SSVEP Detector", icon: "📊", description: "Steady-State VEP detection"},
                {type: "motor_imagery", name: "Motor Imagery", icon: "💪", description: "Motor imagery classification"}
            ]
        }
    ]

    // Shadow effect
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

                onTextChanged: {
                    filterNodes();
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
                    model: filteredCategories

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

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        nodeToolbox.categorySelected(modelData.name);
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

                                        // Hover effect
                                        Behavior on color {
                                            ColorAnimation { duration: 200 }
                                        }

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.margins: 12
                                            spacing: 12

                                            // Node Icon
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

                                        // Mouse Area for Drag
                                        MouseArea {
                                            id: nodeMouseArea
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            cursorShape: Qt.PointingHandCursor
                                            drag.threshold: 1

                                            property bool isDragging: false
                                            property point dragStartPos

                                            onPressed: (mouse) => {
                                                console.log("🖱️ Node pressed:", nodeType);
                                                dragStartPos = Qt.point(mouse.x, mouse.y);
                                                isDragging = false;
                                            }

                                            onPositionChanged: (mouse) => {
                                                if (pressed && !isDragging &&
                                                    (Math.abs(mouse.x - mouse.originX) > drag.threshold ||
                                                     Math.abs(mouse.y - mouse.originY) > drag.threshold)) {
                                                    isDragging = true;
                                                    console.log("🚀 Starting drag for:", nodeType);

                                                    // شروع درگ
                                                    var globalPos = nodeItem.mapToItem(null, mouse.x, mouse.y);
                                                    nodeToolbox.nodeDragStarted(nodeType, {
                                                        x: globalPos.x,
                                                        y: globalPos.y,
                                                        source: "toolbox"
                                                    });
                                                }
                                            }

                                            onReleased: {
                                                if (!isDragging) {
                                                    // اگر درگ نبود، کلیک ساده است
                                                    console.log("👆 Node clicked:", nodeType);
                                                }
                                                isDragging = false;
                                            }

                                            onExited: {
                                                if (pressed && isDragging) {
                                                    // اگر درگ ادامه دارد خارج از آیتم
                                                    console.log("📍 Drag continuing outside node item");
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

                // Empty State
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"
                    visible: filteredCategories.length === 0

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 16
                        width: parent.width * 0.8

                        Rectangle {
                            width: 80
                            height: 80
                            radius: 40
                            color: theme.backgroundTertiary
                            Layout.alignment: Qt.AlignCenter

                            Text {
                                text: "🔍"
                                font.pixelSize: 32
                                color: theme.textTertiary
                                anchors.centerIn: parent
                            }
                        }

                        ColumnLayout {
                            spacing: 6
                            Layout.alignment: Qt.AlignCenter

                            Text {
                                text: "No nodes found"
                                color: theme.textPrimary
                                font.family: "Segoe UI Semibold"
                                font.pixelSize: 16
                                font.weight: Font.DemiBold
                                Layout.alignment: Qt.AlignCenter
                            }

                            Text {
                                text: "Try adjusting your search terms"
                                color: theme.textTertiary
                                font.family: "Segoe UI"
                                font.pixelSize: 12
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
        }
    }

    // Property برای فیلتر کردن دسته‌بندی‌ها
    property var filteredCategories: {
        if (!searchBox.text) {
            return categories;
        }

        var searchTerm = searchBox.text.toLowerCase();
        var filtered = [];

        for (var i = 0; i < categories.length; i++) {
            var category = categories[i];
            var filteredNodes = [];

            // فیلتر نودها در این دسته‌بندی
            for (var j = 0; j < category.nodes.length; j++) {
                var node = category.nodes[j];
                if (node.name.toLowerCase().includes(searchTerm) ||
                    node.description.toLowerCase().includes(searchTerm) ||
                    node.type.toLowerCase().includes(searchTerm)) {
                    filteredNodes.push(node);
                }
            }

            // اگر نودی در این دسته‌بندی باقی ماند، دسته‌بندی را اضافه کن
            if (filteredNodes.length > 0) {
                var filteredCategory = {
                    name: category.name,
                    icon: category.icon,
                    color: category.color,
                    nodes: filteredNodes
                };
                filtered.push(filteredCategory);
            }
        }

        return filtered;
    }

    // تابع فیلتر کردن نودها
    function filterNodes() {
        console.log("🔍 Filtering nodes. Search term:", searchBox.text);
    }

    // تابع برای پیدا کردن نود بر اساس نوع
    function findNodeByType(nodeType) {
        for (var i = 0; i < categories.length; i++) {
            var category = categories[i];
            for (var j = 0; j < category.nodes.length; j++) {
                if (category.nodes[j].type === nodeType) {
                    return category.nodes[j];
                }
            }
        }
        return null;
    }

    // تابع برای گرفتن تمام نودها
    function getAllNodes() {
        var allNodes = [];
        for (var i = 0; i < categories.length; i++) {
            allNodes = allNodes.concat(categories[i].nodes);
        }
        return allNodes;
    }

    // تابع برای اضافه کردن دسته‌بندی جدید
    function addCategory(categoryData) {
        categories.push(categoryData);
        toolboxCategoriesChanged(); // استفاده از نام جدید
    }

    // تابع برای اضافه کردن نود به دسته‌بندی
    function addNodeToCategory(categoryName, nodeData) {
        for (var i = 0; i < categories.length; i++) {
            if (categories[i].name === categoryName) {
                categories[i].nodes.push(nodeData);
                toolboxCategoriesChanged(); // استفاده از نام جدید
                return true;
            }
        }
        return false;
    }

    // تابع برای حذف نود
    function removeNode(nodeType) {
        for (var i = 0; i < categories.length; i++) {
            var category = categories[i];
            for (var j = 0; j < category.nodes.length; j++) {
                if (category.nodes[j].type === nodeType) {
                    category.nodes.splice(j, 1);
                    toolboxCategoriesChanged(); // استفاده از نام جدید
                    return true;
                }
            }
        }
        return false;
    }

    // انیمیشن هنگام تغییر
    Behavior on Layout.preferredWidth {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    // وضعیت collapse
    states: [
        State {
            name: "collapsed"
            when: typeof nodeEditorView !== 'undefined' && nodeEditorView.leftSidebarCollapsed
            PropertyChanges {
                target: nodeToolbox;
                opacity: 0.8
            }
        }
    ]

    // Tooltip برای آیتم‌ها
    ToolTip {
        id: nodeTooltip
        delay: 500
        timeout: 3000
    }

    // Initialization
    Component.onCompleted: {
        console.log("🧩 NodeToolbox initialized with", categories.length, "categories");
        console.log("📊 Total nodes:", getAllNodes().length);

        // نمایش اطلاعات دسته‌بندی‌ها
        categories.forEach(function(category, index) {
            console.log("📁 Category", index + 1 + ":", category.name, "with", category.nodes.length, "nodes");
        });
    }

    // Debug information
    function debugInfo() {
        console.log("=== NODE TOOLBOX DEBUG INFO ===");
        console.log("Categories:", categories.length);
        console.log("Filtered categories:", filteredCategories.length);
        console.log("Search term:", searchBox.text);
        console.log("Theme available:", theme !== undefined);
        console.log("===============================");
    }

    // تابع برای ریست جستجو
    function clearSearch() {
        searchBox.text = "";
    }

    // تابع برای به‌روزرسانی تم
    function updateTheme(newTheme) {
        theme = newTheme;
    }

    // مدیریت تغییر سایز
    onWidthChanged: {
        if (width < 200) {
            console.log("⚠️ NodeToolbox width is very small:", width);
        }
    }
}
