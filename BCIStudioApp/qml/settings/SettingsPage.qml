import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Card {
    title: "Appearance"
    icon: "🎨"
    
    ColumnLayout {
        anchors.fill: parent
        spacing: theme.spacing.lg
        
        Text {
            text: "Theme"
            color: theme.textPrimary
            font.bold: true
            font.pixelSize: theme.typography.h5.size
        }
        
        // انتخاب تم
        RowLayout {
            Layout.fillWidth: true
            spacing: theme.spacing.md
            
            ThemePreviewCard {
                themeName: "dark"
                isSelected: themeManager.currentTheme === "dark"
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                onClicked: themeManager.setTheme("dark")
            }
            
            ThemePreviewCard {
                themeName: "light" 
                isSelected: themeManager.currentTheme === "light"
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                onClicked: themeManager.setTheme("light")
            }
        }
        
        // تنظیمات اضافی
        ColumnLayout {
            Layout.fillWidth: true
            spacing: theme.spacing.md
            
            Text {
                text: "Additional Settings"
                color: theme.textPrimary
                font.bold: true
                font.pixelSize: theme.typography.h6.size
            }
            
            CheckBox {
                text: "Auto-detect system theme"
                checked: themeManager.autoSwitch
                onCheckedChanged: themeManager.autoSwitch = checked
            }
            
            Slider {
                Layout.fillWidth: true
                from: 100
                to: 1000
                value: themeManager.transitionDuration
                onValueChanged: themeManager.transitionDuration = value
                
                Label {
                    text: "Transition speed: " + Math.round(parent.value) + "ms"
                    color: theme.textSecondary
                    anchors.bottom: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}