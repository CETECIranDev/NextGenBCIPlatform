import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
    id: toolboxRoot
    background: Rectangle { color: themeManager.surfaceDark }

    // =========================================================================
    // --- مدل داده ساختگی (Mock Data) برای تمام نودهای موجود ---
    // =========================================================================
    // در نسخه نهایی، این مدل از C++ (از طریق PluginManager) بارگذاری خواهد شد.
    property var nodeCategories: [
        { "category": "Sources", "color": "#4E79A7", "nodes": [
            {"name": "EEG Device", "icon": "cpu", "inputs": [], "outputs": [{"name": "Signal"}]},
            {"name": "File Reader", "icon": "file-text", "inputs": [], "outputs": [{"name": "Signal"}]}
        ]},
        { "category": "Preprocessing", "color": "#59A14F", "nodes": [
            {"name": "Bandpass Filter", "icon": "filter", "inputs": [{"name": "In"}], "outputs": [{"name": "Out"}]},
            {"name": "Notch Filter", "icon": "filter", "inputs": [{"name": "In"}], "outputs": [{"name": "Out"}]},
            {"name": "Epoching", "icon": "scissors", "inputs": [{"name": "In"}, {"name": "Markers"}], "outputs": [{"name": "Epochs"}]}
        ]},
        { "category": "Feature Extraction", "color": "#EDC948", "nodes": [
            {"name": "CSP", "icon": "bar-chart-2", "inputs": [{"name": "Epochs"}], "outputs": [{"name": "Features"}]},
            {"name": "PSD", "icon": "bar-chart", "inputs": [{"name": "In"}], "outputs": [{"name": "Features"}]},
            {"name": "Hjorth Parameters", "icon": "activity", "inputs": [{"name": "In"}], "outputs": [{"name": "Features"}]}
        ]},
        { "category": "Machine Learning", "color": "#E15759", "nodes": [
            {"name": "LDA Classifier", "icon": "share-2", "inputs": [{"name": "Features"}], "outputs": [{"name": "Class"}]},
            {"name": "SVM Classifier", "icon": "share-2", "inputs": [{"name": "Features"}], "outputs": [{"name": "Class"}]}
        ]},
        { "category": "BCI Paradigms", "color": "#F28E2B", "nodes": [
            {"name": "P300 Stimulator", "icon": "grid", "inputs": [], "outputs": [{"name": "Markers"}]},
            {"name": "SSVEP Stimulator", "icon": "zap", "inputs": [], "outputs": []},
            {"name": "MI Feedback", "icon": "gift", "inputs": [{"name": "Class"}], "outputs": []}
        ]},
        { "category": "Visualization", "color": "#76B7B2", "nodes": [
            {"name": "Signal Viewer", "icon": "activity", "inputs": [{"name": "Signal"}], "outputs": []},
            {"name": "Power Spectrum", "icon": "bar-chart", "inputs": [{"name": "Signal"}], "outputs": []}
        ]}
    ]

    // =========================================================================
    // --- چیدمان اصلی پنل ---
    // =========================================================================
    ColumnLayout {
        anchors.fill: parent

        // --- فیلد جستجو ---
        TextField {
            id: searchField
            Layout.fillWidth: true
            Layout.margins: 8
            placeholderText: "Search nodes..."
            color: themeManager.textPrimary
            background: Rectangle {
                color: themeManager.backgroundDark
                radius: 4
                border.color: searchField.activeFocus ? themeManager.primary : themeManager.secondary
                border.width: 1
            }
            // منطق جستجو در آینده با فیلتر کردن مدل nodeCategories پیاده‌سازی خواهد شد
        }

        // --- لیست نودها ---
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: nodeCategories


            // Delegate برای هر دسته در مدل
            delegate: Column {
                width: listView.width

                // --- هدر دسته ---
                Rectangle {
                    width: parent.width
                    height: 30
                    color: themeManager.backgroundMedium

                    Label {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 16
                        text: modelData.category.toUpperCase() // نام دسته
                        font: themeManager.fontBase
                        color: themeManager.textSecondary
                        //font.bold: true
                    }
                }

                // --- Repeater برای نودهای داخل هر دسته ---
                Repeater {
                    model: modelData.nodes // مدل این Repeater، لیست نودهای هر دسته است

                    delegate: ItemDelegate {
                        width: parent.width
                        padding: 8

                        // --- محتوای آیتم با آیکون و متن ---
                        contentItem: RowLayout {
                            spacing: 12

                            // نوار رنگی
                            Rectangle {
                                width: 4; height: 20
                                color: model.color; radius: 2
                                Layout.alignment: Qt.AlignVCenter
                            }

                            // آیکون نود
                            Image {
                                source: "qrc:/qml/assets/icons/" + modelData.icon + ".svg"
                                sourceSize.width: 16; sourceSize.height: 16
                                antialiasing: true
                                Layout.alignment: Qt.AlignVCenter
                            }

                            // نام نود
                            Label {
                                text: modelData.name
                                color: themeManager.textPrimary
                                font: themeManager.fontBase
                                Layout.fillWidth: true
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        background: Rectangle {
                            color: parent.hovered ? themeManager.surfaceLight : "transparent"
                            radius: 4
                        }

                        // --- MouseArea برای فعال کردن Drag ---
                        MouseArea {
                            id: dragArea
                            anchors.fill: parent
                            drag.target: nodePreview

                            // این پراپرتی به MouseArea می‌گوید که رویداد را از آیتم‌های والد (مانند ListView) بدزدد
                            preventStealing: true


                            onPressed: (mouse) => {
                               // ۱. داده‌های لازم را در payload قرار می‌دهیم
                               const payload = {
                                   "name": modelData.name, "color": model.color, "icon": "qrc:/qml/assets/icons/" + modelData.icon + ".svg",
                                   "inputs": modelData.inputs, "outputs": modelData.outputs, "params": []
                               };
                               // ۲. آیتم پیش‌نمایش را به‌روز می‌کنیم
                               nodePreviewIcon.source = "qrc:/qml/assets/icons/" + modelData.icon + ".svg";
                               nodePreviewText.text = modelData.name;

                               // ۳. رویداد را مصرف می‌کنیم تا ListView اسکرول نکند
                               // mouse.accepted = true;

                                // به سیستم Drag & Drop سراسری می‌گوییم که یک آیتم برای کشیدن وجود دارد.
                              Drag.active = true;
                              Drag.hotSpot.x = 24; Drag.hotSpot.y = 24; // نقطه اتصال به ماوس
                              Drag.source = dragArea;
                              Drag.payload = payload;

                              // آیتم پیش‌نمایش را خودمان مدیریت می‌کنیم
                              nodePreview.x = mouse.x - Drag.hotSpot.x;
                              nodePreview.y = mouse.y - Drag.hotSpot.y;
                              nodePreview.visible = true;

                               // ۴. خط اشتباه `drag.start()` حذف شده است.
                           }
                        }
                    }
                }
            }
        }
    }

    // =========================================================================
    // --- آیتم پیش‌نمایش برای Drag ---
    // =========================================================================
    // این آیتم نامرئی است و فقط زمانی که کاربر در حال کشیدن است، توسط سیستم دیده می‌شود.
    Rectangle {
        id: nodePreview
        width: 180; height: 45
        color: themeManager.primary
        radius: 8
        visible: false
        z: 100 // اطمینان از اینکه روی همه چیز قرار می‌گیرد

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12; anchors.rightMargin: 12

            Image {
                id: nodePreviewIcon
                sourceSize.width: 18; sourceSize.height: 18
                antialiasing: true
                Layout.alignment: Qt.AlignVCenter
            }

            Label {
                id: nodePreviewText
                color: themeManager.textOnPrimary
                font.bold: true
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }
}
