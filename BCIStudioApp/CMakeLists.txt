cmake_minimum_required(VERSION 3.16)

project(BCIAstudioApp VERSION 1.0.0 LANGUAGES CXX)

# تنظیمات پایه
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# تنظیمات Qt
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# پیدا کردن Qt6
find_package(Qt6 REQUIRED COMPONENTS
    Core
    Quick
    Qml
    Network
    Concurrent
    Multimedia
    QuickControls2
    Core5Compat
)

# ایجاد executable
qt_add_executable(BCIStudioApp
    main.cpp
    src/AppController.cpp
    src/MainWindow.cpp
    qml/dashboard/CognitiveGauge_copy.qml
    qml/SplashScreen_copy.qml
)

# لینک کتابخانه‌ها
target_link_libraries(BCIStudioApp PRIVATE
    CoreLib
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Network
    Qt6::Concurrent
    Qt6::Core5Compat  # برای GraphicalEffects

)

# منابع QML و تصاویر
qt_add_resources(BCIStudioApp "app_resources"
    PREFIX "/"
    FILES
        resources.qrc
)

# منابع QML
qt_add_resources(BCIStudioApp "qml_resources"
    PREFIX "/"
    FILES
        qml/main.qml

        qml/core/AppWindow.qml
        qml/core/NavigationSidebar.qml
        qml/core/WorkspaceHeader.qml
        qml/core/NeuroHeader.qml
        qml/core/NeuroSidebar.qml
        qml/core/NeuroTheme.qml
        qml/core/StatusBar.qml
        qml/core/PropertiesPanel.qml
        qml/core/Theme.qml
        qml/core/ToolTip.qml
        qml/core/VersionInfo.qml
        qml/core/ToolTip.qml
        qml/core/SystemStatusMini.qml
        qml/core/StatusIndicatorMini.qml
        qml/core/NeuroStatusBar.qml
        qml/core/SearchField.qml
        qml/core/SidebarHeader.qml
        qml/core/SidebarSection.qml
        qml/core/SidebarItem.qml
        qml/core/NewProjectDialog.qml
        qml/core/StepIndicator.qml
        qml/core/SummaryItem.qml
        qml/core/ProjectTypeCard.qml
        qml/core/NavigationButton.qml
        qml/core/Card.qml
        qml/core/ThemeManager.qml
        qml/core/ThemeSwitcher.qml
        qml/core/themes/DarkTheme.qml
        qml/core/themes/LightTheme.qml
        qml/core/NeuroNavItem.qml
        qml/core/NeuroIconButton.qml
        qml/core/SidebarButton.qml
        qml/core/GlassEffect.qml

        qml/settings/SettingsPage.qml



        qml/common/Card.qml
        # qml/common/Dialog.qml
        qml/common/SearchBox.qml
        qml/common/Toolbox.qml
        qml/common/CheckBox.qml
        qml/common/ComboBox.qml
        qml/common/SearchBox.qml
        qml/common/Toolbox.qml
        qml/common/ThemedCard.qml
        qml/common/MaterialButton.qml
        qml/common/MaterialCard.qml
        qml/common/MaterialTextField.qml
        qml/common/MaterialToolTip.qml
        qml/common/EnterpriseToolBar.qml
        qml/common/ControlPanel.qml
        qml/common/ControlSection.qml
        qml/common/StatusIndicator.qml
        qml/common/GlassCard.qml
        qml/common/IconButton.qml
        qml/common/FlatButton.qml
        qml/common/GlassButton.qml
        qml/common/RecordButton.qml

        qml/models/DashboardModel.qml

        qml/dashboard/Card.qml
        qml/dashboard/CognitiveGaugesCard.qml
        qml/dashboard/EventLogCard.qml
        qml/dashboard/LiveSignalCard.qml
        qml/dashboard/MainOutputCard.qml
        qml/dashboard/SignalQualityMapCard.qml
        qml/dashboard/SpectrumCard.qml
        qml/dashboard/MetricItem.qml
        qml/dashboard/DashboardCard.qml
        qml/dashboard/DashboardHeaderCard.qml
        qml/dashboard/FloatingActionButton.qml
        qml/dashboard/QuickStatCard.qml
        qml/dashboard/InfoItem.qml
        qml/dashboard/FpsCounter.qml

        qml/dashboard/CognitiveTrendAnalysis.qml
        qml/dashboard/AdvancedCognitiveMetricsCard.qml
        qml/dashboard/DashboardWidgetLoader.qml
        qml/dashboard/EmptyDashboardState.qml
        qml/dashboard/LiveMetricPill.qml
        qml/dashboard/WidgetConfigPanel.qml
        qml/dashboard/DraggableWidget.qml
        qml/dashboard/QualityDistributionItem.qml
        qml/dashboard/AdvancedHeadMap.qml
        qml/dashboard/WidgetListItem.qml
        qml/dashboard/SuccessToast.qml
        qml/dashboard/CategoryTab.qml
        qml/dashboard/WidgetCard.qml
        qml/dashboard/EmptyState.qml
        qml/dashboard/PrimaryButton.qml
        qml/dashboard/SecondaryButton.qml
        qml/dashboard/QualityMetric.qml
        qml/dashboard/MapControlButton.qml
        qml/dashboard/QualityDistributionPill.qml
        qml/dashboard/RegionalQualityCompact.qml
        qml/dashboard/MapControlButton.qml




        qml/SplashScreen.qml
        qml/AdvancedLoadingIndicator.qml
        qml/BrainLogo.qml
        qml/StatusItem.qml
        qml/TypeWriterText.qml
        qml/NeuralNetworkBackground.qml



        qml/dashboard/Card.qml
        qml/dashboard/ClassificationResultsCard.qml
        qml/dashboard/DashboardView.qml
        qml/dashboard/MultiChannelSignalCard.qml
        qml/dashboard/PipelineStatusCard.qml
        qml/dashboard/QuickControlsCard.qml
        qml/dashboard/RealTimeMetricsCard.qml
        qml/dashboard/RealTimeSignalWidget.qml
        qml/dashboard/SpectralAnalysisCard.qml
        qml/dashboard/SystemHealthCard.qml
        qml/dashboard/TopographicMapCard.qml
        qml/dashboard/CognitiveGauge.qml
        qml/dashboard/SystemStatusCard.qml
        qml/dashboard/SystemHealthCard.qml
        qml/dashboard/StatusIndicator.qml
        qml/dashboard/ElectrodeItem.qml
        qml/dashboard/RegionalQualityItem.qml
        qml/dashboard/AdvancedMetricItem.qml
        qml/dashboard/LogEntryDelegate.qml

        qml/dashboard/AdvancedCognitiveMetricsCard.qml
        qml/dashboard/AdvancedHeadMap.qml
        qml/dashboard/AdvancedMetricItem.qml
        qml/dashboard/QualityMetricCompact.qml
        qml/dashboard/QualityDistributionBar.qml
        qml/dashboard/MapControlButtonEnterprise.qml
        qml/dashboard/RegionalQualityBar.qml
        qml/dashboard/ElectrodeItemEnterprise.qml

        qml/dashboard/ActionButton.qml
        qml/dashboard/CommandChip.qml
        qml/dashboard/MetricTile.qml
        qml/dashboard/StatusPill.qml
        qml/dashboard/MetricGauge.qml
        qml/dashboard/LiveSignalCard.qml




        qml/home/ActionCard.qml
        qml/home/HomeScreen.qml
        qml/home/ProjectItem.qml
        qml/home/QuickActionsGrid.qml
        qml/home/RecentProjectsCard.qml
        qml/home/StatBadge.qml
        qml/home/WelcomeCard.qml
        qml/home/SystemStatusCard.qml
        qml/home/StatusIndicator.qml


        qml/dashboard/DashboardView.qml
        qml/dashboard/SystemHealthCard.qml
        qml/dashboard/RealTimeMetricsCard.qml
        qml/dashboard/MultiChannelSignalCard.qml
        qml/dashboard/SpectralAnalysisCard.qml
        qml/dashboard/TopographicMapCard.qml
        qml/dashboard/ClassificationResultsCard.qml
        qml/dashboard/PipelineStatusCard.qml
        qml/dashboard/QuickControlsCard.qml

        qml/dashboard/PerformanceMetricsCard.qml
        qml/dashboard/CognitiveStateCard.qml
        qml/dashboard/RealTimeSpectrumCard.qml
        qml/dashboard/PieChart.qml
        qml/dashboard/CognitiveMetric.qml





        qml/nodeeditor/NodeSearchPanel.qml
        qml/nodeeditor/NodeEditorView.qml
        qml/nodeeditor/NodeToolbox.qml
        qml/nodeeditor/NodeCanvas.qml
        qml/nodeeditor/NodeItem.qml
        qml/nodeeditor/NodePort.qml
        qml/nodeeditor/ConnectionItem.qml
        qml/nodeeditor/NodeSearchPanel.qml
        qml/nodeeditor/NodeCategoryPanel.qml
        qml/nodeeditor/NodeToolboxItem.qml
        qml/nodeeditor/NodeContextMenu.qml
        qml/nodeeditor/CanvasContextMenu.qml
        qml/nodeeditor/NodePropertiesPanel.qml
        qml/nodeeditor/NodeEditorToolbar.qml
        qml/nodeeditor/NodeInfoPanel.qml
        qml/nodeeditor/NodeCategoryTabs.qml
        qml/nodeeditor/CategoryButton.qml
        qml/nodeeditor/SearchBox.qml
        qml/nodeeditor/Card.qml
        qml/nodeeditor/PipelineInfoPanel.qml
        qml/nodeeditor/ParameterRow.qml
        qml/nodeeditor/PortItem.qml
        qml/nodeeditor/NodeEditorToolbar.qml
        qml/nodeeditor/InfoCard.qml
        qml/nodeeditor/CategoryPill.qml
        qml/nodeeditor/NodeToolboxCard.qml
        qml/nodeeditor/ParameterEditor.qml
        qml/nodeeditor/CustomActionButton.qml
        qml/nodeeditor/EmptyStatePanel.qml
        qml/nodeeditor/StatusBadge.qml

        qml/pipeline/PipelineExecutorView.qml
        qml/pipeline/PipelineControls.qml


        qml/bci/BCIExperimentController.qml
        qml/bci/BCIParadigmManager.qml
        qml/bci/paradigms/MotorImageryConfigView.qml
        qml/bci/paradigms/P300ConfigView.qml
        qml/bci/paradigms/ParadigmCard.qml
        qml/bci/paradigms/ParadigmConfigFactory.qml
        qml/bci/paradigms/ParadigmExecutionView.qml
        qml/bci/paradigms/ParadigmSelectionView.qml
        qml/bci/paradigms/SSVEPConfigView.qml
        qml/bci/paradigms/ModernParadigmCard.qml
        qml/bci/paradigms/StatItem.qml
        qml/bci/paradigms/StatBox.qml
        qml/bci/paradigms/EnterpriseP300View.qml
        qml/bci/paradigms/EnterpriseSSVEPView.qml
        qml/bci/paradigms/EnterpriseMotorImageryView.qml
        qml/bci/paradigms/SSVEPSignalVisualizer.qml

        qml/bci/paradigms/components/P300ControlPanel.qml
        qml/bci/paradigms/components/LegendItem.qml
        qml/bci/paradigms/components/FlatButton.qml
        qml/bci/paradigms/components/SettingItem.qml
        qml/bci/paradigms/components/SystemInfoItem.qml
        qml/bci/paradigms/components/P300EEGVisualizer.qml
        qml/bci/paradigms/components/P300GridItem.qml
        qml/bci/paradigms/components/P300GridVisualization.qml
        qml/bci/paradigms/components/P300PerformanceMetrics.qml
        qml/bci/paradigms/components/P300TopBar.qml
        qml/bci/paradigms/components/P300ERPVisualizer.qml
        qml/bci/paradigms/components/P300FlashController.qml
        qml/bci/paradigms/components/ParadigmAccessCard.qml
        qml/bci/paradigms/components/RecentExperimentItem.qml
        qml/bci/paradigms/components/RecentExperimentsList.qml
        qml/bci/paradigms/components/StatusBadge.qml
        qml/bci/paradigms/components/StatusIndicator.qml
        qml/bci/paradigms/components/SystemStatusPanel.qml
        qml/bci/paradigms/components/BrainActivationMap.qml
        qml/bci/paradigms/components/MotorImageryControlPanel.qml
        qml/bci/paradigms/components/MotorImageryTopBar.qml
        qml/bci/paradigms/components/CueVisualization.qml
        qml/bci/paradigms/components/IndustrialIconButton.qml
        qml/bci/paradigms/components/LiveMetric.qml
        qml/bci/paradigms/components/SignalInfoItem.qml
        qml/bci/paradigms/components/StatDetail.qml
        qml/bci/paradigms/components/PerformanceGauge.qml
        qml/bci/paradigms/components/SSVEPPerformanceMetrics.qml
        qml/bci/paradigms/components/FrequencyAccuracy.qml
        qml/bci/paradigms/components/FrequencySpectrum.qml
        qml/bci/paradigms/components/PerformanceMetric.qml
        qml/bci/paradigms/components/SummaryItem.qml
        qml/bci/paradigms/components/SSVEPTarget.qml
        qml/bci/paradigms/components/MotorImageryExperimentController.qml
        qml/bci/paradigms/components/MotorImageryEEGVisualizer.qml
        qml/bci/paradigms/components/MotorImageryControlPanel.qml
        qml/bci/paradigms/components/MotorImageryPerformanceMetrics.qml
        qml/bci/paradigms/components/CSPPatternsVisualizer.qml




)

# منابع استاتیک
qt_add_resources(BCIStudioApp "app_resources"
    PREFIX "/resources"
    FILES
        # resources/icons/app_icon.png
        # resources/fonts/Roboto-Regular.ttf
)

# تنظیمات include
target_include_directories(BCIStudioApp PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/../CoreLib/include
)

# تعریف ماکروها
target_compile_definitions(BCIStudioApp PRIVATE
    APP_VERSION="${PROJECT_VERSION}"
    APP_NAME="BCI Studio Pro"
)

# نصب
install(TARGETS BCIStudioApp
    RUNTIME DESTINATION bin
    BUNDLE DESTINATION bin
)
