import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects  // برای Qt 6

Rectangle {
    id: accessCard
    
    property string title: ""
    property string description: ""
    property string icon: ""
    //property color color: "#7C4DFF"
    property string stats: ""
    property string status: ""
    property color statusColor: "#00C853"
    
    signal clicked()

    height: 140
    radius: 12
    color: "transparent"
    border.color: accessCard.color
    border.width: 1
    
    layer.enabled: true
    layer.effect: DropShadow {
        transparentBorder: true
        horizontalOffset: 0
        verticalOffset: 4
        radius: 12
        samples: 25
        color: "#40000000"
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        
        onEntered: {
            hoverAnim.start()
        }
        onExited: {
            resetAnim.start()
        }
        onClicked: accessCard.clicked()
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        
        // Icon
        Rectangle {
            width: 50
            height: 50
            radius: 10
            color: accessCard.color
            
            Text {
                text: accessCard.icon
                font.pixelSize: 20
                color: "white"
                anchors.centerIn: parent
            }
        }

        // Content
        ColumnLayout {
            spacing: 6
            Layout.fillWidth: true
            
            RowLayout {
                Text {
                    text: accessCard.title
                    color: "white"
                    font.bold: true
                    font.pixelSize: 16
                    font.family: "Segoe UI"
                    Layout.fillWidth: true
                }
                
                StatusBadge {
                    text: accessCard.status
                    color: accessCard.statusColor
                }
            }
            
            Text {
                text: accessCard.description
                color: "#AAAAAA"
                font.pixelSize: 12
                font.family: "Segoe UI"
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
            
            Text {
                text: accessCard.stats
                color: accessCard.color
                font.pixelSize: 11
                font.bold: true
                font.family: "Segoe UI"
            }
        }

        // Action Arrow
        Text {
            text: "→"
            color: accessCard.color
            font.pixelSize: 18
            font.bold: true
        }
    }

    // Hover Animations
    SequentialAnimation {
        id: hoverAnim
        ParallelAnimation {
            NumberAnimation {
                target: accessCard
                property: "scale"
                from: 1.0
                to: 1.02
                duration: 200
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: accessCard
                property: "border.width"
                from: 1
                to: 2
                duration: 200
            }
        }
    }

    SequentialAnimation {
        id: resetAnim
        ParallelAnimation {
            NumberAnimation {
                target: accessCard
                property: "scale"
                from: 1.02
                to: 1.0
                duration: 200
                easing.type: Easing.OutCubic
            }
            NumberAnimation {
                target: accessCard
                property: "border.width"
                from: 2
                to: 1
                duration: 200
            }
        }
    }
}
