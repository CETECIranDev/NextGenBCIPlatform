import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.platform 1.1 as Platform

import "./core"
import "./nodeeditor"
import "./home"
import "./dashboard"
import "./bci"
import "./common"

ApplicationWindow {
    id: mainWindow
    width: 1600
    height: 1000
    minimumWidth: 1200
    minimumHeight: 800
    visible: true
    title: "BCI Studio Pro - Advanced BCI Platform"

    // تنظیمات پنجره برای fullscreen و حذف نوار پیش‌فرض
    flags: Qt.Window | Qt.FramelessWindowHint
    visibility: Window.FullScreen


    ThemeManager {
        id: appTheme
        onThemeSwitched: {
            // console.log("Theme switched to:", newTheme)
            // انیمیشن تغییر تم برای کل پنجره
            //themeTransition.from = newTheme === "light" ? "#0A0A0A" : "#FFFFFF"
            //themeTransition.to = theme.backgroundPrimary
            //themeTransition.start()
            theme = appTheme.theme

        }
    }

    // تم فعال - برای استفاده در کل برنامه
    property var theme: appTheme.theme

    // رنگ پنجره بر اساس تم
    color: theme.backgroundPrimary

    // انیمیشن تغییر تم برای کل پنجره
    ColorAnimation {
        id: themeTransition
        target: mainWindow
        property: "color"
        duration: appTheme.transitionDuration
        easing.type: Easing.OutCubic
    }

    // فونت‌های سفارشی
    // FontLoader { id: robotoRegular; source: "qrc:/resources/fonts/Roboto-Regular.ttf" }
    // FontLoader { id: robotoBold; source: "qrc:/resources/fonts/Roboto-Bold.ttf" }
    // FontLoader { id: materialIcons; source: "qrc:/resources/fonts/MaterialIcons-Regular.ttf" }

    // یا برای cross-platform بهتر:
    property string defaultFont: {
        if (Qt.platform.os === "windows") return "Segoe UI"
        else if (Qt.platform.os === "osx") return "San Francisco"
        else return "Arial"
    }

    // کنترلر اصلی برنامه
    property var appController: null

    // مدل‌های داده
    ListModel {
        id: recentProjects
        ListElement {
            name: "P300 Speller Analysis"
            path: "/projects/p300_analysis.nproj"
            lastModified: "2024-01-15 14:30"
            thumbnail: "qrc:/resources/images/thumbnails/p300.png"
        }
        ListElement {
            name: "Motor Imagery Classification"
            path: "/projects/motor_imagery.nproj"
            lastModified: "2024-01-14 11:20"
            thumbnail: "qrc:/resources/images/thumbnails/motor.png"
        }
        ListElement {
            name: "SSVEP Frequency Detection"
            path: "/projects/ssvep_detection.nproj"
            lastModified: "2024-01-13 09:45"
            thumbnail: "qrc:/resources/images/thumbnails/ssvep.png"
        }
    }

    ListModel {
        id: quickActions
        ListElement {
            icon: "🧠"
            title: "New BCI Paradigm"
            description: "Create a new brain-computer interface experiment"
            action: "create_paradigm"
            color: "#7C4DFF"
        }
        ListElement {
            icon: "📊"
            title: "Real-time Dashboard"
            description: "Monitor signals and performance in real-time"
            action: "open_dashboard"
            color: "#00E5FF"
        }
        ListElement {
            icon: "⚡"
            title: "Signal Processing"
            description: "Advanced EEG signal analysis and filtering"
            action: "open_processing"
            color: "#FF4081"
        }
        ListElement {
            icon: "🎯"
            title: "Model Training"
            description: "Train machine learning models for BCI"
            action: "open_training"
            color: "#00E676"
        }
    }

    // نوار عنوان سفارشی
        Rectangle {
            id: customTitleBar
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 40
            color: theme.backgroundSecondary
            z: 1000

            MouseArea {
                anchors.fill: parent
                property point clickPos: "0,0"

                onPressed: {
                    clickPos = Qt.point(mouse.x, mouse.y)
                }

                onPositionChanged: {
                    if (pressed) {
                        var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                        mainWindow.x += delta.x
                        mainWindow.y += delta.y
                    }
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 8

                // لوگو و عنوان برنامه
                Row {
                    spacing: 8
                    Layout.alignment: Qt.AlignVCenter

                    Text {
                        text: "🧠"
                        font.pixelSize: 16
                        color: theme.textPrimary
                    }

                    Text {
                        text: "BCI Studio Pro"
                        color: theme.textPrimary
                        font.bold: true
                        font.pixelSize: 14
                    }
                }

                Item { Layout.fillWidth: true }

                // دکمه‌های کنترل پنجره
                Row {
                    spacing: 6
                    Layout.alignment: Qt.AlignVCenter

                    // دکمه مینیمایز
                    Rectangle {
                        width: 28
                        height: 28
                        radius: 4
                        color: "transparent"

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: mainWindow.visibility = Window.Minimized

                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: theme.primary
                                opacity: parent.containsMouse ? 0.1 : 0
                            }
                        }

                        Text {
                            text: "−"
                            color: theme.textPrimary
                            font.pixelSize: 16
                            font.bold: true
                            anchors.centerIn: parent
                        }
                    }

                    // دکمه toggle fullscreen/windowed
                    Rectangle {
                        width: 28
                        height: 28
                        radius: 4
                        color: "transparent"

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (mainWindow.visibility === Window.FullScreen) {
                                    mainWindow.visibility = Window.Windowed
                                    mainWindow.showMaximized()
                                } else {
                                    mainWindow.visibility = Window.FullScreen
                                }
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: theme.primary
                                opacity: parent.containsMouse ? 0.1 : 0
                            }
                        }

                        Text {
                            text: "⛶"
                            color: theme.textPrimary
                            font.pixelSize: 12
                            anchors.centerIn: parent
                        }
                    }

                    // دکمه بستن برنامه
                    Rectangle {
                        width: 28
                        height: 28
                        radius: 4
                        color: "transparent"

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: mainWindow.close()

                            Rectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: "#FF5252"
                                opacity: parent.containsMouse ? 0.2 : 0
                            }
                        }

                        Text {
                            text: "×"
                            color: theme.textPrimary
                            font.pixelSize: 18
                            font.bold: true
                            anchors.centerIn: parent
                        }
                    }
                }
            }

            // خط جداکننده
            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: theme.border
            }
        }

    // صفحه اصلی
    Rectangle {
        id: mainContainer
        anchors.top: customTitleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: "transparent"
        visible: !splashScreen.visible
        // Background with gradient and pattern
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: theme.backgroundPrimary }
                GradientStop { position: 1.0; color: theme.backgroundSecondary }
            }

            // Subtle background pattern
            Image {
                source: "qrc:/resources/images/backgrounds/circuit.png"
                anchors.fill: parent
                opacity: appTheme.currentTheme === "dark" ? 0.03 : 0.01
                fillMode: Image.Tile
            }
        }

        // محتوای اصلی - با RowLayout برای responsive design
        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // هدر برنامه
            NeuroHeader {
                id: appHeader
                Layout.fillWidth: true
                height: 80
                currentWorkspace: appController ? appController.currentWorkspace : "home"
                onTogglePropertiesPanel: console.log("Toggle properties panel")
                // onToggleFullScreen: mainWindow.visibility === Window.Windowed ?
                //     mainWindow.showMaximized() : mainWindow.showNormal()

                // سوئیچ تم در هدر
                ThemeSwitcher {
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    size: 36
                }
            }

            // بدنه اصلی با سایدبار و محتوای responsive
            RowLayout {
                id: mainBody
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                // نوار کناری - عرض داینامیک
                NeuroSidebar {
                    id: mainSidebar
                    Layout.preferredWidth: mainSidebar.collapsed ? 50 : 280
                    Layout.minimumWidth: mainSidebar.collapsed ? 50 : 280
                    Layout.maximumWidth: mainSidebar.collapsed ? 50 : 280
                    Layout.fillHeight: true
                    currentWorkspace: appController ? appController.currentWorkspace : "home"
                    onWorkspaceSelected: handleSidebarAction(workspaceId)
                }

                // محتوای مرکزی - این قسمت به طور خودکار فضای باقی مانده رو پر میکنه
                Rectangle {
                    id: contentArea
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "transparent"

                    StackLayout {
                        id: mainContent
                        anchors.fill: parent
                        currentIndex: getWorkspaceIndex(appController ? appController.currentWorkspace : "home")

                        // صفحه اصلی (Home)
                        HomeScreen {
                            id: homeScreen
                            recentProjects: recentProjects
                            quickActions: quickActions
                            onActionTriggered: handleQuickAction(action)
                        }

                        // Node Editor
                        NodeEditorView {
                            id: nodeEditor
                            visible: mainContent.currentIndex === 1
                            enabled: mainContent.currentIndex === 1

                            // اضافه کردن propertyهای لازم برای ارتباط
                            property var nodeGraphManager: appController ? appController.nodeGraphManager : null
                            property var nodeRegistry: appController ? appController.nodeRegistry : null
                            property var pipelineValidator: appController ? appController.pipelineValidator : null

                            // سیگنال‌های مورد نیاز
                            onNodeCreated: (nodeData) => {
                                console.log("Node created:", nodeData)
                                if (appController && appController.nodeGraphManager) {
                                    appController.nodeGraphManager.addNode(nodeData)
                                }
                            }

                            onGraphModified: () => {
                                console.log("Graph modified")
                                if (appController) {
                                    appController.setHasUnsavedChanges(true)
                                }
                            }

                            onExecutionInitiated: () => {
                                console.log("Execution started")
                                if (appController) {
                                    appController.executePipeline()
                                }
                            }
                        }

                        // Dashboard
                        DashboardView {
                            id: dashboardView
                        }

                        // BCI Paradigms
                        BCIParadigmManager {
                            id: bciManager
                           theme: mainWindow.theme
                           appController: mainWindow.appController
                        }

                        // Placeholder برای workspaceهای دیگر
                        Item {
                            id: placeholderWorkspace
                            Rectangle {
                                anchors.centerIn: parent
                                width: 400
                                height: 200
                                color: theme.backgroundCard
                                radius: theme.radius.lg

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 15

                                    Text {
                                        text: "Workspace: " + (appController ? appController.currentWorkspace : "unknown")
                                        color: theme.textPrimary
                                        font.bold: true
                                        font.pixelSize: theme.typography.h4.size
                                    }

                                    Text {
                                        text: "This workspace is under development"
                                        color: theme.textSecondary
                                        font.pixelSize: theme.typography.body2.size
                                    }
                                }
                            }
                        }
                    }

                    // نمایش وضعیت responsive (برای دیباگ)
                    Text {
                        anchors.top: parent.top
                        anchors.right: parent.right
                        anchors.margins: 10
                        text: "Content Width: " + contentArea.width + "px"
                        color: theme.textSecondary
                        font.pixelSize: 10
                        visible: false // برای دیباگ میتونی true کنی
                    }
                }
            }

            // Status Bar
            NeuroStatusBar {
                Layout.fillWidth: true
                height: 30
                currentWorkspace: appController ? appController.currentWorkspace : "home"
                currentProject: appController ? appController.currentProjectName : "No Project"
                hasUnsavedChanges: appController ? appController.hasUnsavedChanges : false
            }
        }
    }

    // Splash Screen برای اولین اجرا
    SplashScreen {
        id: splashScreen
        anchors.fill: parent
        visible: true
        onFinished: {
            if (appController) {
                appController.hideSplash()
            }
        }
    }

    // Dialog برای پروژه جدید
    NewProjectDialog {
        id: newProjectDialog
        visible: false

        onProjectCreated: {
            console.log("Project created:", projectName, projectPath, projectType)
            if (appController) {
                appController.createNewProject(projectName, projectPath, projectType, settings)
            }
        }

        onCanceled: {
            console.log("Project creation canceled")
        }
    }

    // Dialog تنظیمات
    Dialog {
        id: settingsDialog
        title: "Settings"
        standardButtons: Dialog.Ok | Dialog.Cancel
        anchors.centerIn: Overlay.overlay
        width: 500
        height: 400

        background: Rectangle {
            color: theme.backgroundCard
            radius: theme.radius.lg
            border.color: theme.border
        }

        ColumnLayout {
            width: parent.width
            spacing: theme.spacing.lg

            Text {
                text: "Application Settings"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: theme.typography.h4.size
                Layout.alignment: Qt.AlignHCenter
            }

            // بخش تم
            Rectangle {
                Layout.fillWidth: true
                height: 100
                color: theme.backgroundLight
                radius: theme.radius.md

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: theme.spacing.md

                    Text {
                        text: "Theme"
                        color: theme.textPrimary
                        font.bold: true
                        font.pixelSize: theme.typography.h6.size
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: theme.spacing.sm

                        Button {
                            text: "🌙 Dark Mode"
                            highlighted: appTheme.currentTheme === "dark"
                            onClicked: appTheme.setTheme("dark")
                            Layout.fillWidth: true
                        }

                        Button {
                            text: "☀️ Light Mode"
                            highlighted: appTheme.currentTheme === "light"
                            onClicked: appTheme.setTheme("light")
                            Layout.fillWidth: true
                        }
                    }
                }
            }

            // سایر تنظیمات
            Text {
                text: "Other settings will be implemented soon..."
                color: theme.textSecondary
                wrapMode: Text.Wrap
                font.pixelSize: theme.typography.body2.size
                Layout.fillWidth: true
            }
        }
    }

    Dialog {
        id: helpDialog
        title: "Help & Documentation"
        standardButtons: Dialog.Ok
        anchors.centerIn: Overlay.overlay
        width: 600
        height: 500

        background: Rectangle {
            color: theme.backgroundCard
            radius: theme.radius.lg
            border.color: theme.border
        }

        ColumnLayout {
            width: parent.width
            spacing: theme.spacing.lg

            Text {
                text: "BCI Studio Pro Help"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: theme.typography.h4.size
                Layout.alignment: Qt.AlignHCenter
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ColumnLayout {
                    width: parent.width
                    spacing: theme.spacing.md

                    Text {
                        text: "Welcome to BCI Studio Pro!"
                        color: theme.textPrimary
                        font.bold: true
                        font.pixelSize: theme.typography.h5.size
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "This is an advanced Brain-Computer Interface platform for EEG signal processing and analysis."
                        color: theme.textSecondary
                        wrapMode: Text.Wrap
                        font.pixelSize: theme.typography.body1.size
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "Key Features:"
                        color: theme.textPrimary
                        font.bold: true
                        font.pixelSize: theme.typography.h6.size
                        Layout.fillWidth: true
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: theme.spacing.xs

                        Text {
                            text: "• Real-time EEG signal monitoring"
                            color: theme.textSecondary
                            font.pixelSize: theme.typography.body2.size
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "• Multiple BCI paradigms (P300, SSVEP, Motor Imagery)"
                            color: theme.textSecondary
                            font.pixelSize: theme.typography.body2.size
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "• Visual node-based pipeline editor"
                            color: theme.textSecondary
                            font.pixelSize: theme.typography.body2.size
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "• Advanced signal processing and machine learning"
                            color: theme.textSecondary
                            font.pixelSize: theme.typography.body2.size
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "• Professional dashboard with cognitive metrics"
                            color: theme.textSecondary
                            font.pixelSize: theme.typography.body2.size
                            Layout.fillWidth: true
                        }
                    }

                    Text {
                        text: "Shortcuts:"
                        color: theme.textPrimary
                        font.bold: true
                        font.pixelSize: theme.typography.h6.size
                        Layout.fillWidth: true
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: theme.spacing.xs

                        Text {
                            text: "Ctrl+N - New Project"
                            color: theme.textSecondary
                            font.pixelSize: theme.typography.body2.size
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "Ctrl+O - Open Project"
                            color: theme.textSecondary
                            font.pixelSize: theme.typography.body2.size
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "Ctrl+S - Save Project"
                            color: theme.textSecondary
                            font.pixelSize: theme.typography.body2.size
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "F1 - Help"
                            color: theme.textSecondary
                            font.pixelSize: theme.typography.body2.size
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "F11 - Toggle Fullscreen"
                            color: theme.textSecondary
                            font.pixelSize: theme.typography.body2.size
                            Layout.fillWidth: true
                        }
                        Text {
                            text: "Ctrl+T - Toggle Theme"
                            color: theme.textSecondary
                            font.pixelSize: theme.typography.body2.size
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }
    }

    Platform.FolderDialog {
        id: fileDialog
        title: "Open Project"
        onAccepted: {
            if (appController) {
                appController.openProject(fileDialog.currentFolder)
            }
        }
    }

    // مدیریت اکشن‌های sidebar
    function handleSidebarAction(action) {
        console.log("Sidebar action:", action)

        if (!appController) {
            console.log("AppController not available, using fallback")
            // Fallback behavior
            switch(action) {
                case "new_project":
                    newProjectDialog.visible = true
                    break
                case "open_project":
                    fileDialog.open()
                    break
                case "settings":
                    settingsDialog.open()
                    break
                case "help":
                    helpDialog.open()
                    break
                case "home":
                    mainContent.currentIndex = 0
                    break
                case "dashboard":
                    mainContent.currentIndex = 2
                    break
                case "nodeeditor":
                    mainContent.currentIndex = 1
                    break
                case "bci":
                    mainContent.currentIndex = 3
                    break
                default:
                    console.warn("Unknown sidebar action:", action)
            }
            return
        }

        switch(action) {
            case "new_project":
                newProjectDialog.visible = true
                break
            case "open_project":
                fileDialog.open()
                break
            case "settings":
                settingsDialog.open()
                break
            case "help":
                helpDialog.open()
                break
            default:
                appController.setCurrentWorkspace(action)
        }
    }

    // مدیریت اکشن‌های سریع
    function handleQuickAction(action) {
        console.log("Quick action:", action)

        if (!appController) {
            console.log("AppController not available, using fallback")
            // Fallback behavior
            switch(action) {
                case "create_paradigm":
                    mainContent.currentIndex = 3 // BCI Paradigms
                    break
                case "open_dashboard":
                    mainContent.currentIndex = 2 // Dashboard
                    break
                case "open_processing":
                    mainContent.currentIndex = 1 // Node Editor
                    break
                case "open_training":
                    mainContent.currentIndex = 1 // Node Editor
                    break
                case "get_started":
                    mainContent.currentIndex = 0 // Home
                    break
            }
            return
        }

        switch(action) {
            case "create_paradigm":
                appController.createNewParadigm()
                break
            case "open_dashboard":
                appController.openDashboard()
                break
            case "open_processing":
                appController.openSignalProcessing()
                break
            case "open_training":
                appController.openModelTraining()
                break
        }
    }

    // تبدیل workspace به index برای StackLayout
    function getWorkspaceIndex(workspace) {
        console.log("Getting index for workspace:", workspace)
        switch(workspace) {
            case "home": return 0
            case "nodeeditor": return 1
            case "dashboard": return 2
            case "bci": return 3
            default:
                console.warn("Unknown workspace:", workspace, "falling back to home")
                return 0
        }
    }

    Component.onCompleted: {
        console.log("BCI Studio Pro initialized successfully!")
        console.log("Current theme:", appTheme.currentTheme)


        // Wait for context property to be available
        if (typeof appController !== "undefined" && appController !== null) {
            appController.initialize()
        } else {
            console.log("Waiting for AppController context property...")
            // Try to get appController from context after a delay
            timer.start()
        }
    }

    Timer {
        id: timer
        interval: 100
        onTriggered: {
            if (typeof appController !== "undefined" && appController !== null) {
                console.log("AppController found via context property")
                mainWindow.appController = appController
                appController.initialize()

                // Auto-hide splash after initialization
                splashScreenTimer.start()
            } else {
                console.log("AppController not available, using fallback")
                // Use fallback behavior
                splashScreenTimer.start()
            }
        }
    }

    Timer {
        id: splashScreenTimer
        interval: 2000
        onTriggered: {
            if (appController) {
                appController.hideSplash()
            } else {
                splashScreen.visible = false
            }
        }
    }

    // Connections برای AppController signals
    Connections {
        target: appController
        enabled: appController !== null

        function onCurrentWorkspaceChanged() {
            console.log("Workspace changed to:", appController.currentWorkspace)
            mainContent.currentIndex = getWorkspaceIndex(appController.currentWorkspace)
        }

        function onShowSplashChanged() {
            console.log("Splash visibility:", appController.showSplash)
            splashScreen.visible = appController.showSplash
        }

        function onCurrentProjectNameChanged() {
            console.log("Project name changed:", appController.currentProjectName)
            updateWindowTitle()
        }

        function onProjectCreated(projectPath) {
            console.log("Project created successfully:", projectPath)
            updateWindowTitle()
        }
    }

    // آپدیت title پنجره
    function updateWindowTitle() {
        var workspaceNames = {
            "home": "Home",
            "dashboard": "Dashboard",
            "nodeeditor": "Node Editor",
            "pipeline": "Pipeline",
            "bci": "BCI Paradigms",
            "analysis": "Data Analysis"
        }

        var currentProject = appController ? appController.currentProjectName : ""
        var projectSuffix = currentProject ? ` - ${currentProject}` : ""
        var workspaceName = workspaceNames[appController ? appController.currentWorkspace : "home"] || "BCI Studio"

        title = `BCI Studio Pro - ${workspaceName}${projectSuffix}`
    }

    // Keyboard shortcuts
    Shortcut {
        sequence: "Ctrl+N"
        onActivated: newProjectDialog.visible = true
    }

    Shortcut {
        sequence: "Ctrl+O"
        onActivated: fileDialog.open()
    }

    Shortcut {
        sequence: "Ctrl+S"
        onActivated: if (appController) appController.saveProject()
    }

    Shortcut {
        sequence: "F1"
        onActivated: helpDialog.open()
    }

    Shortcut {
        sequence: "F11"
        onActivated: mainWindow.visibility === Window.Windowed ?
            mainWindow.showMaximized() : mainWindow.showNormal()
    }

    // Shortcut برای تغییر تم
    Shortcut {
        sequence: "Ctrl+T"
        onActivated: appTheme.toggleTheme()
    }

    // Shortcut برای تم دارک
    Shortcut {
        sequence: "Ctrl+Shift+D"
        onActivated: appTheme.setTheme("dark")
    }

    // Shortcut برای تم لایت
    Shortcut {
        sequence: "Ctrl+Shift+L"
        onActivated: appTheme.setTheme("light")
    }

    // Shortcut برای جمع کردن سایدبار
    Shortcut {
        sequence: "Ctrl+B"
        onActivated: mainSidebar.collapsed = !mainSidebar.collapsed
    }

    // آپدیت shortcutهای مربوط به fullscreen
        Shortcut {
            sequence: "F11"
            onActivated: {
                if (mainWindow.visibility === Window.FullScreen) {
                    mainWindow.visibility = Window.Windowed
                    mainWindow.showMaximized()
                } else {
                    mainWindow.visibility = Window.FullScreen
                }
            }
        }

        Shortcut {
            sequence: "Alt+F4"
            onActivated: mainWindow.close()
        }

        Shortcut {
            sequence: "Alt+Enter"
            onActivated: {
                if (mainWindow.visibility === Window.FullScreen) {
                    mainWindow.visibility = Window.Windowed
                    mainWindow.showMaximized()
                } else {
                    mainWindow.visibility = Window.FullScreen
                }
            }
        }


    // درباره برنامه
    Dialog {
        id: aboutDialog
        title: "About BCI Studio Pro"
        standardButtons: Dialog.Ok
        anchors.centerIn: Overlay.overlay
        width: 400
        height: 300

        background: Rectangle {
            color: theme.backgroundCard
            radius: theme.radius.lg
            border.color: theme.border
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: theme.spacing.md

            Text {
                text: "🧠 BCI Studio Pro"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: theme.typography.h3.size
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Advanced Brain-Computer Interface Platform"
                color: theme.textSecondary
                font.pixelSize: theme.typography.body1.size
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Version 1.0.0"
                color: theme.textSecondary
                font.pixelSize: theme.typography.caption.size
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "© 2024 BCI Studio Team. All rights reserved."
                color: theme.textTertiary
                font.pixelSize: theme.typography.overline.size
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.divider
            }

            Text {
                text: "A powerful platform for EEG signal processing, machine learning, and real-time BCI applications."
                color: theme.textSecondary
                wrapMode: Text.Wrap
                font.pixelSize: theme.typography.body2.size
                Layout.fillWidth: true
            }
        }
    }

    // وضعیت برنامه
    onClosing: {
        if (appController && appController.hasUnsavedChanges) {
            // TODO: Show save changes dialog
            console.log("There are unsaved changes!")
        }
    }
}
