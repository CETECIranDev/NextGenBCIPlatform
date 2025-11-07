import QtQuick
import QtQuick.Layouts

Rectangle {
    id: glassCard
    
    property real glassOpacity: 0.08
    property real glassBlur: 15
    property bool hoverEnabled: true
    property bool clickable: false
    
    signal clicked()
    
    radius: 16
    color: theme.backgroundGlass
    border.color: theme.glassBorder
    border.width: 1
    opacity: glassOpacity
    
    // افکت شیشه‌ای
    layer.enabled: true
    layer.effect: ShaderEffect {
        property color glassColor: theme.backgroundGlass
        property real blurRadius: glassCard.glassBlur
        
        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform lowp float qt_Opacity;
            uniform lowp vec4 glassColor;
            uniform highp float blurRadius;
            
            void main() {
                highp vec2 coord = qt_TexCoord0 - vec2(0.5, 0.5);
                highp float dist = length(coord);
                highp float alpha = exp(-dist * dist * 4.0) * glassColor.a;
                gl_FragColor = vec4(glassColor.rgb * alpha, alpha) * qt_Opacity;
            }
        "
    }

    // Gradient overlay برای افکت شیشه‌ای بهتر
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        gradient: theme.glassGradient
        opacity: 0.3
        border.color: theme.glassBorder
        border.width: 1
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: glassCard.hoverEnabled
        cursorShape: glassCard.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: if (glassCard.clickable) glassCard.clicked()
        
        onEntered: {
            if (glassCard.hoverEnabled) {
                hoverAnim.start()
            }
        }
        
        onExited: {
            if (glassCard.hoverEnabled) {
                resetAnim.start()
            }
        }
    }

    // انیمیشن‌های hover
    ParallelAnimation {
        id: hoverAnim
        NumberAnimation {
            target: glassCard
            property: "scale"
            from: 1.0
            to: 1.02
            duration: 200
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: glassCard
            property: "glassOpacity"
            from: glassCard.glassOpacity
            to: Math.min(glassCard.glassOpacity + 0.04, 0.15)
            duration: 200
        }
    }

    ParallelAnimation {
        id: resetAnim
        NumberAnimation {
            target: glassCard
            property: "scale"
            from: 1.02
            to: 1.0
            duration: 200
            easing.type: Easing.OutCubic
        }
        NumberAnimation {
            target: glassCard
            property: "glassOpacity"
            to: glassCard.glassOpacity
            duration: 200
        }
    }
}