import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt5Compat.GraphicalEffects



Rectangle {
    id: pipelineInfoPanel
    color: appTheme.backgroundSecondary
    radius: 12

    property var nodeGraph: null
    property bool isValid: false
    property bool isExecutable: false
    property int nodeCount: nodeGraph ? nodeGraph.nodes.length : 0
    property int connectionCount: nodeGraph ? nodeGraph.connections.length : 0
    property string pipelineStatus: "Ready"
    property real executionTime: 0.0
    property real memoryUsage: 0.0
    property int warningCount: 0
    property int errorCount: 0

    signal pipelineValidationRequested()
    signal pipelineAnalysisRequested()
    signal pipelineOptimizationRequested()
    signal pipelineExportRequested()

    // Shadow effect
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 2
        radius: 8
        samples: 17
        color: "#20000000"
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Rectangle {
                width: 40
                height: 40
                radius: 8
                color: getStatusColor()
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: getStatusIcon()
                    font.pixelSize: 18
                    color: "white"
                    anchors.centerIn: parent
                }
            }

            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true

                Text {
                    text: "Pipeline Overview"
                    color: appTheme.textPrimary
                    font.family: "Segoe UI Semibold"
                    font.pixelSize: 16
                    font.weight: Font.DemiBold
                }

                Text {
                    text: getStatusDescription()
                    color: appTheme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 12
                }
            }
        }

        // Stats Grid
        GridLayout {
            columns: 2
            columnSpacing: 12
            rowSpacing: 12
            Layout.fillWidth: true

            // Nodes Count
            StatCard {
                title: "NODES"
                value: nodeCount.toString()
                icon: "🧩"
                color: appTheme.primary
                trend: nodeCount > 0 ? "good" : "neutral"
                tooltip: "Total nodes in pipeline"
            }

            // Connections Count
            StatCard {
                title: "CONNECTIONS"
                value: connectionCount.toString()
                icon: "🔗"
                color: appTheme.secondary
                trend: connectionCount > 0 ? "good" : "neutral"
                tooltip: "Total connections between nodes"
            }

            // Execution Time
            StatCard {
                title: "TIME (ms)"
                value: executionTime.toFixed(1)
                icon: "⏱️"
                color: appTheme.info
                trend: executionTime < 100 ? "good" : executionTime < 500 ? "warning" : "bad"
                tooltip: "Estimated execution time"
            }

            // Memory Usage
            StatCard {
                title: "MEMORY (MB)"
                value: memoryUsage.toFixed(1)
                icon: "💾"
                color: appTheme.warning
                trend: memoryUsage < 50 ? "good" : memoryUsage < 200 ? "warning" : "bad"
                tooltip: "Estimated memory usage"
            }

            // Warnings
            StatCard {
                title: "WARNINGS"
                value: warningCount.toString()
                icon: "⚠️"
                color: appTheme.warning
                trend: warningCount === 0 ? "good" : "warning"
                tooltip: "Pipeline warnings"
            }

            // Errors
            StatCard {
                title: "ERRORS"
                value: errorCount.toString()
                icon: "❌"
                color: appTheme.error
                trend: errorCount === 0 ? "good" : "bad"
                tooltip: "Pipeline errors"
            }
        }

        // Pipeline Status
        Rectangle {
            Layout.fillWidth: true
            height: 60
            radius: 8
            color: appTheme.backgroundCard
            border.color: getStatusColor()
            border.width: 2

            RowLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                Rectangle {
                    width: 36
                    height: 36
                    radius: 18
                    color: getStatusColor()

                    Text {
                        text: getStatusBadgeIcon()
                        font.pixelSize: 16
                        color: "white"
                        anchors.centerIn: parent
                    }
                }

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true

                    Text {
                        text: pipelineStatus
                        color: getStatusColor()
                        font.family: "Segoe UI Semibold"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: getStatusDetails()
                        color: appTheme.textSecondary
                        font.family: "Segoe UI"
                        font.pixelSize: 11
                        wrapMode: Text.WordWrap
                    }
                }

                Text {
                    text: isValid ? "✓ VALID" : "✗ INVALID"
                    color: isValid ? appTheme.success : appTheme.error
                    font.family: "Segoe UI"
                    font.pixelSize: 10
                    font.weight: Font.Bold
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }

        // Action Buttons
        GridLayout {
            columns: 2
            columnSpacing: 8
            rowSpacing: 8
            Layout.fillWidth: true

            ActionButton {
                text: "Validate"
                icon: "✓"
                accent: false
                enabled: nodeCount > 0
                Layout.fillWidth: true
                onClicked: pipelineInfoPanel.pipelineValidationRequested()
            }

            ActionButton {
                text: "Analyze"
                icon: "📊"
                accent: false
                enabled: nodeCount > 0
                Layout.fillWidth: true
                onClicked: pipelineInfoPanel.pipelineAnalysisRequested()
            }

            ActionButton {
                text: "Optimize"
                icon: "⚡"
                accent: false
                enabled: nodeCount > 0 && isValid
                Layout.fillWidth: true
                onClicked: pipelineInfoPanel.pipelineOptimizationRequested()
            }

            ActionButton {
                text: "Export"
                icon: "📤"
                accent: true
                enabled: nodeCount > 0 && isValid
                Layout.fillWidth: true
                onClicked: pipelineInfoPanel.pipelineExportRequested()
            }
        }

        // Progress Bar for Analysis
        ProgressBar {
            id: analysisProgress
            value: 0
            visible: false
            Layout.fillWidth: true

            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 6
                color: appTheme.backgroundTertiary
                radius: 3
            }

            contentItem: Rectangle {
                implicitWidth: 200
                implicitHeight: 6

                Rectangle {
                    width: parent.width * parent.parent.visualPosition
                    height: parent.height
                    radius: 3
                    color: appTheme.primary
                }
            }
        }

        // Analysis Results
        ColumnLayout {
            spacing: 8
            Layout.fillWidth: true
            visible: analysisResults.visible

            Text {
                text: "Analysis Results"
                color: appTheme.textPrimary
                font.family: "Segoe UI Semibold"
                font.pixelSize: 14
                font.weight: Font.DemiBold
                Layout.fillWidth: true
            }

            Rectangle {
                id: analysisResults
                Layout.fillWidth: true
                implicitHeight: resultsColumn.height + 16
                radius: 8
                color: appTheme.backgroundCard
                border.color: appTheme.border
                border.width: 1
                visible: false

                ColumnLayout {
                    id: resultsColumn
                    width: parent.width - 16
                    anchors.centerIn: parent
                    spacing: 8

                    AnalysisResultItem {
                        label: "Performance Score"
                        value: "85%"
                        color: appTheme.success
                        icon: "🚀"
                    }

                    AnalysisResultItem {
                        label: "Bottleneck Detected"
                        value: "Bandpass Filter"
                        color: appTheme.warning
                        icon: "⏱️"
                    }

                    AnalysisResultItem {
                        label: "Memory Efficiency"
                        value: "92%"
                        color: appTheme.success
                        icon: "💾"
                    }

                    AnalysisResultItem {
                        label: "Parallelization Potential"
                        value: "High"
                        color: appTheme.info
                        icon: "🔀"
                    }
                }
            }
        }
    }

    // Custom Components
    component StatCard: Rectangle {
        property string title: ""
        property string value: "0"
        property string icon: "⚙️"
        //property color color: appTheme.primary
        property string trend: "neutral" // good, warning, bad, neutral
        property string tooltip: ""

        height: 60
        radius: 8
        color: appTheme.backgroundCard
        border.color: appTheme.border
        border.width: 1

        RowLayout {
            anchors.fill: parent
            anchors.margins: 8
            spacing: 8

            // Icon
            Rectangle {
                width: 32
                height: 32
                radius: 6
                color: parent.parent.color
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: parent.parent.icon
                    font.pixelSize: 14
                    color: "white"
                    anchors.centerIn: parent
                }
            }

            // Content
            ColumnLayout {
                spacing: 2
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: parent.parent.title
                    color: appTheme.textTertiary
                    font.family: "Segoe UI"
                    font.pixelSize: 9
                    font.weight: Font.Medium
                    font.letterSpacing: 0.5
                }

                RowLayout {
                    spacing: 4
                    Layout.fillWidth: true

                    Text {
                        text: parent.parent.value
                        color: appTheme.textPrimary
                        font.family: "Segoe UI Semibold"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold
                    }

                    // Trend indicator
                    Text {
                        text: {
                            switch(parent.parent.trend) {
                                case "good": return "↗";
                                case "warning": return "➡";
                                case "bad": return "↘";
                                default: return "";
                            }
                        }
                        color: {
                            switch(parent.parent.trend) {
                                case "good": return appTheme.success;
                                case "warning": return appTheme.warning;
                                case "bad": return appTheme.error;
                                default: return "transparent";
                            }
                        }
                        font.pixelSize: 12
                        visible: parent.parent.trend !== "neutral"
                        Layout.alignment: Qt.AlignRight
                    }
                }
            }
        }

        ToolTip {
            text: parent.tooltip
            delay: 500
            visible: statMouseArea.containsMouse
        }

        MouseArea {
            id: statMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
        }
    }

    component ActionButton: Rectangle {
        property string text: ""
        property string icon: ""
        property bool accent: false
        property bool enabled: true

        height: 36
        radius: 6
        color: {
            if (!enabled) return Qt.rgba(appTheme.textDisabled.r, appTheme.textDisabled.g, appTheme.textDisabled.b, 0.1)
            return mouseArea.containsPress ?
                   (accent ? Qt.darker(appTheme.error, 1.2) : Qt.darker(appTheme.primary, 1.2)) :
                   (accent ? appTheme.error : appTheme.primary)
        }
        opacity: enabled ? 1.0 : 0.5

        RowLayout {
            anchors.centerIn: parent
            spacing: 6

            Text {
                text: parent.parent.icon
                font.pixelSize: 12
                color: "white"
            }

            Text {
                text: parent.parent.text
                color: "white"
                font.family: "Segoe UI"
                font.pixelSize: 11
                font.weight: Font.Medium
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: parent.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
            onClicked: if (parent.enabled) parent.clicked()
        }

        signal clicked()

        Behavior on color {
            ColorAnimation { duration: 200 }
        }

        Behavior on opacity {
            NumberAnimation { duration: 200 }
        }
    }

    component AnalysisResultItem: RowLayout {
        property string label: ""
        property string value: ""
        property color color: appTheme.primary
        property string icon: ""

        spacing: 8
        Layout.fillWidth: true

        Text {
            text: parent.icon
            font.pixelSize: 12
            color: parent.color
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: parent.label
            color: appTheme.textSecondary
            font.family: "Segoe UI"
            font.pixelSize: 11
            Layout.fillWidth: true
        }

        Text {
            text: parent.value
            color: parent.color
            font.family: "Segoe UI Semibold"
            font.pixelSize: 11
            font.weight: Font.DemiBold
            Layout.alignment: Qt.AlignRight
        }
    }

    // Helper functions
    function getStatusColor() {
        switch(pipelineStatus) {
            case "Ready": return appTheme.success;
            case "Valid": return appTheme.success;
            case "Executable": return appTheme.success;
            case "Warning": return appTheme.warning;
            case "Error": return appTheme.error;
            case "Processing": return appTheme.info;
            case "Analyzing": return appTheme.info;
            default: return appTheme.textTertiary;
        }
    }

    function getStatusIcon() {
        switch(pipelineStatus) {
            case "Ready": return "✅";
            case "Valid": return "✓";
            case "Executable": return "⚡";
            case "Warning": return "⚠️";
            case "Error": return "❌";
            case "Processing": return "🔄";
            case "Analyzing": return "📊";
            default: return "ℹ️";
        }
    }

    function getStatusBadgeIcon() {
        switch(pipelineStatus) {
            case "Ready": return "✅";
            case "Valid": return "✓";
            case "Executable": return "🚀";
            case "Warning": return "⚠️";
            case "Error": return "💥";
            case "Processing": return "⚡";
            case "Analyzing": return "🔍";
            default: return "📋";
        }
    }

    function getStatusDescription() {
        if (nodeCount === 0) return "Add nodes to create a pipeline"

        switch(pipelineStatus) {
            case "Ready": return "Pipeline is ready for execution";
            case "Valid": return "Pipeline validation successful";
            case "Executable": return "Ready to execute BCI pipeline";
            case "Warning": return "Pipeline has warnings";
            case "Error": return "Pipeline contains errors";
            case "Processing": return "Processing pipeline data";
            case "Analyzing": return "Analyzing pipeline performance";
            default: return "Pipeline status unknown";
        }
    }

    function getStatusDetails() {
        if (nodeCount === 0) return "No nodes in pipeline"

        var details = []
        if (errorCount > 0) details.push(errorCount + " errors")
        if (warningCount > 0) details.push(warningCount + " warnings")
        if (details.length === 0) details.push("No issues detected")

        return details.join(" • ")
    }

    function startAnalysis() {
        pipelineStatus = "Analyzing"
        analysisProgress.visible = true
        analysisProgress.value = 0
        analysisResults.visible = false
    }

    function updateAnalysisProgress(progress) {
        analysisProgress.value = progress
    }

    function completeAnalysis(result) {
        analysisProgress.visible = false
        analysisResults.visible = true

        pipelineStatus = result.valid ? "Valid" : "Error"
        isValid = result.valid
        isExecutable = result.executable
        executionTime = result.estimatedTime || 0
        memoryUsage = result.memoryUsage || 0
        warningCount = result.warningCount || 0
        errorCount = result.errorCount || 0
    }

    function validatePipeline() {
        pipelineStatus = "Processing"
        // Simulate validation process
        setTimeout(function() {
            var valid = nodeCount > 0 && connectionCount >= nodeCount - 1
            pipelineStatus = valid ? "Valid" : "Error"
            isValid = valid
            isExecutable = valid
            warningCount = valid ? 0 : 1
            errorCount = valid ? 0 : 1
        }, 1000)
    }

    // Animations
    Behavior on nodeCount {
        NumberAnimation { duration: 300 }
    }

    Behavior on connectionCount {
        NumberAnimation { duration: 300 }
    }

    Behavior on pipelineStatus {
        PropertyAnimation { duration: 200 }
    }

    Behavior on executionTime {
        NumberAnimation { duration: 400 }
    }

    Behavior on memoryUsage {
        NumberAnimation { duration: 400 }
    }

    Component.onCompleted: {
        console.log("PipelineInfoPanel initialized")
        // Initialize with current graph state
        if (nodeGraph) {
            nodeCount = nodeGraph.nodes.length
            connectionCount = nodeGraph.connections.length
        }
    }
}
