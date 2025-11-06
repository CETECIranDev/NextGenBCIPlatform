import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: neuroButton
    height: 40
    radius: 8
    
    property string text: "Button"
    property string icon: ""
    property string type: "secondary" // primary, secondary, danger
    property string size: "medium" // small, medium, large
    property bool disabled: false
    
    signal clicked()

    // Colors based on type
    property color backgroundColor: {
        if (disabled) return appTheme.textDisabled
        switch(type) {
            case "primary": return appTheme.primary
            case "danger": return appTheme.error
            default: return appTheme.backgroundElevated
        }
    }
    
    property color textColor: {
        if (disabled) return appTheme.textTertiary
        switch(type) {
            case "primary": return "white"
            case "danger": return "white"
            default: return appTheme.textPrimary
        }
    }
    
    property color borderColor: {
        if (disabled) return appTheme.border
        switch(type) {
            case "primary": return appTheme.primaryDark
            case "danger": return appTheme.errorDark
            default: return appTheme.borderLight
        }
    }

    // Sizes
    property int padding: {
        switch(size) {
            case "small": return 12
            case "large": return 20
            default: return 16
        }
    }
    
    property int fontSize: {
        switch(size) {
            case "small": return 12
            case "large": return 16
            default: return 14
        }
    }

    color: backgroundColor
    border.color: borderColor
    border.width: 1
    opacity: disabled ? 0.6 : 1.0

    // Content
    Row {
        anchors.centerIn: parent
        spacing: 8
        padding: neuroButton.padding

        Text {
            text: neuroButton.icon
            font.pixelSize: neuroButton.fontSize
            color: neuroButton.textColor
            visible: neuroButton.icon !== ""
        }

        Text {
            text: neuroButton.text
            font.family: robotoBold.name
            font.pixelSize: neuroButton.fontSize
            color: neuroButton.textColor
        }
    }

    // Mouse area
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: disabled ? Qt.ArrowCursor : Qt.PointingHandCursor
        onClicked: {
            if (!disabled) {
                neuroButton.clicked()
                rippleAnim.start()
            }
        }
        
        onEntered: {
            if (!disabled) hoverAnim.start()
        }
        onExited: {
            if (!disabled) resetAnim.start()
        }
    }

    // Ripple effect
    Rectangle {
        id: ripple
        width: 0
        height: 0
        radius: width / 2
        color: neuroButton.textColor
        opacity: 0.2
        anchors.centerIn: parent
    }

    // Animations
    PropertyAnimation {
        id: hoverAnim
        target: neuroButton
        property: "scale"
        to: 1.02
        duration: 150
    }

    PropertyAnimation {
        id: resetAnim
        target: neuroButton
        property: "scale"
        to: 1.0
        duration: 150
    }

    PropertyAnimation {
        id: rippleAnim
        target: ripple
        properties: "width,height"
        from: 0
        to: Math.max(neuroButton.width, neuroButton.height) * 1.5
        duration: 400
        onStarted: ripple.opacity = 0.2
        onFinished: ripple.opacity = 0
    }
}