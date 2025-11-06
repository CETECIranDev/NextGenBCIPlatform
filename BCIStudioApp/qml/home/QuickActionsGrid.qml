import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: actionsGrid
    height: gridLayout.height + 40
    radius: 16
    color: appTheme.backgroundCard
    border.color: appTheme.border
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15

        // Header
        Text {
            text: "Quick Actions"
            color: appTheme.textPrimary
            font.family: robotoBold.name
            font.pixelSize: 20
            Layout.fillWidth: true
        }

        // Grid of actions
        GridLayout {
            id: gridLayout
            columns: 2
            rowSpacing: 15
            columnSpacing: 15
            Layout.fillWidth: true

            ActionCard {
                icon: "🧠"
                title: "New BCI Paradigm"
                description: "Create P300, SSVEP, or Motor Imagery experiments"
                color: appTheme.primary
                onClicked: appController.createNewParadigm()
            }

            ActionCard {
                icon: "📊"
                title: "Real-time Dashboard"
                description: "Monitor EEG signals and performance metrics"
                color: appTheme.secondary
                onClicked: appController.openDashboard()
            }

            ActionCard {
                icon: "⚡"
                title: "Signal Processing"
                description: "Filter, analyze and visualize brain signals"
                color: appTheme.accent
                onClicked: appController.openSignalProcessing()
            }

            ActionCard {
                icon: "🎯"
                title: "Model Training"
                description: "Train machine learning models for classification"
                color: appTheme.success
                onClicked: appController.openModelTraining()
            }

            ActionCard {
                icon: "🧩"
                title: "Node Editor"
                description: "Design processing pipelines with visual programming"
                color: appTheme.warning
                onClicked: appController.openNodeEditor()
            }

            ActionCard {
                icon: "📈"
                title: "Data Analysis"
                description: "Advanced statistical analysis and visualization"
                color: appTheme.info
                onClicked: appController.openDataAnalysis()
            }
        }
    }
}