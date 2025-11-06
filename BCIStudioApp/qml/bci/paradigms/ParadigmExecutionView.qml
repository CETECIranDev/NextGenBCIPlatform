import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: executionView
    
    property var theme
    property string activeParadigm: ""
    property var paradigmConfig: ({})
    property var appController
    
    signal backToSelection()

    color: theme.backgroundPrimary

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            height: 60
            color: theme.backgroundSecondary
            
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20

                Button {
                    text: "← Back"
                    onClicked: backToSelection()
                }

                Text {
                    text: "BCI Paradigm: " + activeParadigm
                    color: theme.textPrimary
                    font.bold: true
                    font.pixelSize: theme.typography.h4.size
                    Layout.fillWidth: true
                }

                Button {
                    text: "Start Experiment"
                    highlighted: true
                    onClicked: startExperiment()
                }
            }
        }

        // Content Area
        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            ColumnLayout {
                width: executionView.width
                spacing: 20
                anchors.margins: 20


                // Paradigm-specific configuration
                Loader {
                    id: paradigmConfigLoader
                    Layout.fillWidth: true
                    sourceComponent: getParadigmComponent(activeParadigm)
                    
                    property var config: paradigmConfig
                    property var theme: executionView.theme
                }

                // Common settings
                Rectangle {
                    Layout.fillWidth: true
                    height: 200
                    color: theme.backgroundCard
                    radius: theme.radius.lg
                    
                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15

                        Text {
                            text: "Common Settings"
                            color: theme.textPrimary
                            font.bold: true
                            font.pixelSize: theme.typography.h5.size
                        }

                        GridLayout {
                            columns: 2
                            columnSpacing: 20
                            rowSpacing: 10
                            Layout.fillWidth: true

                            Text { text: "Duration:"; color: theme.textSecondary }
                            TextField { 
                                placeholderText: "Experiment duration (seconds)"
                                text: "300"
                                Layout.fillWidth: true
                            }

                            Text { text: "Sampling Rate:"; color: theme.textSecondary }
                            ComboBox {
                                model: ["250 Hz", "500 Hz", "1000 Hz", "2000 Hz"]
                                currentIndex: 1
                                Layout.fillWidth: true
                            }

                            Text { text: "Data Storage:"; color: theme.textSecondary }
                            CheckBox { text: "Save EEG data"; checked: true }
                        }
                    }
                }
            }
        }
    }

    function getParadigmComponent(paradigmType) {
        switch(paradigmType) {
            case "p300": return p300ConfigComponent
            case "ssvep": return ssvepConfigComponent
            case "motor_imagery": return motorImageryConfigComponent
            default: return customConfigComponent
        }
    }

    function startExperiment() {
        console.log("Starting", activeParadigm, "experiment with config:", paradigmConfig)
        if (appController) {
            appController.startBCIExperiment(activeParadigm, paradigmConfig)
        }
    }

    // Component definitions for different paradigms
    Component {
        id: p300ConfigComponent
        P300ConfigView {
            config: paradigmConfigLoader.config
            theme: paradigmConfigLoader.theme
        }
    }

    Component {
        id: ssvepConfigComponent
        SSVEPConfigView {
            config: paradigmConfigLoader.config
            theme: paradigmConfigLoader.theme
        }
    }

    Component {
        id: motorImageryConfigComponent
        MotorImageryConfigView {
            config: paradigmConfigLoader.config
            theme: paradigmConfigLoader.theme
        }
    }

    // Component {
    //     id: customConfigComponent
    //     CustomParadigmConfigView {
    //         config: paradigmConfigLoader.config
    //         theme: paradigmConfigLoader.theme
    //     }
    // }
}
