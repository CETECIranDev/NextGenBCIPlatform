import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: brainLogo
    width: 150
    height: 150

    property bool glowEnabled: true
    property bool animationRunning: true
    property int rotationDuration: 25000 // مدت زمان چرخش
    property color brainColor: "#00D4AA"
    property color glowColor: "#00B8FF"
    property real brainOpacity: 0.8

    Canvas {
        id: brainCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()

            // رسم شکل مغز
            ctx.strokeStyle = brainColor
            ctx.lineWidth = 3
            ctx.fillStyle = "#001F3F"
            ctx.globalAlpha = brainOpacity

            drawAdvancedBrainShape(ctx)
            ctx.stroke()
            ctx.fill()

            // رسم شبکه‌های عصبی داخلی
            ctx.strokeStyle = glowColor
            ctx.lineWidth = 1
            ctx.globalAlpha = brainOpacity * 0.6
            drawNeuralNetworks(ctx)
        }

        Component.onCompleted: {
            requestPaint()
        }
    }

    // افکت درخشش
    Glow {
        anchors.fill: brainCanvas
        source: brainCanvas
        color: glowColor
        radius: glowEnabled ? 20 : 0
        samples: glowEnabled ? 32 : 0
        transparentBorder: true

        // انیمیشن ضربان برای درخشش
        SequentialAnimation on radius {
            loops: Animation.Infinite
            running: glowEnabled && animationRunning
            NumberAnimation {
                from: 15;
                to: 25;
                duration: 3000;
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: 25;
                to: 15;
                duration: 3000;
                easing.type: Easing.InOutSine
            }
        }
    }

    // انیمیشن چرخش با مدت زمان قابل تنظیم
    RotationAnimation {
        target: brainLogo
        property: "rotation"
        from: 0
        to: 360
        duration: rotationDuration
        loops: Animation.Infinite
        running: animationRunning
    }

    // انیمیشن مقیاس برای اثر تنفس
    SequentialAnimation on scale {
        loops: Animation.Infinite
        running: animationRunning
        NumberAnimation {
            from: 0.95;
            to: 1.05;
            duration: 4000;
            easing.type: Easing.InOutSine
        }
        NumberAnimation {
            from: 1.05;
            to: 0.95;
            duration: 4000;
            easing.type: Easing.InOutSine
        }
    }

    function drawAdvancedBrainShape(ctx) {
        var centerX = width / 2
        var centerY = height / 2
        var radius = width / 3.5

        ctx.beginPath()

        // رسم نیمه چپ مغز
        for (var i = Math.PI; i <= Math.PI * 2; i += 0.05) {
            var ripple = Math.sin(i * 4) * 0.1 + Math.cos(i * 2) * 0.05
            var x = centerX + Math.cos(i) * radius * (0.8 + ripple)
            var y = centerY + Math.sin(i) * radius * (0.9 + Math.sin(i * 3) * 0.1)

            if (i === Math.PI) {
                ctx.moveTo(x, y)
            } else {
                ctx.lineTo(x, y)
            }
        }

        // رسم نیمه راست مغز
        for (var j = 0; j <= Math.PI; j += 0.05) {
            var ripple2 = Math.sin(j * 4) * 0.1 + Math.cos(j * 2) * 0.05
            var x2 = centerX + Math.cos(j) * radius * (0.8 + ripple2)
            var y2 = centerY + Math.sin(j) * radius * (0.9 + Math.sin(j * 3) * 0.1)
            ctx.lineTo(x2, y2)
        }

        ctx.closePath()
    }

    function drawNeuralNetworks(ctx) {
        var centerX = width / 2
        var centerY = height / 2
        var maxRadius = width / 3

        // رسم اتصالات عصبی
        for (var i = 0; i < 15; i++) {
            var angle1 = Math.random() * Math.PI * 2
            var radius1 = Math.random() * maxRadius * 0.6
            var x1 = centerX + Math.cos(angle1) * radius1
            var y1 = centerY + Math.sin(angle1) * radius1

            var angle2 = angle1 + (Math.random() - 0.5) * Math.PI
            var radius2 = Math.random() * maxRadius * 0.8
            var x2 = centerX + Math.cos(angle2) * radius2
            var y2 = centerY + Math.sin(angle2) * radius2

            ctx.beginPath()
            ctx.moveTo(x1, y1)
            ctx.lineTo(x2, y2)
            ctx.stroke()
        }

        // رسم نقاط عصبی
        ctx.fillStyle = glowColor
        for (var j = 0; j < 8; j++) {
            var nodeAngle = Math.random() * Math.PI * 2
            var nodeRadius = Math.random() * maxRadius * 0.5
            var nodeX = centerX + Math.cos(nodeAngle) * nodeRadius
            var nodeY = centerY + Math.sin(nodeAngle) * nodeRadius

            ctx.beginPath()
            ctx.arc(nodeX, nodeY, 1.5, 0, Math.PI * 2)
            ctx.fill()
        }
    }
}
