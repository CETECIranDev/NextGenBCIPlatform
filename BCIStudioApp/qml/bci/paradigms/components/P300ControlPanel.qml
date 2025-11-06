import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: controlPanel

    property bool experimentRunning: false
    property int currentTrial: 0
    property int totalTrials: 120
    property real accuracy: 0.92
    property string status: "Ready"

    signal startExperiment()
    signal pauseExperiment()
    signal stopExperiment()
    signal backRequested()

    width: 320
    color: "#1A1A2E"
    border.color: "#2D2D3E"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Header
        Rectangle {
            Layout.fillWidth: true
            height: 70
            color: "#7C4DFF"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                spacing: 12

                Text {
                    text: "🔤"
                    font.pixelSize: 24
                }

                ColumnLayout {
                    spacing: 2
                    Layout.fillWidth: true

                    Text {
                        text: "P300 CONTROLLER"
                        color: "white"
                        font.bold: true
                        font.pixelSize: 16
                        font.family: "Segoe UI"
                    }

                    Text {
                        text: "Character Spelling Interface"
                        color: "#E0E0FF"
                        font.pixelSize: 11
                        font.family: "Segoe UI"
                    }
                }
            }
        }

        // Main Content
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            // Status Card
            Rectangle {
                Layout.fillWidth: true
                height: 80
                radius: 8
                color: "#252540"
                border.color: "#333344"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    // Status Indicator
                    Rectangle {
                        width: 8
                        height: 8
                        radius: 4
                        color: experimentRunning ? "#00C853" : "#666677"

                        SequentialAnimation on opacity {
                            running: experimentRunning
                            loops: Animation.Infinite
                            NumberAnimation { from: 0.7; to: 1.0; duration: 1000 }
                            NumberAnimation { from: 1.0; to: 0.7; duration: 1000 }
                        }
                    }

                    ColumnLayout {
                        spacing: 4
                        Layout.fillWidth: true

                        Text {
                            text: "STATUS"
                            color: "#AAAAAA"
                            font.pixelSize: 11
                            font.bold: true
                            font.family: "Segoe UI"
                        }

                        Text {
                            text: experimentRunning ? "RUNNING" : "READY"
                            color: experimentRunning ? "#00C853" : "white"
                            font.bold: true
                            font.pixelSize: 16
                            font.family: "Segoe UI"
                        }
                    }

                    ColumnLayout {
                        spacing: 4

                        Text {
                            text: "TRIAL"
                            color: "#AAAAAA"
                            font.pixelSize: 11
                            font.bold: true
                            font.family: "Segoe UI"
                        }

                        Text {
                            text: currentTrial + "/" + totalTrials
                            color: "white"
                            font.bold: true
                            font.pixelSize: 16
                            font.family: "Segoe UI"
                        }
                    }
                }
            }

            // Control Buttons
            ColumnLayout {
                spacing: 10
                Layout.fillWidth: true

                FlatButton {
                    text: experimentRunning ? "⏸️ PAUSE EXPERIMENT" : "🚀 START EXPERIMENT"
                    backgroundColor: experimentRunning ? "#FFA000" : "#00C853"
                    textColor: "white"
                    Layout.fillWidth: true
                    onClicked: experimentRunning ? pauseExperiment() : startExperiment()
                }

                FlatButton {
                    text: "⏹️ STOP EXPERIMENT"
                    backgroundColor: "#F44336"
                    textColor: "white"
                    Layout.fillWidth: true
                    onClicked: stopExperiment()
                }

                FlatButton {
                    text: "← BACK TO SELECTION"
                    backgroundColor: "#333344"
                    textColor: "#AAAAAA"
                    Layout.fillWidth: true
                    onClicked: backRequested()
                }
            }

            // Progress Section
            Rectangle {
                Layout.fillWidth: true
                height: 100
                radius: 8
                color: "#252540"
                border.color: "#333344"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 8

                    Text {
                        text: "PROGRESS"
                        color: "#7C4DFF"
                        font.bold: true
                        font.pixelSize: 12
                        font.family: "Segoe UI"
                    }

                    // Trial Progress
                    ColumnLayout {
                        spacing: 4
                        Layout.fillWidth: true

                        RowLayout {
                            Text {
                                text: "Trial Completion"
                                color: "#AAAAAA"
                                font.pixelSize: 11
                                font.family: "Segoe UI"
                                Layout.fillWidth: true
                            }

                            Text {
                                text: Math.floor((currentTrial / totalTrials) * 100) + "%"
                                color: "white"
                                font.bold: true
                                font.pixelSize: 11
                                font.family: "Segoe UI"
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 6
                            radius: 3
                            color: "#333344"

                            Rectangle {
                                width: parent.width * (currentTrial / totalTrials)
                                height: parent.height
                                radius: 3
                                color: "#7C4DFF"
                            }
                        }
                    }

                    // Accuracy Progress
                    ColumnLayout {
                        spacing: 4
                        Layout.fillWidth: true

                        RowLayout {
                            Text {
                                text: "Classification Accuracy"
                                color: "#AAAAAA"
                                font.pixelSize: 11
                                font.family: "Segoe UI"
                                Layout.fillWidth: true
                            }

                            Text {
                                text: Math.floor(accuracy * 100) + "%"
                                color: accuracy > 0.9 ? "#00C853" : "#FFA000"
                                font.bold: true
                                font.pixelSize: 11
                                font.family: "Segoe UI"
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 6
                            radius: 3
                            color: "#333344"

                            Rectangle {
                                width: parent.width * accuracy
                                height: parent.height
                                radius: 3
                                color: accuracy > 0.9 ? "#00C853" : "#FFA000"
                            }
                        }
                    }
                }
            }

            // Quick Settings
            Rectangle {
                Layout.fillWidth: true
                height: 120
                radius: 8
                color: "#252540"
                border.color: "#333344"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 8

                    Text {
                        text: "QUICK SETTINGS"
                        color: "#7C4DFF"
                        font.bold: true
                        font.pixelSize: 12
                        font.family: "Segoe UI"
                    }

                    GridLayout {
                        columns: 2
                        columnSpacing: 15
                        rowSpacing: 10
                        Layout.fillWidth: true

                        SettingItem {
                            label: "Grid Size"
                            value: "6×6"
                        }

                        SettingItem {
                            label: "Stimulus"
                            value: "100ms"
                        }

                        SettingItem {
                            label: "ISI"
                            value: "200ms"
                        }

                        SettingItem {
                            label: "Trials/Char"
                            value: "10"
                        }
                    }
                }
            }

            // System Info
            Rectangle {
                Layout.fillWidth: true
                height: 60
                radius: 8
                color: "#252540"
                border.color: "#333344"
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    SystemInfoItem {
                        label: "Signal Quality"
                        value: "Excellent"
                        color: "#00C853"
                        Layout.fillWidth: true
                    }

                    SystemInfoItem {
                        label: "Noise Level"
                        value: "Low"
                        color: "#FFA000"
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
