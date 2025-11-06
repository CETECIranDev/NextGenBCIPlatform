import QtQuick

Rectangle {
    id: glassEffect
    
    property real blurRadius: 10
    property real glassOpacity: 0.9
    
    color: theme.glassyBgColor
    border.color: theme.border
    border.width: 1
    radius: theme.radius.md
    opacity: glassOpacity
    
    // افکت blur (اگر پشتیبانی شود)
    layer.enabled: true
    layer.effect: ShaderEffect {
        property real blur: blurRadius
        
        fragmentShader: "
            varying highp vec2 qt_TexCoord0;
            uniform sampler2D source;
            uniform lowp float qt_Opacity;
            uniform highp float blur;
            void main() {
                lowp vec4 color = texture2D(source, qt_TexCoord0);
                color.rgb *= color.a;
                gl_FragColor = color * qt_Opacity;
            }
        "
    }
}