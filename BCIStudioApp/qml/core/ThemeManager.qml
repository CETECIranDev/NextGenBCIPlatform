import QtQuick

QtObject {
    id: themeManager

    property string currentTheme: "dark"

    // تم فعال
    property var theme: currentTheme === "light" ? lightTheme : darkTheme

    // تم دارک - فقط color properties ساده
    property var darkTheme: QtObject {
        // رنگ‌های اصلی
        property color primary: "#0d8bfd"
        property color primaryDark: "#0a6bc7"
        property color primaryLight: "#3aa1ff"

        property color secondary: "#866aaf"
        property color secondaryDark: "#6c558c"
        property color secondaryLight: "#9f87c5"

        property color accent: "#ff6b9d"
        property color accentDark: "#e05587"
        property color accentLight: "#ff8cb4"

        property color success: "#00d46a"
        property color warning: "#ffb300"
        property color error: "#ff4757"
        property color info: "#2f80ed"

        // پس‌زمینه‌ها
        property color backgroundPrimary: "#0a0a12"
        property color backgroundSecondary: "#12121a"
        property color backgroundTertiary: "#1a1a24"
        property color backgroundCard: "#1e1f2a"
        property color backgroundElevated: "#282936"

        // متن‌ها
        property color textPrimary: "#d9d9d9"
        property color textSecondary: "#a0a0b0"
        property color textTertiary: "#6b6b80"
        property color textDisabled: "#4a4a5a"

        // border و divider
        property color border: "#333344"
        property color borderLight: "#3a3a4a"
        property color divider: "#2a2a3a"

        // رنگ‌های ویژه
        property color overlay: "#800a0a12"
        property color backdrop: "#cc000000"

        // Brain Wave Colors
        property color brainWaveAlpha: "#0d8bfd"
        property color brainWaveBeta: "#ff6b9d"
        property color brainWaveTheta: "#ffb300"
        property color brainWaveDelta: "#00d46a"
        property color brainWaveGamma: "#866aaf"
    }

    // تم لایت ساده شده
    property var lightTheme: QtObject {
        // رنگ‌های اصلی
        property color primary: "#0d8bfd"
        property color primaryDark: "#0a6bc7"
        property color primaryLight: "#3aa1ff"

        property color secondary: "#866aaf"
        property color secondaryDark: "#6c558c"
        property color secondaryLight: "#9f87c5"

        property color accent: "#ff6b9d"
        property color accentDark: "#e05587"
        property color accentLight: "#ff8cb4"

        property color success: "#00d46a"
        property color warning: "#ffb300"
        property color error: "#ff4757"
        property color info: "#2f80ed"

        // پس‌زمینه‌ها
        property color backgroundPrimary: "#ffffff"
        property color backgroundSecondary: "#f8f9fa"
        property color backgroundTertiary: "#f1f3f5"
        property color backgroundCard: "#ffffff"
        property color backgroundElevated: "#ffffff"

        // متن‌ها
        property color textPrimary: "#1a1a1a"
        property color textSecondary: "#666666"
        property color textTertiary: "#999999"
        property color textDisabled: "#cccccc"

        // border و divider
        property color border: "#e0e0e0"
        property color borderLight: "#f0f0f0"
        property color divider: "#f5f5f5"

        // رنگ‌های ویژه
        property color overlay: "#80ffffff"
        property color backdrop: "#40000000"

        // Brain Wave Colors
        property color brainWaveAlpha: "#0d8bfd"
        property color brainWaveBeta: "#ff6b9d"
        property color brainWaveTheta: "#ffb300"
        property color brainWaveDelta: "#00d46a"
        property color brainWaveGamma: "#866aaf"
    }

    signal themeSwitched

    function toggleTheme() {
        currentTheme = currentTheme === "dark" ? "light" : "dark"
        console.log("Theme toggled to:", currentTheme)
        themeSwitched()
    }

    function setTheme(themeName) {
        if (themeName === "dark" || themeName === "light") {
            currentTheme = themeName
            console.log("Theme set to:", themeName)
            themeSwitched()
        }
    }

    Component.onCompleted: {
        console.log("ThemeManager initialized with theme:", currentTheme)
    }
}
