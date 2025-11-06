import QtQuick
import QtQuick.Controls

// وارد کردن کامپوننت‌های مورد نیاز
import "./workspace"
import "./bci_panels"


Item {
    id: workspaceRoot

    // چیدمان سه‌ستونی اصلی
    SplitView {
        id: splitView
        anchors.fill: parent
        orientation: Qt.Horizontal

        // استایل سفارشی برای دستگیره جداکننده پنل‌ها
        handle: Rectangle {
            implicitWidth: 3
            color: themeManager.backgroundDark
            Rectangle {
                width: 1
                anchors.fill: parent
                anchors.leftMargin: 1
                anchors.rightMargin: 1
                color: themeManager.secondary
            }
        }

        // ستون چپ: جعبه ابزار (Toolbox)
        ToolboxView {
            id: toolbox
            SplitView.preferredWidth: 280
            SplitView.minimumWidth: 200
        }

        // ستون وسط: بوم طراحی (Canvas)
        CanvasView {
            id: canvas
            SplitView.fillWidth: true

            // اتصال به سیگنال onNodeSelected از Canvas با سینتکس صحیح
            onNodeSelected: (nodeProperties) => {
                // پراپرتی selectedNode در PropertiesView را به‌روز کن
                propertiesView.selectedNode = nodeProperties;

                // اگر در یک پنل BCI هستیم (عمق پشته > 1)، با pop به PropertiesView برگرد
                if (rightPanelStack.depth > 1) {
                    rightPanelStack.pop();
                }
            }
        }

        // ستون راست: پنل‌های پویا با استفاده از StackView
        StackView {
            id: rightPanelStack
            SplitView.preferredWidth: 350
            SplitView.minimumWidth: 260

            // آیتم اولیه و پیش‌فرض پشته، پنل خصوصیات است
            initialItem: PropertiesView {
                id: propertiesView
            }
        }
    }

    // دکمه موقت برای تست و جابجایی بین پنل‌های سمت راست
    Button {
        id: togglePanelButton
        text: "Toggle BCI Panel"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
        z: 1 // اطمینان از اینکه دکمه روی بقیه اجزا قرار می‌گیرد

        onClicked: {
            // منطق ناوبری با استفاده از push/pop در StackView
            if (rightPanelStack.depth > 1) {
                // اگر در یک صفحه داخلی هستیم، به صفحه اول (Properties) برگرد
                rightPanelStack.pop();
            } else {
                // اگر در صفحه اول هستیم، صفحه P300 را روی آن push کن
                rightPanelStack.push(p300Component);
            }
        }
    }

    // کامپوننت برای ساخت نمونه جدید از پنل P300 به صورت پویا
    Component {
        id: p300Component
        P300SpellerInterface {}
    }
}
