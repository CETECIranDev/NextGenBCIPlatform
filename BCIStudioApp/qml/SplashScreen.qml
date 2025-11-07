import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: splashScreen
    anchors.fill: parent
    color: appTheme.backgroundPrimary
    z: 1000

    property bool showSplash: true
    signal finished()

    Column {
        anchors.centerIn: parent
        spacing: 30

        // Logo
        Rectangle {
            width: 120
            height: 120
            radius: 25
            gradient: Gradient {
                GradientStop { position: 0.0; color: appTheme.primary }
                GradientStop { position: 1.0; color: appTheme.secondary }
            }
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                text: "??"
                font.pixelSize: 50
                anchors.centerIn: parent
            }
        }

        // App name
        Text {
            text: "NEUROSTUDIO PRO"
            color: appTheme.textPrimary
            font.pixelSize: 32
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Tagline
        Text {
            text: "Advanced Brain-Computer Interface Platform"
            color: appTheme.textSecondary
            font.pixelSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            text: "Powered By CETEC : Center Of Excellence in Technologies"
            color: appTheme.textSecondary
            font.pixelSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            text: "www.cetec.ir"
            color: appTheme.textSecondary
            font.pixelSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }

        // Loading progress
        Rectangle {
            width: 200
            height: 4
            radius: 2
            color: appTheme.backgroundTertiary
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                id: progressBar
                width: 0
                height: parent.height
                radius: 2
                color: appTheme.primary

                PropertyAnimation {
                    id: progressAnimation
                    target: progressBar
                    property: "width"
                    from: 0
                    to: parent.width
                    duration: 2000
                    onFinished: splashScreen.finished()
                }
            }
        }
    }

    // Version info
    Text {
        text: "Version " + appController.appVersion
        color: appTheme.textTertiary
        font.pixelSize: 12
        anchors {
            bottom: parent.bottom
            bottomMargin: 30
            horizontalCenter: parent.horizontalCenter
        }
    }

    Component.onCompleted: {
        progressAnimation.start()
    }
}
