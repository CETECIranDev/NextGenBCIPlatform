import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: splashScreen
    anchors.fill: parent

    // تعریف signal با نام درست
    signal finished()

    // رنگ‌های حرفه‌ای Enterprise
    property color primaryColor: "#001F3F"
    property color accentColor: "#00D4AA"
    property color glowColor: "#00B8FF"
    property color textColor: "#FFFFFF"

    // گرادیانت پس‌زمینه
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#0A192F" }
            GradientStop { position: 0.5; color: "#001F3F" }
            GradientStop { position: 1.0; color: "#003366" }
        }
    }

    // تصویر مغز کم رنگ در پس‌زمینه
    Image {
        id: brainBackground
        anchors.centerIn: parent
        width: Math.min(parent.width, parent.height) * 0.8
        height: width
        source: "qrc:/images/brain_outline.png" // یا مسیر تصویر مغز شما
        opacity: 0.1 // کم رنگ
        fillMode: Image.PreserveAspectFit

        // اگر تصویر ندارید، از شکل SVG استفاده کنید
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "#FFFFFF"
            border.width: 2
            opacity: 0.05
            radius: width / 2
        }
    }

    // افکت نوری ملایم روی تصویر مغز
    RadialGradient {
        anchors.fill: brainBackground
        source: brainBackground
        gradient: Gradient {
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 0.5; color: "#00000000" }
            GradientStop { position: 1.0; color: "#2200B8FF" }
        }
    }

    // شبکه عصبی ملایم و کم‌تراکم
    NeuralNetworkBackground {
        id: neuralBackground
        anchors.fill: parent
        nodeCount: 15 // تعداد کمتر
        connectionCount: 40 // اتصالات کمتر
        animationDuration: 4000
        opacity: 0.3 // شفافیت بیشتر
    }

    // کانتینر اصلی محتوا
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 40
        width: parent.width * 0.8

        // هدر با لوگو و عنوان
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            // لوگو مغز مرکزی
            BrainLogo {
                id: brainLogo
                Layout.preferredWidth: 140
                Layout.preferredHeight: 140
                glowEnabled: true
                animationRunning: true
            }

            ColumnLayout {
                spacing: 12

                Text {
                    text: "NEUROSYNC"
                    font.family: "Segoe UI"
                    font.pixelSize: 52
                    font.weight: Font.Light
                    color: textColor
                    Layout.alignment: Qt.AlignHCenter

                    layer.enabled: true
                    layer.effect: Glow {
                        color: glowColor
                        radius: 12
                        samples: 20
                        spread: 0.3
                    }
                }

                Text {
                    text: "ENTERPRISE BCI PLATFORM"
                    font.family: "Segoe UI"
                    font.pixelSize: 16
                    font.weight: Font.Normal
                    color: accentColor
                    font.letterSpacing: 3
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }

        // زیرعنوان با افکت تایپ شونده
        TypeWriterText {
            id: subtitle
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 30
            text: "Advanced Brain-Computer Interface Solution"
            font.pixelSize: 22
            font.weight: Font.Medium
            color: textColor
            typingSpeed: 80 // سرعت کمتر برای تاثیرگذاری بیشتر
        }

        // نمایش وضعیت لودینگ پیشرفته
        AdvancedLoadingIndicator {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 50
            Layout.preferredWidth: 500
            Layout.preferredHeight: 6
        }

        // اطلاعات وضعیت سیستم
        GridLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 40
            columns: 2
            columnSpacing: 50
            rowSpacing: 20

            StatusItem {
                label: "NEURAL CONNECTION"
                value: "ESTABLISHED"
                status: "success"
                icon: "🔗"
            }

            StatusItem {
                label: "SIGNAL QUALITY"
                value: "EXCELLENT"
                status: "success"
                icon: "📊"
            }

            StatusItem {
                label: "DATA STREAM"
                value: "ACTIVE"
                status: "processing"
                icon: "⚡"
            }

            StatusItem {
                label: "SYSTEM STATUS"
                value: "OPTIMAL"
                status: "success"
                icon: "✅"
            }
        }

        // فوت‌نوت با اطلاعات نسخه
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 60
            text: "v2.1.0 | Enterprise Edition | © 2024 NeuroSync Technologies"
            font.family: "Segoe UI"
            font.pixelSize: 12
            color: "#8899AA"
            opacity: 0.8
        }
    }

    // تایمر برای مدیریت زمان نمایش اسپلش اسکرین (زمان بیشتر)
    Timer {
        id: splashTimer
        interval: 10000 // 7 ثانیه به جای 5 ثانیه
        running: true
        onTriggered: {
            finished() // فراخوانی signal
        }
    }

    // انیمیشن fade in هنگام شروع
    OpacityAnimator {
        id: fadeInAnimator
        target: splashScreen
        from: 0
        to: 1
        duration: 8000
        running: true
    }
}
