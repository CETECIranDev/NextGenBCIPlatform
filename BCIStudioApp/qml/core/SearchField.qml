import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: searchField
    height: 32
    radius: 6
    color: appTheme.backgroundTertiary
    border.color: searchField.activeFocus ? appTheme.primary : appTheme.border
    border.width: 1

    property string placeholderText: "Search..."
    property string text: ""
    signal searchRequested(string searchText)

    Row {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        // آیکون جستجو
        Text {
            text: "🔍"
            font.pixelSize: 12
            color: appTheme.textTertiary
            anchors.verticalCenter: parent.verticalCenter
        }

        // فیلد متن
        TextInput {
            id: textInput
            width: parent.width - 40
            anchors.verticalCenter: parent.verticalCenter
            color: appTheme.textPrimary
            font.pixelSize: 12
            selectByMouse: true
            clip: true

            onTextChanged: {
                searchField.text = text
            }

            onAccepted: {
                searchField.searchRequested(text)
            }

            // Placeholder
            Text {
                text: searchField.placeholderText
                color: appTheme.textTertiary
                font.pixelSize: 12
                visible: textInput.text === ""
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // دکمه پاک کردن
        Text {
            text: "✕"
            font.pixelSize: 10
            color: appTheme.textTertiary
            visible: textInput.text !== ""
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    textInput.text = ""
                    textInput.focus = true
                }
            }
        }
    }

    // مدیریت فوکس
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.IBeamCursor
        onClicked: textInput.focus = true
    }

    // کلیدهای میانبر
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Escape) {
            textInput.text = ""
            textInput.focus = false
        } else if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && textInput.text !== "") {
            searchField.searchRequested(textInput.text)
        }
    }
}