import QtQuick

Item {
    id: themeManager

    property string currentTheme: "dark"
    property int transitionDuration: 400
    property real glassOpacity: 0.12
    property real glassBlur: 20
    property real elevationShadow: 0.3

    // تم فعال
    property var theme: getCurrentTheme()

    // تم دارک Enterprise Premium
    property var darkTheme: QtObject {
        // رنگ‌های اصلی - Neuro-Tech Palette
        property color primary: "#00D4AA"
        property color primaryDark: "#6A3CE8"
        property color primaryLight: "#9B77FF"
        property color primaryGlass: "#207C4DFF"

        property color secondary:  "#00B8FF"
        property color secondaryDark: "#00B8D4"
        property color secondaryLight: "#33EBFF"
        property color secondaryGlass: "#2000E5FF"

        property color accent:  "#7C4DFF"
        property color accentDark: "#E55A00"
        property color accentLight: "#FF8A33"
        property color accentGlass: "#20FF6D00"

        // سیستم رنگ‌ها - Professional
        property color success: "#00E676"
        property color successDark: "#00C853"
        property color warning: "#FFC400"
        property color warningDark: "#FFAB00"
        property color error: "#FF5252"
        property color errorDark: "#FF1744"
        property color info: "#448AFF"
        property color infoDark: "#2979FF"

        // پس‌زمینه‌های تیره حرفه‌ای - Deep Space
        property color backgroundPrimary:  "#0A192F"
        property color backgroundSecondary: "#001F3F"
        property color backgroundTertiary: "#003366"
        property color backgroundCard: "#161626"
        property color backgroundElevated: "#202036"
        property color backgroundGlass: "#10101A"
        property color backgroundOverlay: "#800A0A14"

        // متن‌ها - Professional Typography
        property color textPrimary: "#F0F0FF"
        property color textSecondary: "#B8B8D0"
        property color textTertiary:"#8A8AA8"
        property color textDisabled: "#5A5A7A"
        property color textInverted: "#0A0A14"
        property color textLink: "#7C4DFF"

        // Border و Divider - Premium
        property color border: "#2D2D44"
        property color borderLight: "#3A3A52"
        property color borderFocus: "#7C4DFF"
        property color divider: "#252538"
        property color glassBorder: "#40405A"

        // افکت‌های ویژه - Glassmorphism
        property color overlay: "#CC0A0A14"
        property color backdrop: "#CC000000"
        property color glow: "#407C4DFF"
        property color shadow: "#60000000"
        property color reflection: "#10FFFFFF"

        // Brain Wave Colors - Scientific
        property color brainWaveAlpha: "#7C4DFF"
        property color brainWaveBeta: "#FF6D00"
        property color brainWaveTheta: "#FFC400"
        property color brainWaveDelta: "#00E5FF"
        property color brainWaveGamma: "#FF4081"

        // گرادیانت‌های حرفه‌ای
        property variant primaryGradient: Gradient {
            GradientStop { position: 0.0; color: "#7C4DFF" }
            GradientStop { position: 0.5; color: "#9B77FF" }
            GradientStop { position: 1.0; color: "#6A3CE8" }
        }

        property variant secondaryGradient: Gradient {
            GradientStop { position: 0.0; color: "#00E5FF" }
            GradientStop { position: 0.5; color: "#00B8D4" }
            GradientStop { position: 1.0; color: "#0097A7" }
        }

        property variant glassGradient: Gradient {
            GradientStop { position: 0.0; color: "#20FFFFFF" }
            GradientStop { position: 0.5; color: "#10FFFFFF" }
            GradientStop { position: 1.0; color: "#08FFFFFF" }
        }

        property variant backgroundGradient: Gradient {
            GradientStop { position: 0.0; color: "#0A0A14" }
            GradientStop { position: 0.5; color: "#121220" }
            GradientStop { position: 1.0; color: "#1A1A2E" }
        }

        // Typography System - Enterprise
        property var typography: QtObject {
            property var h1: QtObject { property int size: 32; property int weight: Font.Light }
            property var h2: QtObject { property int size: 28; property int weight: Font.Light }
            property var h3: QtObject { property int size: 24; property int weight: Font.Normal }
            property var h4: QtObject { property int size: 20; property int weight: Font.Medium }
            property var h5: QtObject { property int size: 18; property int weight: Font.Medium }
            property var h6: QtObject { property int size: 16; property int weight: Font.Medium }
            property var body1: QtObject { property int size: 14; property int weight: Font.Normal }
            property var body2: QtObject { property int size: 12; property int weight: Font.Normal }
            property var caption: QtObject { property int size: 11; property int weight: Font.Normal }
            property var overline: QtObject { property int size: 10; property int weight: Font.Medium }
        }

        // Spacing System - 8px Grid
        property var spacing: QtObject {
            property int xs: 4
            property int sm: 8
            property int md: 16
            property int lg: 24
            property int xl: 32
            property int xxl: 48
        }

        // Border Radius - Modern
        property var radius: QtObject {
            property int xs: 2
            property int sm: 4
            property int md: 8
            property int lg: 12
            property int xl: 16
            property int xxl: 24
        }

        // Elevation Shadows - Material Design
        property var elevation: QtObject {
            property var level0: "none"
            property var level1: "0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24)"
            property var level2: "0 3px 6px rgba(0,0,0,0.16), 0 3px 6px rgba(0,0,0,0.23)"
            property var level3: "0 10px 20px rgba(0,0,0,0.19), 0 6px 6px rgba(0,0,0,0.23)"
            property var level4: "0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22)"
            property var level5: "0 19px 38px rgba(0,0,0,0.30), 0 15px 12px rgba(0,0,0,0.22)"
        }
    }

    // تم لایت Enterprise Premium
    property var lightTheme: QtObject {
        // رنگ‌های اصلی - Neuro-Tech Palette
        property color primary: "#7C4DFF"
        property color primaryDark: "#6A3CE8"
        property color primaryLight: "#9B77FF"
        property color primaryGlass: "#207C4DFF"

        property color secondary: "#00BFA5"
        property color secondaryDark: "#009E7F"
        property color secondaryLight: "#33D6BD"
        property color secondaryGlass: "#2000BFA5"

        property color accent: "#FF6D00"
        property color accentDark: "#E55A00"
        property color accentLight: "#FF8A33"
        property color accentGlass: "#20FF6D00"

        // سیستم رنگ‌ها - Professional
        property color success: "#00C853"
        property color successDark: "#00A844"
        property color warning: "#FFA000"
        property color warningDark: "#FF8A00"
        property color error: "#F44336"
        property color errorDark: "#E53935"
        property color info: "#2196F3"
        property color infoDark: "#1E88E5"

        // پس‌زمینه‌های روشن حرفه‌ای - Clean & Modern
        property color backgroundPrimary: "#FFFFFF"
        property color backgroundSecondary: "#F8F9FF"
        property color backgroundTertiary: "#F0F2FF"
        property color backgroundCard: "#FFFFFF"
        property color backgroundElevated: "#FFFFFF"
        property color backgroundGlass: "#F8F9FF"
        property color backgroundOverlay: "#80FFFFFF"

        // متن‌ها - Professional Typography
        property color textPrimary: "#1A1A2E"
        property color textSecondary: "#4A4A6A"
        property color textTertiary: "#6B6B8C"
        property color textDisabled: "#A0A0B8"
        property color textInverted: "#FFFFFF"
        property color textLink: "#7C4DFF"

        // Border و Divider - Premium
        property color border: "#E8E8F0"
        property color borderLight: "#F0F2FF"
        property color borderFocus: "#7C4DFF"
        property color divider: "#F5F7FF"
        property color glassBorder: "#E0E4FF"

        // افکت‌های ویژه - Glassmorphism
        property color overlay: "#80FFFFFF"
        property color backdrop: "#40000000"
        property color glow: "#207C4DFF"
        property color shadow: "#20000000"
        property color reflection: "#08FFFFFF"

        // Brain Wave Colors - Scientific
        property color brainWaveAlpha: "#7C4DFF"
        property color brainWaveBeta: "#FF6D00"
        property color brainWaveTheta: "#FFA000"
        property color brainWaveDelta: "#00BFA5"
        property color brainWaveGamma: "#2196F3"

        // گرادیانت‌های حرفه‌ای
        property variant primaryGradient: Gradient {
            GradientStop { position: 0.0; color: "#7C4DFF" }
            GradientStop { position: 0.5; color: "#9B77FF" }
            GradientStop { position: 1.0; color: "#6A3CE8" }
        }

        property variant secondaryGradient: Gradient {
            GradientStop { position: 0.0; color: "#00BFA5" }
            GradientStop { position: 0.5; color: "#33D6BD" }
            GradientStop { position: 1.0; color: "#009E7F" }
        }

        property variant glassGradient: Gradient {
            GradientStop { position: 0.0; color: "#60FFFFFF" }
            GradientStop { position: 0.5; color: "#40FFFFFF" }
            GradientStop { position: 1.0; color: "#20FFFFFF" }
        }

        property variant backgroundGradient: Gradient {
            GradientStop { position: 0.0; color: "#FFFFFF" }
            GradientStop { position: 0.5; color: "#F8F9FF" }
            GradientStop { position: 1.0; color: "#F0F2FF" }
        }

        // Typography System - Enterprise (همانند دارک)
        property var typography: darkTheme.typography

        // Spacing System - 8px Grid (همانند دارک)
        property var spacing: darkTheme.spacing

        // Border Radius - Modern (همانند دارک)
        property var radius: darkTheme.radius

        // Elevation Shadows - Material Design
        property var elevation: QtObject {
            property var level0: "none"
            property var level1: "0 1px 3px rgba(0,0,0,0.08), 0 1px 2px rgba(0,0,0,0.12)"
            property var level2: "0 3px 6px rgba(0,0,0,0.10), 0 3px 6px rgba(0,0,0,0.15)"
            property var level3: "0 10px 20px rgba(0,0,0,0.12), 0 6px 6px rgba(0,0,0,0.15)"
            property var level4: "0 14px 28px rgba(0,0,0,0.14), 0 10px 10px rgba(0,0,0,0.12)"
            property var level5: "0 19px 38px rgba(0,0,0,0.16), 0 15px 12px rgba(0,0,0,0.12)"
        }
    }

    // سیگنال‌ها
    signal themeSwitched(string newTheme)
    signal themeTransitionStarted()
    signal themeTransitionFinished()

    // توابع عمومی
    // function toggleTheme() {
    //     themeTransitionStarted()
    //     currentTheme = currentTheme === "dark" ? "light" : "dark"
    //     console.log("🔄 Enterprise Theme toggled to:", currentTheme)
    //     themeSwitched(currentTheme)

    //     themeTransitionTimer.start()
    // }
    function getCurrentTheme() {
            console.log("🔍 Getting current theme:", currentTheme)
            return currentTheme === "light" ? lightTheme : darkTheme
        }
    // تابع toggle کاملاً اصلاح شده
        function toggleTheme() {
            console.log("🔄 ToggleTheme called")
            console.log("📊 Before toggle - currentTheme:", currentTheme)

            if (currentTheme === "dark") {
                console.log("🌞 Switching to LIGHT theme")
                currentTheme = "light"
            } else {
                console.log("🌙 Switching to DARK theme")
                currentTheme = "dark"
            }

            console.log("✅ After toggle - currentTheme:", currentTheme)

            // اطلاع‌رسانی تغییر تم
            themeSwitched(currentTheme)

            // فورس به‌روزرسانی property theme
            theme = getCurrentTheme()
        }

    // function setTheme(themeName) {
    //     if (themeName === "dark" || themeName === "light") {
    //         themeTransitionStarted()
    //         currentTheme = themeName
    //         console.log("🎨 Enterprise Theme set to:", themeName)
    //         themeSwitched(themeName)

    //         themeTransitionTimer.start()
    //     }
    // }

        function setTheme(themeName) {
                console.log("🎨 SetTheme called with:", themeName)

                if (themeName !== currentTheme && (themeName === "dark" || themeName === "light")) {
                    currentTheme = themeName
                    theme = getCurrentTheme()
                    themeSwitched(currentTheme)
                    console.log("🚀 Theme set to:", currentTheme)
                } else {
                    console.log("ℹ️ Theme already set to or invalid:", themeName)
                }
            }


    function getThemeColor(colorName) {
        return theme[colorName] || "#FF0000"
    }

    function isDarkTheme() {
        return currentTheme === "dark"
    }

    function getContrastText(backgroundColor) {
        var r = backgroundColor.r * 255
        var g = backgroundColor.g * 255
        var b = backgroundColor.b * 255
        var brightness = (r * 299 + g * 587 + b * 114) / 1000
        return brightness > 128 ? "#1A1A2E" : "#FFFFFF"
    }

    // Utility functions for professional UI
    function getGlassEffect(color) {
        return themeManager.currentTheme === "dark" ?
            color + "20" : color + "40"
    }

    function getElevationShadow(level) {
        return theme.elevation[level] || theme.elevation.level1
    }

    function getTextStyle(style) {
        return theme.typography[style] || theme.typography.body1
    }

    // تایمر برای transition
    Timer {
        id: themeTransitionTimer
        interval: themeManager.transitionDuration
        onTriggered: {
            themeSwitched(themeManager.currentTheme)
            themeTransitionFinished()
            console.log("✅ Enterprise Theme transition completed")
        }
    }

    Component.onCompleted: {
        console.log("🎨 Enterprise Premium ThemeManager initialized")
        console.log("   Current theme:", currentTheme)
        console.log("   Transition duration:", transitionDuration, "ms")
        console.log("   Glass opacity:", glassOpacity)
        console.log("   Professional Neuro-Tech palette loaded")
    }
}
