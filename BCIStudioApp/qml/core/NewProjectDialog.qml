import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.platform 1.1 as Platform
import "../common"

ApplicationWindow {
    id: newProjectDialog
    title: "Create New Project"
    modality: Qt.ApplicationModal
    width: 800
    height: 700
    flags: Qt.Dialog
    color: "#1E1E1E"

    // سیگنال‌ها
    signal projectCreated(string projectName, string projectPath, string projectType, var settings)
    signal canceled()

    property string selectedProjectType: "bci_paradigm"
    property string selectedLocation: StandardPaths.writableLocation(StandardPaths.DocumentsLocation) + "/NeuroStudio/Projects"
    property color primaryColor: "#7C4DFF"

    // مدل‌های داده
    ListModel {
        id: projectTypesModel
        ListElement {
            type: "bci_paradigm"
            name: "BCI Paradigm"
            icon: "🧠"
            description: "Create a new Brain-Computer Interface experiment"
            category: "BCI Experiments"
            color: "#7C4DFF"
        }
        ListElement {
            type: "signal_analysis"
            name: "Signal Analysis"
            icon: "📊"
            description: "Analyze and process EEG/ECG/EMG signals"
            category: "Analysis"
            color: "#00E5FF"
        }
        ListElement {
            type: "ml_training"
            name: "ML Model Training"
            icon: "🤖"
            description: "Train machine learning models for classification"
            category: "Machine Learning"
            color: "#FF4081"
        }
        ListElement {
            type: "real_time_monitoring"
            name: "Real-time Monitoring"
            icon: "⚡"
            description: "Real-time signal monitoring and visualization"
            category: "Monitoring"
            color: "#00E676"
        }
        ListElement {
            type: "custom_pipeline"
            name: "Custom Pipeline"
            icon: "🔧"
            description: "Build custom processing pipeline from scratch"
            category: "Advanced"
            color: "#FF9800"
        }
    }

    ListModel {
        id: paradigmTemplatesModel
        ListElement {
            templateId: "p300"
            name: "P300 Speller"
            description: "Matrix-based P300 speller paradigm"
            icon: "qrc:/resources/icons/paradigms/p300.png"
            difficulty: "Beginner"
        }
        ListElement {
            templateId: "ssvep"
            name: "SSVEP"
            description: "Steady-State Visual Evoked Potentials"
            icon: "qrc:/resources/icons/paradigms/ssvep.png"
            difficulty: "Intermediate"
        }
        ListElement {
            templateId: "motor_imagery"
            name: "Motor Imagery"
            description: "Left/Right hand motor imagery classification"
            icon: "qrc:/resources/icons/paradigms/motor_imagery.png"
            difficulty: "Advanced"
        }
        ListElement {
            templateId: "erp"
            name: "ERP Analysis"
            description: "Event-Related Potential analysis"
            icon: "qrc:/resources/icons/paradigms/erp.png"
            difficulty: "Intermediate"
        }
    }

    // هدر دیالوگ
    Rectangle {
        id: header
        width: parent.width
        height: 50
        color: "#2A2A2A"

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20

            Text {
                text: "Create New Project"
                font.family: "Roboto"
                font.bold: true
                font.pixelSize: 18
                color: "white"
                Layout.fillWidth: true
            }

            Button {
                text: "✕"
                font.pixelSize: 16
                implicitWidth: 30
                implicitHeight: 30
                background: Rectangle {
                    color: "transparent"
                    radius: 15
                }
                onClicked: newProjectDialog.close()
            }
        }
    }

    // محتوای اصلی دیالوگ
    Rectangle {
        id: contentArea
        anchors.top: header.bottom
        anchors.bottom: footer.top
        width: parent.width
        color: "transparent"

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            // Progress Steps
            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                Repeater {
                    model: ["Project Type", "Configuration", "Review"]
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        height: 60
                        color: "transparent"

                        RowLayout {
                            anchors.fill: parent
                            spacing: 10

                            // شماره step
                            Rectangle {
                                width: 30
                                height: 30
                                radius: 15
                                color: stackView.currentIndex >= index ? primaryColor : "#2A2A2A"
                                border.color: stackView.currentIndex >= index ? primaryColor : "#666666"
                                border.width: 2

                                Text {
                                    anchors.centerIn: parent
                                    text: index + 1
                                    font.family: "Roboto"
                                    font.bold: true
                                    font.pixelSize: 12
                                    color: stackView.currentIndex >= index ? "white" : "#888888"
                                }
                            }

                            // متن step
                            Text {
                                text: modelData
                                font.family: "Roboto"
                                font.bold: stackView.currentIndex === index
                                font.pixelSize: 14
                                color: stackView.currentIndex >= index ? "white" : "#888888"
                                Layout.fillWidth: true
                            }

                            // خط جداکننده
                            Rectangle {
                                Layout.fillWidth: true
                                height: 2
                                color: stackView.currentIndex > index ? primaryColor : "#444444"
                                visible: index < 2
                            }
                        }
                    }
                }
            }

            // محتوای داینامیک
            StackLayout {
                id: stackView
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: 0

                // Step 1: انتخاب نوع پروژه
                ColumnLayout {
                    spacing: 15

                    Text {
                        text: "Select Project Type"
                        font.family: "Roboto"
                        font.bold: true
                        font.pixelSize: 18
                        color: "white"
                    }

                    // Grid انواع پروژه
                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true

                        GridLayout {
                            width: parent.width
                            columns: 2
                            columnSpacing: 15
                            rowSpacing: 15

                            Repeater {
                                model: projectTypesModel

                                delegate: Rectangle {
                                    id: projectCard
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 120
                                    radius: 8
                                    color: selectedProjectType === model.type ? Qt.darker(model.color, 2.5) : "#2A2A2A"
                                    border.color: selectedProjectType === model.type ? model.color : "transparent"
                                    border.width: 2

                                    MouseArea {
                                        anchors.fill: parent
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            selectedProjectType = model.type
                                        }
                                    }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 15
                                        spacing: 15

                                        // آیکون
                                        Rectangle {
                                            width: 50
                                            height: 50
                                            radius: 25
                                            color: model.color

                                            Text {
                                                anchors.centerIn: parent
                                                text: model.icon
                                                font.pixelSize: 20
                                            }
                                        }

                                        // محتوا
                                        ColumnLayout {
                                            spacing: 5
                                            Layout.fillWidth: true

                                            Text {
                                                text: model.name
                                                font.family: "Roboto"
                                                font.bold: true
                                                font.pixelSize: 16
                                                color: "white"
                                                Layout.fillWidth: true
                                            }

                                            Text {
                                                text: model.description
                                                font.family: "Roboto"
                                                font.pixelSize: 12
                                                color: "#AAAAAA"
                                                wrapMode: Text.Wrap
                                                Layout.fillWidth: true
                                            }

                                            // دسته‌بندی
                                            Rectangle {
                                                width: contentWidth + 10
                                                height: 20
                                                radius: 10
                                                color: Qt.darker(model.color, 1.5)

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: model.category
                                                    font.family: "Roboto"
                                                    font.pixelSize: 10
                                                    color: "white"
                                                }
                                            }
                                        }

                                        // نشانگر انتخاب
                                        Rectangle {
                                            width: 20
                                            height: 20
                                            radius: 10
                                            color: selectedProjectType === model.type ? model.color : "transparent"
                                            border.color: selectedProjectType === model.type ? model.color : "#666666"
                                            border.width: 2

                                            Text {
                                                anchors.centerIn: parent
                                                text: "✓"
                                                font.pixelSize: 12
                                                color: "white"
                                                visible: selectedProjectType === model.type
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Step 2: پیکربندی پروژه
                ColumnLayout {
                    spacing: 15

                    Text {
                        text: "Project Configuration"
                        font.family: "Roboto"
                        font.bold: true
                        font.pixelSize: 18
                        color: "white"
                    }

                    // فرم پیکربندی
                    GridLayout {
                        columns: 2
                        columnSpacing: 20
                        rowSpacing: 15
                        Layout.fillWidth: true

                        // نام پروژه
                        Text {
                            text: "Project Name *"
                            font.family: "Roboto"
                            font.pixelSize: 14
                            color: "white"
                        }

                        TextField {
                            id: projectNameField
                            placeholderText: "Enter project name..."
                            font.family: "Roboto"
                            font.pixelSize: 14
                            Layout.fillWidth: true
                            background: Rectangle {
                                color: "#2A2A2A"
                                border.color: projectNameField.activeFocus ? primaryColor : "#444444"
                                border.width: 1
                                radius: 4
                            }
                        }

                        // مسیر ذخیره‌سازی
                        Text {
                            text: "Location"
                            font.family: "Roboto"
                            font.pixelSize: 14
                            color: "white"
                        }

                        RowLayout {
                            Layout.fillWidth: true

                            TextField {
                                id: locationField
                                text: selectedLocation
                                readOnly: true
                                font.family: "Roboto"
                                font.pixelSize: 14
                                Layout.fillWidth: true
                                background: Rectangle {
                                    color: "#2A2A2A"
                                    border.color: "#444444"
                                    border.width: 1
                                    radius: 4
                                }
                            }

                            Button {
                                text: "Browse"
                                font.family: "Roboto"
                                font.pixelSize: 12
                                onClicked: folderDialog.open()
                                background: Rectangle {
                                    color: "#444444"
                                    radius: 4
                                }
                            }
                        }

                        // توصیف پروژه
                        Text {
                            text: "Description"
                            font.family: "Roboto"
                            font.pixelSize: 14
                            color: "white"
                            Layout.alignment: Qt.AlignTop
                        }

                        TextArea {
                            id: descriptionField
                            placeholderText: "Describe your project..."
                            font.family: "Roboto"
                            font.pixelSize: 14
                            Layout.fillWidth: true
                            Layout.preferredHeight: 80
                            wrapMode: TextArea.Wrap
                            background: Rectangle {
                                color: "#2A2A2A"
                                border.color: "#444444"
                                border.width: 1
                                radius: 4
                            }
                        }
                    }

                    // تنظیمات خاص هر نوع پروژه
                    Loader {
                        id: specificSettingsLoader
                        Layout.fillWidth: true
                        sourceComponent: getSpecificSettingsComponent()

                        function getSpecificSettingsComponent() {
                            switch(selectedProjectType) {
                                case "bci_paradigm":
                                    return bciParadigmSettings
                                case "signal_analysis":
                                    return signalAnalysisSettings
                                case "ml_training":
                                    return mlTrainingSettings
                                default:
                                    return null
                            }
                        }
                    }
                }

                // Step 3: مرور و تأیید
                ColumnLayout {
                    spacing: 15

                    Text {
                        text: "Review Project"
                        font.family: "Roboto"
                        font.bold: true
                        font.pixelSize: 18
                        color: "white"
                    }

                    // خلاصه پروژه
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 8
                        color: "#2A2A2A"

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 10

                            RowLayout {
                                Text {
                                    text: "Project Type:"
                                    font.family: "Roboto"
                                    font.bold: true
                                    font.pixelSize: 14
                                    color: "#AAAAAA"
                                    Layout.preferredWidth: 120
                                }

                                Text {
                                    text: getProjectTypeName()
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: "white"
                                    Layout.fillWidth: true
                                }
                            }

                            RowLayout {
                                Text {
                                    text: "Project Name:"
                                    font.family: "Roboto"
                                    font.bold: true
                                    font.pixelSize: 14
                                    color: "#AAAAAA"
                                    Layout.preferredWidth: 120
                                }

                                Text {
                                    text: projectNameField.text
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: "white"
                                    Layout.fillWidth: true
                                }
                            }

                            RowLayout {
                                Text {
                                    text: "Location:"
                                    font.family: "Roboto"
                                    font.bold: true
                                    font.pixelSize: 14
                                    color: "#AAAAAA"
                                    Layout.preferredWidth: 120
                                }

                                Text {
                                    text: locationField.text
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: "white"
                                    Layout.fillWidth: true
                                    wrapMode: Text.Wrap
                                }
                            }

                            RowLayout {
                                Text {
                                    text: "Description:"
                                    font.family: "Roboto"
                                    font.bold: true
                                    font.pixelSize: 14
                                    color: "#AAAAAA"
                                    Layout.preferredWidth: 120
                                }

                                Text {
                                    text: descriptionField.text || "No description"
                                    font.family: "Roboto"
                                    font.pixelSize: 14
                                    color: "white"
                                    Layout.fillWidth: true
                                    wrapMode: Text.Wrap
                                }
                            }

                            // خلاصه تنظیمات خاص
                            Loader {
                                id: summaryLoader
                                Layout.fillWidth: true
                                sourceComponent: getSummaryComponent()
                            }
                        }
                    }
                }
            }
        }
    }

    // Footer با دکمه‌ها
    Rectangle {
        id: footer
        anchors.bottom: parent.bottom
        width: parent.width
        height: 70
        color: "#2A2A2A"

        RowLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 10

            Button {
                text: "Cancel"
                font.family: "Roboto"
                font.pixelSize: 14
                Layout.preferredWidth: 100
                onClicked: {
                    canceled()
                    newProjectDialog.close()
                }
                background: Rectangle {
                    color: "transparent"
                    border.color: "#666666"
                    border.width: 1
                    radius: 4
                }
            }

            Item { Layout.fillWidth: true } // Spacer

            Button {
                id: backButton
                text: "Back"
                font.family: "Roboto"
                font.pixelSize: 14
                Layout.preferredWidth: 100
                visible: stackView.currentIndex > 0
                onClicked: stackView.currentIndex--
                background: Rectangle {
                    color: "#444444"
                    radius: 4
                }
            }

            Button {
                id: nextButton
                text: stackView.currentIndex === 2 ? "Create Project" : "Next"
                font.family: "Roboto"
                font.pixelSize: 14
                Layout.preferredWidth: 120
                enabled: validateCurrentStep()
                onClicked: handleNextButton()
                background: Rectangle {
                    color: enabled ? primaryColor : "#444444"
                    radius: 4
                }

                contentItem: Text {
                    text: nextButton.text
                    font: nextButton.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    // کامپوننت‌های تنظیمات خاص
    Component {
        id: bciParadigmSettings

        ColumnLayout {
            spacing: 15

            Text {
                text: "BCI Paradigm Settings"
                font.family: "Roboto"
                font.bold: true
                font.pixelSize: 16
                color: "white"
            }

            // انتخاب تمپلیت
            Text {
                text: "Paradigm Template"
                font.family: "Roboto"
                font.pixelSize: 14
                color: "white"
            }

            ComboBox {
                id: paradigmTemplateCombo
                model: paradigmTemplatesModel
                textRole: "name"
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#2A2A2A"
                    border.color: "#444444"
                    border.width: 1
                    radius: 4
                }
            }

            // تنظیمات دستگاه
            Text {
                text: "EEG Device"
                font.family: "Roboto"
                font.pixelSize: 14
                color: "white"
            }

            ComboBox {
                id: eegDeviceCombo
                model: ["OpenBCI Cyton", "Emotiv EPOC+", "NeuroSky MindWave", "Custom Device"]
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#2A2A2A"
                    border.color: "#444444"
                    border.width: 1
                    radius: 4
                }
            }

            // تعداد کانال‌ها
            Text {
                text: "Number of Channels"
                font.family: "Roboto"
                font.pixelSize: 14
                color: "white"
            }

            SpinBox {
                id: channelCountSpin
                from: 1
                to: 64
                value: 8
                stepSize: 1
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#2A2A2A"
                    border.color: "#444444"
                    border.width: 1
                    radius: 4
                }
            }
        }
    }

    Component {
        id: signalAnalysisSettings

        ColumnLayout {
            spacing: 15

            Text {
                text: "Signal Analysis Settings"
                font.family: "Roboto"
                font.bold: true
                font.pixelSize: 16
                color: "white"
            }

            // نوع سیگنال
            Text {
                text: "Signal Type"
                font.family: "Roboto"
                font.pixelSize: 14
                color: "white"
            }

            ComboBox {
                id: signalTypeCombo
                model: ["EEG", "ECG", "EMG", "EOG", "Custom"]
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#2A2A2A"
                    border.color: "#444444"
                    border.width: 1
                    radius: 4
                }
            }

            // نرخ نمونه‌برداری
            Text {
                text: "Sampling Rate (Hz)"
                font.family: "Roboto"
                font.pixelSize: 14
                color: "white"
            }

            ComboBox {
                id: samplingRateCombo
                model: [128, 256, 512, 1024, 2048]
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#2A2A2A"
                    border.color: "#444444"
                    border.width: 1
                    radius: 4
                }
            }
        }
    }

    Component {
        id: mlTrainingSettings

        ColumnLayout {
            spacing: 15

            Text {
                text: "Machine Learning Settings"
                font.family: "Roboto"
                font.bold: true
                font.pixelSize: 16
                color: "white"
            }

            // نوع مدل
            Text {
                text: "Model Type"
                font.family: "Roboto"
                font.pixelSize: 14
                color: "white"
            }

            ComboBox {
                id: modelTypeCombo
                model: ["LDA", "SVM", "Random Forest", "Neural Network", "CNN", "LSTM"]
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#2A2A2A"
                    border.color: "#444444"
                    border.width: 1
                    radius: 4
                }
            }

            // نوع طبقه‌بندی
            Text {
                text: "Classification Type"
                font.family: "Roboto"
                font.pixelSize: 14
                color: "white"
            }

            ComboBox {
                id: classificationTypeCombo
                model: ["Binary", "Multi-class", "Regression"]
                Layout.fillWidth: true
                background: Rectangle {
                    color: "#2A2A2A"
                    border.color: "#444444"
                    border.width: 1
                    radius: 4
                }
            }
        }
    }

    // کامپوننت‌های خلاصه
    Component {
        id: bciParadigmSummary

        ColumnLayout {
            spacing: 5

            RowLayout {
                Text {
                    text: "Paradigm Template:"
                    font.family: "Roboto"
                    font.bold: true
                    font.pixelSize: 14
                    color: "#AAAAAA"
                    Layout.preferredWidth: 120
                }

                Text {
                    text: paradigmTemplatesModel.get(paradigmTemplateCombo.currentIndex).name
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: "white"
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Text {
                    text: "EEG Device:"
                    font.family: "Roboto"
                    font.bold: true
                    font.pixelSize: 14
                    color: "#AAAAAA"
                    Layout.preferredWidth: 120
                }

                Text {
                    text: eegDeviceCombo.currentText
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: "white"
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Text {
                    text: "Channels:"
                    font.family: "Roboto"
                    font.bold: true
                    font.pixelSize: 14
                    color: "#AAAAAA"
                    Layout.preferredWidth: 120
                }

                Text {
                    text: channelCountSpin.value
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: "white"
                    Layout.fillWidth: true
                }
            }
        }
    }

    Component {
        id: signalAnalysisSummary

        ColumnLayout {
            spacing: 5

            RowLayout {
                Text {
                    text: "Signal Type:"
                    font.family: "Roboto"
                    font.bold: true
                    font.pixelSize: 14
                    color: "#AAAAAA"
                    Layout.preferredWidth: 120
                }

                Text {
                    text: signalTypeCombo.currentText
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: "white"
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Text {
                    text: "Sampling Rate:"
                    font.family: "Roboto"
                    font.bold: true
                    font.pixelSize: 14
                    color: "#AAAAAA"
                    Layout.preferredWidth: 120
                }

                Text {
                    text: samplingRateCombo.currentText + " Hz"
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: "white"
                    Layout.fillWidth: true
                }
            }
        }
    }

    Component {
        id: mlTrainingSummary

        ColumnLayout {
            spacing: 5

            RowLayout {
                Text {
                    text: "Model Type:"
                    font.family: "Roboto"
                    font.bold: true
                    font.pixelSize: 14
                    color: "#AAAAAA"
                    Layout.preferredWidth: 120
                }

                Text {
                    text: modelTypeCombo.currentText
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: "white"
                    Layout.fillWidth: true
                }
            }

            RowLayout {
                Text {
                    text: "Classification:"
                    font.family: "Roboto"
                    font.bold: true
                    font.pixelSize: 14
                    color: "#AAAAAA"
                    Layout.preferredWidth: 120
                }

                Text {
                    text: classificationTypeCombo.currentText
                    font.family: "Roboto"
                    font.pixelSize: 14
                    color: "white"
                    Layout.fillWidth: true
                }
            }
        }
    }

    // Folder Dialog برای انتخاب پوشه
    Platform.FolderDialog {
        id: folderDialog
        onAccepted: {
            selectedLocation = folderDialog.folder.toString().replace("file://", "")
        }
    }

    // توابع کمکی
    function getProjectTypeIndex() {
        for (var i = 0; i < projectTypesModel.count; i++) {
            if (projectTypesModel.get(i).type === selectedProjectType) {
                return i
            }
        }
        return 0
    }

    function getProjectTypeName() {
        for (var i = 0; i < projectTypesModel.count; i++) {
            if (projectTypesModel.get(i).type === selectedProjectType) {
                return projectTypesModel.get(i).name
            }
        }
        return ""
    }

    function validateCurrentStep() {
        switch(stackView.currentIndex) {
            case 0: // انتخاب نوع
                return selectedProjectType !== ""
            case 1: // پیکربندی
                return projectNameField.text.trim() !== ""
            case 2: // مرور
                return true
            default:
                return false
        }
    }

    function handleNextButton() {
        if (stackView.currentIndex < 2) {
            stackView.currentIndex++
            updateButtonStates()
        } else {
            createProject()
        }
    }

    function updateButtonStates() {
        backButton.visible = stackView.currentIndex > 0
        nextButton.text = stackView.currentIndex === 2 ? "Create Project" : "Next"
    }

    function getSummaryComponent() {
        switch(selectedProjectType) {
            case "bci_paradigm": return bciParadigmSummary
            case "signal_analysis": return signalAnalysisSummary
            case "ml_training": return mlTrainingSummary
            default: return null
        }
    }

    function createProject() {
        var projectSettings = {
            type: selectedProjectType,
            name: projectNameField.text,
            location: selectedLocation,
            description: descriptionField.text,
            createdAt: new Date().toISOString(),

            // تنظیمات خاص
            bciSettings: selectedProjectType === "bci_paradigm" ? {
                template: paradigmTemplatesModel.get(paradigmTemplateCombo.currentIndex).templateId,
                device: eegDeviceCombo.currentText,
                channels: channelCountSpin.value
            } : {},

            signalSettings: selectedProjectType === "signal_analysis" ? {
                signalType: signalTypeCombo.currentText,
                samplingRate: parseInt(samplingRateCombo.currentText)
            } : {},

            mlSettings: selectedProjectType === "ml_training" ? {
                modelType: modelTypeCombo.currentText,
                classificationType: classificationTypeCombo.currentText
            } : {}
        }

        // سیگنال ایجاد پروژه
        projectCreated(projectSettings.name, projectSettings.location, projectSettings.type, projectSettings)

        // بستن دیالوگ
        newProjectDialog.close()
    }

    // هنگام باز شدن دیالوگ
    onVisibleChanged: {
        if (visible) {
            stackView.currentIndex = 0
            projectNameField.text = ""
            descriptionField.text = ""
            projectNameField.forceActiveFocus()
        }
    }
}
