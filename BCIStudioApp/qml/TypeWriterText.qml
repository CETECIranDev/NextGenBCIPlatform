import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Item {
    id: typeWriterText
    width: textItem.width
    height: textItem.height

    property string text: ""
    property int typingSpeed: 100 // میلی‌ثانیه بین هر حرف
    property int startDelay: 0 // تاخیر قبل از شروع تایپ
    property int currentLength: 0
    property alias font: textItem.font
    property alias color: textItem.color
    property alias horizontalAlignment: textItem.horizontalAlignment

    // سیگنال برای زمانی که تایپ تمام شد
    signal typingFinished()

    Text {
        id: textItem
        text: typeWriterText.text.substring(0, typeWriterText.currentLength)
        color: "#FFFFFF"
        font.pixelSize: 22
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignHCenter
    }

    // تایمر برای تاخیر شروع
    Timer {
        id: startDelayTimer
        interval: typeWriterText.startDelay
        running: true
        onTriggered: {
            typingTimer.start()
        }
    }

    // تایمر اصلی تایپ
    Timer {
        id: typingTimer
        interval: typeWriterText.typingSpeed
        repeat: true
        running: false
        onTriggered: {
            if (currentLength < typeWriterText.text.length) {
                currentLength++
                // افکت صدا (اختیاری)
                playTypeSound()
            } else {
                stop()
                typingFinished()
            }
        }
    }

    // افکت چشمک زدن مکان‌نما
    Rectangle {
        id: cursor
        width: 2
        height: textItem.height * 0.7
        color: "#00D4AA"
        x: textItem.width
        y: (textItem.height - height) / 2
        visible: typingTimer.running || currentLength === typeWriterText.text.length

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            running: cursor.visible
            NumberAnimation { from: 1.0; to: 0.3; duration: 500; easing.type: Easing.InOutSine }
            NumberAnimation { from: 0.3; to: 1.0; duration: 500; easing.type: Easing.InOutSine }
        }
    }

    // افکت درخشش هنگام کامل شدن متن
    Glow {
        anchors.fill: textItem
        source: textItem
        color: "#00B8FF"
        radius: 0
        samples: 16
        visible: currentLength === typeWriterText.text.length

        NumberAnimation on radius {
            id: finishGlowAnimation
            from: 0
            to: 8
            duration: 1000
            running: currentLength === typeWriterText.text.length
        }
    }

    function playTypeSound() {
        // اینجا می‌توانید افکت صدا اضافه کنید
        // مثلاً: soundEffect.play()
    }

    function startTyping() {
        currentLength = 0
        startDelayTimer.restart()
    }

    function skipTyping() {
        typingTimer.stop()
        currentLength = typeWriterText.text.length
        typingFinished()
    }

    Component.onCompleted: {
        startTyping()
    }
}
