import QtQuick 2.15

QtObject {
    id: neuroTheme

    // === Color Palette ===
    readonly property color primary: "#00E5FF"
    readonly property color primaryDark: "#00B8D4"
    readonly property color primaryLight: "#69F0AE"
    
    readonly property color secondary: "#7C4DFF"
    readonly property color secondaryDark: "#651FFF"
    readonly property color secondaryLight: "#B388FF"
    
    readonly property color accent: "#FF4081"
    readonly property color accentDark: "#F50057"
    readonly property color accentLight: "#FF80AB"
    
    readonly property color success: "#00E676"
    readonly property color warning: "#FFD600"
    readonly property color error: "#FF5252"
    readonly property color info: "#2196F3"

    // === Background Colors ===
    readonly property color backgroundPrimary: "#0A0A0A"
    readonly property color backgroundSecondary: "#121212"
    readonly property color backgroundTertiary: "#1E1E1E"
    readonly property color backgroundCard: "#252525"
    readonly property color backgroundElevated: "#2D2D2D"

    // === Text Colors ===
    readonly property color textPrimary: "#FFFFFF"
    readonly property color textSecondary: "#B0B0B0"
    readonly property color textTertiary: "#666666"
    readonly property color textDisabled: "#404040"

    // === Border & Divider ===
    readonly property color border: "#333333"
    readonly property color borderLight: "#404040"
    readonly property color divider: "#2A2A2A"

    // === Special Colors ===
    readonly property color overlay: "#80000000"
    readonly property color backdrop: "#CC000000"
    
    readonly property color brainWaveAlpha: "#00E5FF"
    readonly property color brainWaveBeta: "#FF4081"
    readonly property color brainWaveTheta: "#FFD600"
    readonly property color brainWaveDelta: "#00E676"
    readonly property color brainWaveGamma: "#7C4DFF"

    // === Typography ===
    readonly property var typography: ({
        "h1": { "size": 32, "weight": Font.Bold, "lineHeight": 1.2 },
        "h2": { "size": 24, "weight": Font.Bold, "lineHeight": 1.3 },
        "h3": { "size": 20, "weight": Font.Bold, "lineHeight": 1.4 },
        "h4": { "size": 18, "weight": Font.Bold, "lineHeight": 1.4 },
        "h5": { "size": 16, "weight": Font.Bold, "lineHeight": 1.5 },
        "h6": { "size": 14, "weight": Font.Bold, "lineHeight": 1.5 },
        "body1": { "size": 16, "weight": Font.Normal, "lineHeight": 1.5 },
        "body2": { "size": 14, "weight": Font.Normal, "lineHeight": 1.5 },
        "caption": { "size": 12, "weight": Font.Normal, "lineHeight": 1.4 },
        "overline": { "size": 10, "weight": Font.Bold, "lineHeight": 1.4 }
    })

    // === Spacing System ===
    readonly property var spacing: ({
        "xs": 4,
        "sm": 8,
        "md": 16,
        "lg": 24,
        "xl": 32,
        "xxl": 48,
        "xxxl": 64
    })

    // === Border Radius ===
    readonly property var radius: ({
        "none": 0,
        "sm": 4,
        "md": 8,
        "lg": 12,
        "xl": 16,
        "round": 24,
        "pill": 500
    })

    // === Shadows ===
    readonly property var shadows: ({
        "none": "none",
        "sm": "0 1px 2px 0 rgba(0, 0, 0, 0.05)",
        "md": "0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)",
        "lg": "0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05)",
        "xl": "0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04)",
        "2xl": "0 25px 50px -12px rgba(0, 0, 0, 0.25)",
        "inner": "inset 0 2px 4px 0 rgba(0, 0, 0, 0.06)"
    })

    // === Animations ===
    readonly property var animation: ({
        "fast": 150,
        "normal": 300,
        "slow": 500,
        "verySlow": 800
    })

    // === Z-index Layers ===
    readonly property var zIndex: ({
        "dropdown": 1000,
        "sticky": 1020,
        "fixed": 1030,
        "modalBackdrop": 1040,
        "modal": 1050,
        "popover": 1060,
        "tooltip": 1070
    })

    // === Helper Functions ===
    function alpha(color, opacity) {
        return color + Math.round(opacity * 255).toString(16).padStart(2, '0')
    }

    function getTextStyle(style) {
        return typography[style] || typography.body1
    }

    function getSpacing(size) {
        return spacing[size] || 0
    }

    function getRadius(size) {
        return radius[size] || 0
    }

    function getShadow(size) {
        return shadows[size] || shadows.none
    }

    function getAnimationDuration(speed) {
        return animation[speed] || animation.normal
    }
}