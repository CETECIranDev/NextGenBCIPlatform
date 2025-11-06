// DashboardView.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: dashboardRoot
    anchors.fill: parent

    // Properties for responsive design
    property bool isWideScreen: width > 1600
    property bool isMediumScreen: width > 1200
    property int currentColumns: isWideScreen ? 3 : (isMediumScreen ? 2 : 1)
    property real cardSpacing: 25
    property real headerHeight: 100

    // Modern background
    Rectangle {
        anchors.fill: parent
        color: theme.backgroundPrimary
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent
        clip: true
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        contentWidth: Math.max(dashboardGrid.width, scrollView.width)
        contentHeight: dashboardGrid.height

        ColumnLayout {
            id: dashboardGrid
            width: Math.max(scrollView.width, 1400)
            spacing: cardSpacing

            // Header Section
            Item {
                Layout.topMargin: cardSpacing
                Layout.leftMargin: cardSpacing
                Layout.rightMargin: cardSpacing
                Layout.fillWidth: true
                height: headerHeight

                RowLayout {
                    anchors.fill: parent
                    spacing: cardSpacing

                    // Welcome Card
                    DashboardHeaderCard {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        title: "BCI Studio Pro Dashboard"
                        subtitle: "Real-time Brain-Computer Interface Monitoring & Analysis"
                        icon: "🧠"
                        headerGradient: theme.primaryGradient
                        elevation: 3
                    }

                    // Quick Stats - با سایز ثابت
                    RowLayout {
                        spacing: cardSpacing
                        Layout.preferredWidth: 450
                        Layout.fillHeight: true

                        QuickStatCard {
                            Layout.preferredWidth: 200
                            Layout.fillHeight: true
                            title: "Signal Quality"
                            value: "92%"
                            trend: "+2.1%"
                            icon: "📶"
                            cardColor: theme.success
                            elevation: 2
                        }

                        QuickStatCard {
                            Layout.preferredWidth: 200
                            Layout.fillHeight: true
                            title: "Active Sessions"
                            value: "3"
                            trend: "Live"
                            icon: "🔴"
                            cardColor: theme.primary
                            elevation: 2
                        }
                    }
                }
            }

            // Main Dashboard Grid
            GridLayout {
                Layout.leftMargin: cardSpacing
                Layout.rightMargin: cardSpacing
                Layout.bottomMargin: cardSpacing
                Layout.fillWidth: true
                columns: currentColumns
                columnSpacing: cardSpacing
                rowSpacing: cardSpacing

                // ردیف اول
                SystemStatusCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 300
                    elevation: 3
                }

                LiveSignalCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 300
                    elevation: 3
                }

                AdvancedCognitiveMetricsCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 300
                    elevation: 3
                }

                // ردیف دوم
                SignalQualityMapCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 450
                    Layout.columnSpan: currentColumns >= 2 ? 2 : 1
                    elevation: 4
                }

                SpectrumCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 450
                    elevation: 3
                }

                // ردیف سوم
                MainOutputCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 350
                    Layout.columnSpan: currentColumns >= 2 ? 2 : 1
                    elevation: 3
                }

                EventLogCard {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 350
                    elevation: 3
                }
            }
        }
    }

    // Floating Action Button - نسخه ساده‌تر
    Rectangle {
        id: fab
        width: 60
        height: 60
        radius: 30
        color: theme.primary
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 30

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 0
            verticalOffset: 4
            radius: 8
            samples: 17
            color: "#40000000"
        }

        Text {
            anchors.centerIn: parent
            text: "⚡"
            font.pixelSize: 24
            color: "white"
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: console.log("Quick Actions clicked")
        }
    }

    // Responsive states
    states: [
        State {
            name: "mobile"
            when: dashboardRoot.width < 768
            PropertyChanges {
                target: dashboardRoot
                currentColumns: 1
                cardSpacing: 15
                headerHeight: 80
            }
        },
        State {
            name: "tablet"
            when: dashboardRoot.width >= 768 && dashboardRoot.width < 1200
            PropertyChanges {
                target: dashboardRoot
                currentColumns: 2
                cardSpacing: 20
                headerHeight: 90
            }
        },
        State {
            name: "desktop"
            when: dashboardRoot.width >= 1200 && dashboardRoot.width < 1600
            PropertyChanges {
                target: dashboardRoot
                currentColumns: 2
                cardSpacing: 25
                headerHeight: 100
            }
        },
        State {
            name: "wide"
            when: dashboardRoot.width >= 1600
            PropertyChanges {
                target: dashboardRoot
                currentColumns: 3
                cardSpacing: 30
                headerHeight: 100
            }
        }
    ]

    transitions: Transition {
        NumberAnimation { properties: "currentColumns, cardSpacing, headerHeight"; duration: 300 }
    }
}
