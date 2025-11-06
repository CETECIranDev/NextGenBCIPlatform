// qml/core/themes/DarkTheme.qml
import QtQuick

QtObject {
    id: darkTheme

    // رنگ‌های اصلی
    property color primary: "#7C4DFF"      // بنفش روشن
    property color primaryLight: "#9C79FF" // بنفش روشن‌تر
    property color primaryDark: "#5D3FD9"  // بنفش تیره
    property color secondary: "#00E5FF"    // فیروزه‌ای
    property color accent: "#FF4081"       // صورتی

    // رنگ‌های پس‌زمینه
    property color backgroundPrimary: "#0A0A0F"   // مشکی آبی‌فام
    property color backgroundSecondary: "#12121A" // مشکی مایل به بنفش
    property color backgroundCard: "#1E1E28"      // بنفش بسیار تیره
    property color backgroundLight: "#2A2A36"     // بنفش تیره
    property color surface: "#252531"             // سطح

    // رنگ‌های متن
    property color textPrimary: "#FFFFFF"         // سفید خالص
    property color textSecondary: "#B4B4CC"       // بنفش روشن
    property color textDisabled: "#6B6B80"        // بنفش خاکستری
    property color textInverted: "#0A0A0F"        // متن روی زمینه رنگی

    // رنگ‌های وضعیت
    property color success: "#4CD964"             // سبز روشن
    property color warning: "#FF9500"             // نارنجی
    property color error: "#FF3B30"               // قرمز
    property color info: "#007AFF"                // آبی
    property color attention: "#FFD60A"           // زرد طلایی

    // رنگ‌های رابط
    property color border: "#3A3A4D"              // حاشیه
    property color divider: "#2D2D3A"             // جداکننده
    property color overlay: "rgba(0, 0, 0, 0.7)"  // overlay
    property color shadow: "rgba(0, 0, 0, 0.3)"   // سایه

    // گرادیان‌های ویژه BCI (به صورت تابع)
    function getNeuroGradient() {
        return Qt.createQmlObject('import QtQuick; Gradient { \
            GradientStop { position: 0.0; color: "#7C4DFF" } \
            GradientStop { position: 0.5; color: "#00E5FF" } \
            GradientStop { position: 1.0; color: "#FF4081" } \
        }', darkTheme);
    }

    function getCardGradient() {
        return Qt.createQmlObject('import QtQuick; Gradient { \
            GradientStop { position: 0.0; color: "#1E1E28" } \
            GradientStop { position: 1.0; color: "#252531" } \
        }', darkTheme);
    }

    function getHeaderGradient() {
        return Qt.createQmlObject('import QtQuick; Gradient { \
            GradientStop { position: 0.0; color: "rgba(124, 77, 255, 0.1)" } \
            GradientStop { position: 1.0; color: "transparent" } \
        }', darkTheme);
    }

    // سایه‌ها
    property var shadowSmall: Qt.object({
        "color": "#40000000",
        "radius": 8,
        "offset": 2
    })

    property var shadowMedium: Qt.object({
        "color": "#60000000",
        "radius": 16,
        "offset": 4
    })

    property var shadowLarge: Qt.object({
        "color": "#80000000",
        "radius": 24,
        "offset": 8
    })

    // انیمیشن‌ها
    property int durationFast: 200
    property int durationNormal: 400
    property int durationSlow: 600

    property var easingStandard: Easing.OutCubic
    property var easingEmphasized: Easing.OutBack
}
