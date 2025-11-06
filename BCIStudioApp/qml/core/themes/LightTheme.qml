// qml/core/themes/LightTheme.qml
import QtQuick

QtObject {
    id: lightTheme

    // رنگ‌های اصلی
    property color primary: "#7C4DFF"      // بنفش (همانند دارک)
    property color primaryLight: "#9C79FF" // بنفش روشن‌تر
    property color primaryDark: "#5D3FD9"  // بنفش تیره
    property color secondary: "#0096CC"    // آبی فیروزه‌ای
    property color accent: "#E91E63"       // صورتی

    // رنگ‌های پس‌زمینه
    property color backgroundPrimary: "#F8FAFF"   // سفید آبی‌فام
    property color backgroundSecondary: "#F0F4FF" // آبی بسیار روشن
    property color backgroundCard: "#FFFFFF"      // سفید خالص
    property color backgroundLight: "#F5F7FF"     // سفید مایل به آبی
    property color surface: "#FAFBFF"             // سطح

    // رنگ‌های متن
    property color textPrimary: "#1A1A2E"         // مشکی آبی‌فام
    property color textSecondary: "#4A4A6A"       // خاکستری آبی
    property color textDisabled: "#8B8BA5"        // خاکستری روشن
    property color textInverted: "#FFFFFF"        // متن روی زمینه رنگی

    // رنگ‌های وضعیت
    property color success: "#34C759"             // سبز
    property color warning: "#FF9500"             // نارنجی
    property color error: "#FF3B30"               // قرمز
    property color info: "#007AFF"                // آبی
    property color attention: "#FFCC00"           // زرد

    // رنگ‌های رابط
    property color border: "#E5E5F0"              // حاشیه
    property color divider: "#F0F0F5"             // جداکننده
    property color overlay: "rgba(255, 255, 255, 0.8)" // overlay
    property color shadow: "rgba(0, 0, 0, 0.1)"   // سایه

    // گرادیان‌های ویژه BCI (به صورت تابع)
    function getNeuroGradient() {
        return Qt.createQmlObject('import QtQuick; Gradient { \
            GradientStop { position: 0.0; color: "#7C4DFF" } \
            GradientStop { position: 0.5; color: "#0096CC" } \
            GradientStop { position: 1.0; color: "#E91E63" } \
        }', lightTheme);
    }

    function getCardGradient() {
        return Qt.createQmlObject('import QtQuick; Gradient { \
            GradientStop { position: 0.0; color: "#FFFFFF" } \
            GradientStop { position: 1.0; color: "#F5F7FF" } \
        }', lightTheme);
    }

    function getHeaderGradient() {
        return Qt.createQmlObject('import QtQuick; Gradient { \
            GradientStop { position: 0.0; color: "rgba(124, 77, 255, 0.05)" } \
            GradientStop { position: 1.0; color: "transparent" } \
        }', lightTheme);
    }

    // سایه‌ها
    property var shadowSmall: Qt.object({
        "color": "#10000000",
        "radius": 4,
        "offset": 1
    })

    property var shadowMedium: Qt.object({
        "color": "#20000000",
        "radius": 8,
        "offset": 2
    })

    property var shadowLarge: Qt.object({
        "color": "#30000000",
        "radius": 16,
        "offset": 4
    })

    // انیمیشن‌ها
    property int durationFast: 200
    property int durationNormal: 400
    property int durationSlow: 600

    property var easingStandard: Easing.OutCubic
    property var easingEmphasized: Easing.OutBack
}
