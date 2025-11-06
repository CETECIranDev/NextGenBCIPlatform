import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: searchBox
    height: 35
    placeholderText: "🔍 Search nodes..."
    placeholderTextColor: appTheme.textDisabled
    
    background: Rectangle {
        color: appTheme.backgroundCard
        radius: 6
        border.color: searchBox.activeFocus ? appTheme.primary : appTheme.border
        border.width: 1
    }
    
    color: appTheme.textPrimary
    font.pixelSize: 12
    selectByMouse: true
    
    // دکمه پاک کردن
    Button {
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.verticalCenter: parent.verticalCenter
        width: 20
        height: 20
        text: "✕"
        visible: searchBox.text.length > 0
        font.pixelSize: 10
        background: Rectangle {
            color: "transparent"
        }
        onClicked: {
            searchBox.text = ""
            searchBox.focus = true
        }
    }
    
    // کلیدهای میانبر
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Escape) {
            searchBox.text = ""
            searchBox.focus = false
        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            searchBox.focus = false
        }
    }
}