import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

// =============================================================================
// --- وارد کردن کامپوننت‌های محلی با مسیر نسبی و نام مستعار (Alias) ---
// =============================================================================
// این روش پایدارترین راه برای وارد کردن کامپوننت‌های سفارشی است.
//import "./theme"
import "./views"
import "./views/workspace"
import QtQuick.Controls
import QtQuick.Window


// =============================================================================
// --- پنجره اصلی برنامه ---
// =============================================================================
ApplicationWindow {
    id: root

    // --- خصوصیات اصلی پنجره ---
    width: 1280
    height: 800
    minimumWidth: 1024
    minimumHeight: 768
    visible: true
    title: "BCI Studio"

    // --- اتصال به تم سراسری ---
    color: themeManager.backgroundDark
    font: themeManager.fontBase

    // --- مدیریت تم Material برای کنترل‌های استاندارد ---
    // این بخش تضمین می‌کند که کنترل‌هایی مانند Button، TextField و ...
    // با تم کلی برنامه (روشن/تیره) هماهنگ باشند.
    Connections {
        target: themeManager
        function onThemeChanged() {
            Material.theme = (themeManager.currentTheme === 1) ? Material.Dark : Material.Light;
        }
    }
    // مقدار اولیه تم را پس از ساخته شدن کامل کامپوننت تنظیم می‌کنیم.
    Component.onCompleted: {
        Material.theme = (themeManager.currentTheme === 1) ? Material.Dark : Material.Light;
    }


    // =============================================================================
    // --- نوار بالایی (Header/Toolbar) ---
    // =============================================================================
    header: Rectangle {
        id: headerBar
        height: 40
        color: themeManager.backgroundMedium

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: themeManager.spacingMedium
            spacing: themeManager.spacingLarge

            Label {
                text: "File"
                color: themeManager.textPrimary
                font: themeManager.fontBase
            }
            Label {
                text: "Edit"
                color: themeManager.textPrimary
                font: themeManager.fontBase
            }
            Label {
                text: "View"
                color: themeManager.textPrimary
                font: themeManager.fontBase
            }
        }
    }
    TabBar {
           id: mainTabBar
           anchors.fill: parent

           TabButton {
               text: "home"


           }
           TabButton {
               text: "Workspace"


           }

           TabButton {
               text: "Dashboard"


                   // ...

           }
       }

    // =============================================================================
    // --- محتوای اصلی برنامه ---
    // =============================================================================
    // از StackLayout استفاده می‌کنیم تا بین صفحه خوشامدگویی و محیط کاری جابجا شویم.
    StackLayout {
        id: mainStack
        anchors.fill: parent
        //currentIndex: 0 // در ابتدا صفحه خوشامدگویی (اندیس 0) نمایش داده می‌شود
        currentIndex: mainTabBar.currentIndex


        // --- صفحه خوشامدگویی (اندیس 0) ---
        WelcomeView {
            id: welcomeView

            // وقتی روی دکمه "New Project" در WelcomeView کلیک می‌شود، این سیگنال منتشر می‌شود.
            // ما این سیگنال را در WelcomeView.qml تعریف خواهیم کرد.
            onNewProjectClicked: {
                // ایندکس StackLayout را به 1 تغییر می‌دهیم تا WorkspaceView نمایش داده شود.
                mainStack.currentIndex = 1;
                root.title = "BCI Studio - Untitled Project"; // عنوان پنجره را به‌روز می‌کنیم
            }
        }

        // --- محیط کاری (اندیس 1) ---
        DashboardView {
            id: workspaceView
        }

        DashboardView {
            id: dashboardView
        }
    }


    // =============================================================================
    // --- نوار پایینی (Footer/StatusBar) ---
    // =============================================================================
    // =============================================================================
       // --- نوار پایینی (Footer/StatusBar) ---
       // =============================================================================
       footer: Rectangle {
           id: footerBar
           height: 28
           color: themeManager.backgroundMedium

           RowLayout {
               anchors.fill: parent
               anchors.leftMargin: themeManager.spacingMedium
               anchors.rightMargin: themeManager.spacingMedium
               spacing: themeManager.spacingMedium

               // برچسب وضعیت
               Label {
                   id: statusLabel
                   text: "Ready"
                   color: themeManager.textSecondary
                   // این پراپرتی به RowLayout می‌گوید که این آیتم باید تمام فضای اضافی را پر کند
                   Layout.fillWidth: true
                   verticalAlignment: Text.AlignVCenter
               }

               // --- دکمه تعویض تم (روشن/تیره) ---
               Button {
                   id: themeToggleButton

                   // آیکون دکمه به صورت پویا بر اساس تم فعلی تغییر می‌کند
                   icon.source: themeManager.currentTheme === 1 ? "qrc:/qml/assets/icons/sun.svg" : "qrc:/qml/assets/icons/moon.svg"
                   display: AbstractButton.IconOnly
                   flat: true // حذف پس‌زمینه و سایه برای ظاهر تمیزتر

                   // از پراپرتی‌های Layout برای تعیین اندازه استفاده می‌کنیم
                   Layout.preferredHeight: parent.height - 4
                   Layout.preferredWidth: Layout.preferredHeight

                   // با کلیک، تابع تعویض تم در C++ فراخوانی می‌شود
                   onClicked: themeManager.toggleTheme()

                   background: Rectangle {
                       color: themeToggleButton.hovered ? themeManager.surfaceLight : "transparent"
                       radius: 4 // themeManager.radiusSmall
                   }
               }
           }
       }
}
