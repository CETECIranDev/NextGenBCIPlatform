import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects  // برای Qt 6
import "./components"

Rectangle {
    id: selectionView

    property var theme
    signal paradigmSelected(string paradigmType)

    color: "transparent"

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header Section
        Rectangle {
            Layout.fillWidth: true
            height: 120
            color: "transparent"

            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(width, 0)
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#7C4DFF" }
                    GradientStop { position: 1.0; color: "#00BFA5" }
                }
                opacity: 0.1
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: 40
                anchors.rightMargin: 40
                spacing: 8

                Text {
                    text: "🧠 BCI PARADIGM MANAGER"
                    color: "white"
                    font.bold: true
                    font.pixelSize: 28
                    font.family: "Segoe UI"
                    font.letterSpacing: 2
                }

                Text {
                    text: "Enterprise Brain-Computer Interface Platform"
                    color: "#AAAAAA"
                    font.pixelSize: 14
                    font.family: "Segoe UI"
                }

                Text {
                    text: "Select an experimental paradigm to begin"
                    color: "#666677"
                    font.pixelSize: 12
                    font.family: "Segoe UI"
                }
            }
        }

        // Main Content
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            ScrollView {
                anchors.fill: parent
                anchors.margins: 30

                ColumnLayout {
                    width: selectionView.width - 60
                    spacing: 25

                    // Quick Access Cards
                    Text {
                        text: "QUICK ACCESS"
                        color: "#7C4DFF"
                        font.bold: true
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        font.letterSpacing: 1
                    }

                    GridLayout {
                        columns: 2
                        columnSpacing: 20
                        rowSpacing: 20
                        Layout.fillWidth: true

                        // P300 Card
                        ParadigmAccessCard {
                            title: "P300 Speller"
                            description: "Visual evoked potential for character spelling interface"
                            icon: "🔤"
                            color: "#7C4DFF"
                            opacity: 0.4
                            stats: "6×6 Grid • 92% Accuracy"
                            status: "Ready"
                            statusColor: "#00C853"
                            Layout.fillWidth: true
                            onClicked: paradigmSelected("p300")
                        }

                        // SSVEP Card
                        ParadigmAccessCard {
                            title: "SSVEP"
                            description: "Steady-state visual evoked potential for frequency control"
                            icon: "📊"
                            color: "#00BFA5"

                            stats: "4 Frequencies • 85% Detection"
                            status: "Calibrated"
                            statusColor: "#00C853"
                            Layout.fillWidth: true
                            onClicked: paradigmSelected("ssvep")
                        }

                        // Motor Imagery Card
                        ParadigmAccessCard {
                            title: "Motor Imagery"
                            description: "Movement imagination for motor cortex activation"
                            icon: "💪"
                            color: "#FF6D00"
                            stats: "2 Classes • 88% Accuracy"
                            status: "Ready"
                            statusColor: "#00C853"
                            Layout.fillWidth: true
                            onClicked: paradigmSelected("motor_imagery")
                        }

                        // ERP Analysis Card
                        ParadigmAccessCard {
                            title: "ERP Analysis"
                            description: "Event-related potential component analysis"
                            icon: "⚡"
                            color: "#2962FF"
                            stats: "Multi-Component • Research"
                            status: "Advanced"
                            statusColor: "#7C4DFF"
                            Layout.fillWidth: true
                            onClicked: paradigmSelected("erp")
                        }
                    }

                    // Recent Experiments
                    Text {
                        text: "RECENT EXPERIMENTS"
                        color: "#7C4DFF"
                        font.bold: true
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        font.letterSpacing: 1
                        Layout.topMargin: 20
                    }

                    RecentExperimentsList {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 120
                    }

                    // System Status
                    Text {
                        text: "SYSTEM STATUS"
                        color: "#7C4DFF"
                        font.bold: true
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                        font.letterSpacing: 1
                        Layout.topMargin: 20
                    }

                    SystemStatusPanel {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 80
                    }
                }
            }
        }
    }
}
