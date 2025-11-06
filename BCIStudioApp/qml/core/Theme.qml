import QtQuick 2.15

QtObject {
    id: theme

    // Color Palette
    readonly property var colors: {
        "primary": "#00E5FF",
        "secondary": "#7C4DFF",
        "accent": "#FF4081",
        "success": "#00E676",
        "warning": "#FFD600",
        "error": "#FF5252",

        "background": {
            "primary": "#121212",
            "secondary": "#1E1E1E",
            "tertiary": "#252525",
            "card": "#2D2D2D"
        },

        "text": {
            "primary": "#FFFFFF",
            "secondary": "#B0B0B0",
            "disabled": "#666666"
        },

        "border": "#404040",
        "divider": "#333333"
    }

    // Typography
    readonly property var typography: {
        "h1": { "size": 24, "weight": Font.Bold },
        "h2": { "size": 20, "weight": Font.Bold },
        "h3": { "size": 16, "weight": Font.Bold },
        "body": { "size": 14, "weight": Font.Normal },
        "caption": { "size": 12, "weight": Font.Normal }
    }

    // Spacing
    readonly property var spacing: {
        "xs": 4,
        "sm": 8,
        "md": 16,
        "lg": 24,
        "xl": 32
    }

    // Animation
    readonly property var animation: {
        "fast": 150,
        "normal": 300,
        "slow": 500
    }

    // Shadows
    readonly property var shadows: {
        "low": "0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24)",
        "medium": "0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)",
        "high": "0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23)"
    }
}
