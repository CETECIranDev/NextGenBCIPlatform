import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Pane {
    background: Rectangle { color: themeManager.surfaceDark }
    
    // مدل ساختگی برای وضعیت Speller
    property string spellerOutputText: "HELLO"
    property string spellerStatus: "Status: Running - Trial 5/10"
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        // --- بخش کنترل جلسه ---
        Label {
            text: "P300 Speller Control"
            font: themeManager.fontLarge
            color: themeManager.primary
        }

        RowLayout {
            spacing: 8
            Button { text: "Start Calibration" }
            // Button { text: "Start Free Spelling"; Csn.accent: Material.Green }
            // Button { text: "Stop"; Csn.accent: Material.Red }
        }
        
        Label {
            text: spellerStatus
            color: themeManager.textSecondary
            font: themeManager.fontBase
        }
        
        // --- جداکننده ---
        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: themeManager.secondary
            Layout.topMargin: 8
            Layout.bottomMargin: 8
        }

        // --- بخش خروجی ---
        Label { text: "Speller Output:"; font: themeManager.fontBase }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            color: themeManager.backgroundDark
            border.color: themeManager.secondary
            radius: 4
            
            Flickable {
                anchors.fill: parent
                anchors.margins: 4
                contentWidth: width; contentHeight: outputTextLabel.height
                clip: true
                
                Label {
                    id: outputTextLabel
                    text: spellerOutputText
                    color: themeManager.textPrimary
                    font.pixelSize: 24
                    wrapMode: Text.WordWrap
                }
            }
        }
        
        // --- بخش پیش‌نمایش ماتریس ---
        Label { text: "Stimulus Preview:"; font: themeManager.fontBase; Layout.topMargin: 8 }
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 300
            color: themeManager.backgroundMedium
            
            // یک گرید ساده برای پیش‌نمایش
            Grid {
                anchors.centerIn: parent
                rows: 6; columns: 6; spacing: 5
                
                Repeater {
                    model: ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","1","2","3","4","5","6","7","8","9","_"]
                    
                    Rectangle {
                        width: 40; height: 40
                        color: themeManager.surfaceDark
                        radius: 4
                        
                        Label {
                            anchors.centerIn: parent
                            text: modelData
                            color: themeManager.textPrimary
                            font.bold: true
                        }
                    }
                }
            }
        }
    }
}
