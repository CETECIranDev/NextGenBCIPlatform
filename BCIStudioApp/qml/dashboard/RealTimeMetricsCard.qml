import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import "../models"


Item {
    id: dashboardRoot

    DashboardModel {
        id: dashboardModel
    }

    ScrollView {
        clip: true
        background: Rectangle { color: appTheme.backgroundDark }

        GridLayout {
            width: Math.max(parent.width, 1200) // حداقل عرض برای نمایش بهتر
            anchors.margins: 16
            columns: 4
            columnSpacing: 16
            rowSpacing: 16

            SystemStatusCard {
                Layout.column: 0; Layout.row: 0
                Layout.fillWidth: true
                isConnected: dashboardModel.isConnected
                batteryLevel: dashboardModel.batteryLevel
                sessionTime: dashboardModel.sessionTime
            }

            LiveSignalCard {
                Layout.column: 1; Layout.columnSpan: 2; Layout.row: 0
                Layout.fillWidth: true; Layout.preferredHeight: 250
            }

            CognitiveGaugesCard {
                Layout.column: 3; Layout.row: 0
                Layout.fillWidth: true; Layout.preferredHeight: 250
                attention: dashboardModel.attentionLevel
                fatigue: dashboardModel.fatigueLevel
            }

            SignalQualityMapCard {
                Layout.column: 0; Layout.row: 1; Layout.rowSpan: 2
                Layout.fillWidth: true; Layout.fillHeight: true
                qualityData: dashboardModel.signalQuality
            }

            MainOutputCard {
                Layout.column: 1; Layout.columnSpan: 2; Layout.row: 1
                Layout.fillWidth: true; Layout.fillHeight: true
                command: dashboardModel.lastCommand
                confidence: dashboardModel.commandConfidence
            }

            EventLogCard {
                Layout.column: 3; Layout.row: 1; Layout.rowSpan: 2
                Layout.fillWidth: true; Layout.fillHeight: true
                logModel: dashboardModel.eventLog
            }

            SpectrumCard {
                Layout.column: 1; Layout.columnSpan: 2; Layout.row: 2
                Layout.fillWidth: true; Layout.fillHeight: true
                bandData: dashboardModel.frequencyBands
            }
        }
    }
}
