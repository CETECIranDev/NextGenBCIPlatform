import QtQuick 2.15

Rectangle {
    id: card
    radius: 8
    color: appTheme.backgroundCard
    border.color: appTheme.border
    border.width: 1
    
    property alias padding: content.padding
    default property alias content: content.data
    
    Column {
        id: content
        anchors.fill: parent
        padding: 10
    }
    
    // سایه
    DropShadow {
        anchors.fill: parent
        source: parent
        radius: 8
        samples: 16
        color: "#20000000"
        transparentBorder: true
    }
}