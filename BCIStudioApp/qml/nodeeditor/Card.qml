import QtQuick 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: card
    radius: 12
    color: appTheme.backgroundCard
    border.color: appTheme.border
    border.width: 1

    property alias padding: contentContainer.padding
    property alias spacing: contentContainer.spacing
    default property alias content: contentContainer.data

    property int elevation: 1
    property bool hoverable: false
    property bool clickable: false
    signal clicked()

    // سیستم سایه با چند لایه
    Rectangle {
        id: shadowLayer1
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        opacity: getShadowOpacity(1)

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: parent.radius - 1
            color: "#20000000"
        }
    }

    Rectangle {
        id: shadowLayer2
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        opacity: getShadowOpacity(2)

        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            radius: parent.radius - 2
            color: "#15000000"
        }
    }

    Rectangle {
        id: shadowLayer3
        anchors.fill: parent
        radius: parent.radius
        color: "transparent"
        opacity: getShadowOpacity(3)

        Rectangle {
            anchors.fill: parent
            anchors.margins: 3
            radius: parent.radius - 3
            color: "#10000000"
        }
    }

    // محتوای اصلی
    Item {
        id: contentContainer
        anchors.fill: parent
        anchors.margins: card.padding || 16

        property real padding: 16
        property real spacing: 8
    }

    // برای کارت‌های قابل کلیک
    MouseArea {
        anchors.fill: parent
        enabled: card.clickable
        cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        hoverEnabled: card.hoverable

        onEntered: if (card.hoverable) card.state = "HOVERED"
        onExited: if (card.hoverable) card.state = ""
        onPressed: if (card.hoverable) card.state = "PRESSED"
        onReleased: if (card.hoverable) card.state = containsMouse ? "HOVERED" : ""
        onClicked: if (card.clickable) card.clicked()
    }

    // حالت‌های مختلف
    states: [
        State {
            name: "HOVERED"
            PropertyChanges {
                target: card
                color: Qt.darker(appTheme.backgroundCard, 1.03)
                scale: 1.01
            }
            PropertyChanges {
                target: card
                elevation: 2
            }
        },
        State {
            name: "PRESSED"
            PropertyChanges {
                target: card
                color: Qt.darker(appTheme.backgroundCard, 1.06)
                scale: 0.99
            }
        },
        State {
            name: "ELEVATED"
            PropertyChanges {
                target: card
                elevation: 3
            }
        }
    ]

    // انیمیشن‌ها
    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Behavior on scale {
        NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
    }

    Behavior on elevation {
        NumberAnimation { duration: 200 }
    }

    // تابع برای محاسبه opacity سایه
    function getShadowOpacity(layer) {
        var baseOpacity = [0, 0.3, 0.5, 0.7] // opacity برای elevationهای مختلف
        var currentElevation = Math.min(card.elevation, 3)
        return baseOpacity[currentElevation] * (1 - (layer - 1) * 0.3)
    }

    // توابع عمومی
    function elevate(level) {
        card.elevation = level || 3
    }

    function normalize() {
        card.elevation = 1
    }
}
