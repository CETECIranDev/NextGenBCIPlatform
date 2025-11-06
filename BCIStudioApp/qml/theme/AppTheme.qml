import QtQuick

// pragma Singleton تضمین می‌کند که فقط یک نمونه از این شیء در کل برنامه وجود خواهد داشت
// و می‌توان آن را از هر جای QML بدون نیاز به import صریح فایل، با نام AppTheme فراخوانی کرد.
// (الب-ته ما برای اطمینان و خوانایی از import با alias استفاده می‌کنیم)
pragma Singleton

QtObject {
    id: appTheme

    // =============================================================================
    // --- مدیریت وضعیت تم ---
    // =============================================================================

    // سیگنالی که هر زمان تم تغییر می‌کند، منتشر می‌شود.
    // کامپوننت‌های دیگر (مانند main.qml) می‌توانند به این سیگنال متصل شوند.
    signal themeChanged()

    // پراپرتی برای نگهداری وضعیت فعلی تم.
    // 0 = روشن (Light), 1 = تیره (Dark)
    // پیش‌فرض را روی تیره تنظیم می‌کنیم.
    property int currentTheme: 1

    // تابعی برای تغییر وضعیت تم
    function toggleTheme() {
        // وضعیت را بین 0 و 1 جابجا می‌کند
        root.currentTheme = (root.currentTheme === 1) ? 0 : 1;

        // سیگنال را منتشر می‌کند تا به بقیه برنامه اطلاع دهد
        root.themeChanged();
    }


    // =============================================================================
    // --- پالت‌های رنگ ثابت ---
    // =============================================================================

    // پالت رنگ برای تم روشن
    readonly property var lightPalette: {
        "backgroundDark": "#F0F0F0",      // پس‌زمینه اصلی
        "backgroundMedium": "#FAFAFA",    // پس‌زمینه پنجره‌ها و محتوا
        "backgroundLight": "#FFFFFF",     // پس‌زمینه آیتم‌های هاور شده
        "surfaceDark": "#EAEAEA",        // پس‌زمینه پنل‌ها
        "surfaceLight": "#FFFFFF",        // پس‌زمینه دکمه‌ها و آیتم‌های برجسته
        "primary": "#005FB8",           // رنگ اصلی (آبی)
        "primaryHover": "#007ACC",      // رنگ اصلی هنگام هاور
        "secondary": "#BDBDBD",          // رنگ جداکننده‌ها و حاشیه‌ها
        "textPrimary": "#1E1E1E",        // رنگ متن اصلی (تیره)
        "textSecondary": "#6E6E6E",      // رنگ متن ثانویه (خاکستری)
        "textOnPrimary": "#FFFFFF"        // رنگ متن روی پس‌زمینه اصلی (سفید)
    }

    // پالت رنگ برای تم تیره
    readonly property var darkPalette: {
        "backgroundDark": "#1E1E1E",
        "backgroundMedium": "#252526",
        "backgroundLight": "#333333",
        "surfaceDark": "#2D2D2D",
        "surfaceLight": "#3C3C3C",
        "primary": "#007ACC",
        "primaryHover": "#209CFF",
        "secondary": "#6E6E6E",
        "textPrimary": "#CCCCCC",
        "textSecondary": "#8B8B8B",
        "textOnPrimary": "#FFFFFF"
    }


    // =============================================================================
    // --- پراپرتی‌های رنگ پویا ---
    // =============================================================================
    // این پراپرتی‌ها به صورت خودکار بر اساس مقدار currentTheme به‌روز می‌شوند.
    // این قدرت سیستم binding در QML است.
    property color backgroundDark: appTheme.currentTheme === 1 ? darkPalette.backgroundDark : lightPalette.backgroundDark
    property color backgroundMedium: appTheme.currentTheme === 1 ? darkPalette.backgroundMedium : lightPalette.backgroundMedium
    property color backgroundLight: appTheme.currentTheme === 1 ? darkPalette.backgroundLight : lightPalette.backgroundLight
    property color surfaceDark: appTheme.currentTheme === 1 ? darkPalette.surfaceDark : lightPalette.surfaceDark
    property color surfaceLight: appTheme.currentTheme === 1 ? darkPalette.surfaceLight : lightPalette.surfaceLight
    property color primary: appTheme.currentTheme === 1 ? darkPalette.primary : lightPalette.primary
    property color primaryHover: appTheme.currentTheme === 1 ? darkPalette.primaryHover : lightPalette.primaryHover
    property color secondary: appTheme.currentTheme === 1 ? darkPalette.secondary : lightPalette.secondary
    property color textPrimary: appTheme.currentTheme === 1 ? darkPalette.textPrimary : lightPalette.textPrimary
    property color textSecondary: appTheme.currentTheme === 1 ? darkPalette.textSecondary : lightPalette.textSecondary
    property color textOnPrimary: appTheme.currentTheme === 1 ? darkPalette.textOnPrimary : lightPalette.textOnPrimary


    // =============================================================================
    // --- فونت‌ها و اندازه‌ها (معمولاً ثابت هستند) ---
    // =============================================================================
    readonly property font fontSmall: Qt.font({ family: "Segoe UI", pointSize: 9 })
    readonly property font fontBase: Qt.font({ family: "Segoe UI", pointSize: 11 })
    readonly property font fontLarge: Qt.font({ family: "Segoe UI", pointSize: 18, bold: true })
    readonly property font fontDisplay: Qt.font({ family: "Segoe UI", pointSize: 32, bold: true })

    readonly property int radiusSmall: 4
    readonly property int radiusMedium: 8
    readonly property int spacingSmall: 4
    readonly property int spacingMedium: 8
    readonly property int spacingLarge: 16
    readonly property int borderWidth: 1
}
