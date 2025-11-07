import QtQuick

Item {
    id: themeManager

    property string currentTheme: "dark"
    property int transitionDuration: 400
    property real glassOpacity: 0.08
    property real glassBlur: 15

    // تم فعال
    property var theme: currentTheme === "light" ? lightTheme : darkTheme

    // تم دارک Enterprise با افکت شیشه‌ای
    property var darkTheme: QtObject {
        // رنگ‌های اصلی - Professional Palette
        property color primary: "#7C4DFF"
        property color primaryDark: "#6A3CE8"
        property color primaryLight: "#9B77FF"

        property color secondary: "#00BFA5"
        property color secondaryDark: "#009E7F"
        property color secondaryLight: "#33D6BD"

        property color accent: "#FF6D00"
        property color accentDark: "#E55A00"
        property color accentLight: "#FF8A33"

        // سیستم رنگ‌ها
        property color success: "#00C853"
        property color warning: "#FFA000"
        property color error: "#F44336"
        property color info: "#2196F3"

        // پس‌زمینه‌های تیره حرفه‌ای
        property color backgroundPrimary: "#0F0F1A"
        property color backgroundSecondary: "#1A1A2E"
        property color backgroundTertiary: "#252540"
        property color backgroundCard: "#1E1F2A"
        property color backgroundElevated: "#2A2B3C"
        property color backgroundGlass: "#101020"

        // متن‌ها
        property color textPrimary: "#E8E8F0"
        property color textSecondary: "#A0A0B8"
        property color textTertiary: "#6B6B8C"
        property color textDisabled: "#4A4A66"
        property color textInverted: "#0F0F1A"

        // border و divider
        property color border: "#333344"
        property color borderLight: "#3A3A4C"
        property color divider: "#2D2D3E"
        property color glassBorder: "#404056"

        // رنگ‌های ویژه برای افکت‌ها
        property color overlay: "#800F0F1A"
        property color backdrop: "#CC000000"
        property color glow: "#207C4DFF"
        property color shadow: "#40000000"

        // Brain Wave Colors - Professional
        property color brainWaveAlpha: "#7C4DFF"
        property color brainWaveBeta: "#FF6D00"
        property color brainWaveTheta: "#FFA000"
        property color brainWaveDelta: "#00BFA5"
        property color brainWaveGamma: "#2196F3"

        // گرادیانت‌های حرفه‌ای
        property variant primaryGradient: Gradient {
            GradientStop { position: 0.0; color: "#7C4DFF" }
            GradientStop { position: 1.0; color: "#6A3CE8" }
        }

        property variant glassGradient: Gradient {
            GradientStop { position: 0.0; color: "#20FFFFFF" }
            GradientStop { position: 1.0; color: "#10FFFFFF" }
        }
    }

    // تم لایت Enterprise
    property var lightTheme: QtObject {
        // رنگ‌های اصلی - Professional Palette
        property color primary: "#7C4DFF"
        property color primaryDark: "#6A3CE8"
        property color primaryLight: "#9B77FF"

        property color secondary: "#00BFA5"
        property color secondaryDark: "#009E7F"
        property color secondaryLight: "#33D6BD"

        property color accent: "#FF6D00"
        property color accentDark: "#E55A00"
        property color accentLight: "#FF8A33"

        // سیستم رنگ‌ها
        property color success: "#00C853"
        property color warning: "#FFA000"
        property color error: "#F44336"
        property color info: "#2196F3"

        // پس‌زمینه‌های روشن حرفه‌ای
        property color backgroundPrimary: "#FFFFFF"
        property color backgroundSecondary: "#F8F9FF"
        property color backgroundTertiary: "#F0F2FF"
        property color backgroundCard: "#FFFFFF"
        property color backgroundElevated: "#FFFFFF"
        property color backgroundGlass: "#F8F9FF"

        // متن‌ها
        property color textPrimary: "#1A1A2E"
        property color textSecondary: "#4A4A6A"
        property color textTertiary: "#6B6B8C"
        property color textDisabled: "#A0A0B8"
        property color textInverted: "#FFFFFF"

        // border و divider
        property color border: "#E8E8F0"
        property color borderLight: "#F0F2FF"
        property color divider: "#F5F7FF"
        property color glassBorder: "#E0E4FF"

        // رنگ‌های ویژه برای افکت‌ها
        property color overlay: "#80FFFFFF"
        property color backdrop: "#40000000"
        property color glow: "#207C4DFF"
        property color shadow: "#20000000"

        // Brain Wave Colors - Professional
        property color brainWaveAlpha: "#7C4DFF"
        property color brainWaveBeta: "#FF6D00"
        property color brainWaveTheta: "#FFA000"
        property color brainWaveDelta: "#00BFA5"
        property color brainWaveGamma: "#2196F3"

        // گرادیانت‌های حرفه‌ای
        property variant primaryGradient: Gradient {
            GradientStop { position: 0.0; color: "#7C4DFF" }
            GradientStop { position: 1.0; color: "#9B77FF" }
        }

        property variant glassGradient: Gradient {
            GradientStop { position: 0.0; color: "#60FFFFFF" }
            GradientStop { position: 1.0; color: "#30FFFFFF" }
        }
    }

    // سیگنال‌ها
    signal themeSwitched(string newTheme)
    signal themeTransitionStarted()
    signal themeTransitionFinished()

    // توابع عمومی
    function toggleTheme() {
        themeTransitionStarted()
        currentTheme = currentTheme === "dark" ? "light" : "dark"
        console.log("🔄 Theme toggled to:", currentTheme)
        themeTransitionTimer.start()
    }

    function setTheme(themeName) {
        if (themeName === "dark" || themeName === "light") {
            themeTransitionStarted()
            currentTheme = themeName
            console.log("🎨 Theme set to:", themeName)
            themeTransitionTimer.start()
        }
    }

    function getThemeColor(colorName) {
        return theme[colorName] || "#FF0000"
    }

    function isDarkTheme() {
        return currentTheme === "dark"
    }

    function getContrastText(backgroundColor) {
        // الگوریتم ساده برای تشخیص متن با کنتراست مناسب
        var r = backgroundColor.r * 255
        var g = backgroundColor.g * 255
        var b = backgroundColor.b * 255
        var brightness = (r * 299 + g * 587 + b * 114) / 1000
        return brightness > 128 ? "#1A1A2E" : "#FFFFFF"
    }

    // تایمر برای transition
    Timer {
        id: themeTransitionTimer
        interval: themeManager.transitionDuration
        onTriggered: {
            themeSwitched(themeManager.currentTheme)
            themeTransitionFinished()
            console.log("✅ Theme transition completed")
        }
    }

    Component.onCompleted: {
        console.log("🎨 Enterprise ThemeManager initialized")
        console.log("   Current theme:", currentTheme)
        console.log("   Transition duration:", transitionDuration, "ms")
    }
}
