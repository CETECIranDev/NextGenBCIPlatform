import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Rectangle {
    id: welcomeCard
    height: 200
    radius: 16
    color: "transparent"

    // Background with gradient and blur
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        gradient: Gradient {
            GradientStop { position: 0.0; color: appTheme.primary + "10" }
            GradientStop { position: 0.5; color: appTheme.secondary + "08" }
            GradientStop { position: 1.0; color: "transparent" }
        }
        border.color: appTheme.borderLight
        border.width: 1
    }

    // Animated background particles
    Canvas {
        id: particlesCanvas
        anchors.fill: parent
        opacity: 0.3

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            
            // Draw floating particles
            ctx.fillStyle = appTheme.primary
            for (var i = 0; i < 15; i++) {
                var x = (Math.sin(Date.now() * 0.001 + i) * 0.5 + 0.5) * width
                var y = (Math.cos(Date.now() * 0.001 + i * 0.7) * 0.5 + 0.5) * height
                var size = 2 + Math.sin(Date.now() * 0.002 + i) * 1
                
                ctx.beginPath()
                ctx.arc(x, y, size, 0, Math.PI * 2)
                ctx.fill()
            }
        }

        Timer {
            interval: 50
            running: true
            repeat: true
            onTriggered: particlesCanvas.requestPaint()
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 30
        spacing: 30

        // Welcome Text
        Column {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 12

            Text {
                text: "Welcome to NeuroStudio Pro"
                color: appTheme.textPrimary
                font.family: robotoBold.name
                font.pixelSize: 28
                font.letterSpacing: 0.5
            }

            Text {
                text: "Advanced platform for brain-computer interface research and development. " +
                      "Design, analyze, and deploy BCI systems with cutting-edge tools."
                color: appTheme.textSecondary
                font.family: robotoRegular.name
                font.pixelSize: 16
                lineHeight: 1.5
                wrapMode: Text.WordWrap
                width: parent.width
            }

            // Quick Stats
            Row {
                spacing: 30
                topPadding: 10

                StatBadge {
                    value: "12"
                    label: "Projects"
                    icon: "📁"
                    color: appTheme.primary
                }

                StatBadge {
                    value: "8"
                    label: "Paradigms"
                    icon: "🧠"
                    color: appTheme.secondary
                }

                StatBadge {
                    value: "24"
                    label: "Nodes"
                    icon: "🧩"
                    color: appTheme.accent
                }
            }
        }

        // Brain Visualization
        Rectangle {
            width: 120
            height: 120
            radius: 60
            Layout.alignment: Qt.AlignVCenter
            color: "transparent"
            border.color: appTheme.primary + "40"
            border.width: 2

            // Animated brain waves
            Canvas {
                id: brainWaves
                anchors.fill: parent
                anchors.margins: 10

                onPaint: {
                    var ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    
                    var time = Date.now() * 0.005
                    var centerX = width / 2
                    var centerY = height / 2
                    var baseRadius = 40
                    
                    // Draw brain waves
                    ctx.strokeStyle = appTheme.primary
                    ctx.lineWidth = 2
                    ctx.globalAlpha = 0.8
                    
                    ctx.beginPath()
                    for (var i = 0; i < Math.PI * 2; i += 0.1) {
                        var wave = Math.sin(time + i * 3) * 3
                        var radius = baseRadius + wave
                        var x = centerX + Math.cos(i) * radius
                        var y = centerY + Math.sin(i) * radius
                        
                        if (i === 0) {
                            ctx.moveTo(x, y)
                        } else {
                            ctx.lineTo(x, y)
                        }
                    }
                    ctx.closePath()
                    ctx.stroke()
                    
                    // Draw neural connections
                    ctx.strokeStyle = appTheme.secondary
                    ctx.lineWidth = 1
                    ctx.globalAlpha = 0.4
                    
                    for (var j = 0; j < 8; j++) {
                        var angle1 = (j / 8) * Math.PI * 2 + time * 0.1
                        var angle2 = ((j + 4) / 8) * Math.PI * 2 + time * 0.1
                        
                        var x1 = centerX + Math.cos(angle1) * 30
                        var y1 = centerY + Math.sin(angle1) * 30
                        var x2 = centerX + Math.cos(angle2) * 30
                        var y2 = centerY + Math.sin(angle2) * 30
                        
                        ctx.beginPath()
                        ctx.moveTo(x1, y1)
                        ctx.lineTo(x2, y2)
                        ctx.stroke()
                    }
                }

                Timer {
                    interval: 50
                    running: true
                    repeat: true
                    onTriggered: brainWaves.requestPaint()
                }
            }

            // Brain icon in center
            Text {
                text: "🧠"
                font.pixelSize: 32
                anchors.centerIn: parent
            }
        }
    }

    // Shine effect
    layer.enabled: true
    layer.effect: Glow {
        color: appTheme.primary + "20"
        radius: 20
        samples: 16
    }
}
