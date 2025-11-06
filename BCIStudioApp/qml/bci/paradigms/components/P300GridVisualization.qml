import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: gridVisualization

    property var config
    property bool experimentRunning: false
    property string targetCharacter: "A"
    property var flashSequence: []

    signal characterSelected(string character)

    color: "transparent"

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 20
        width: Math.min(600, parent.width * 0.9)
        height: Math.min(600, parent.height * 0.9)

        // Header
        Text {
            text: "P300 CHARACTER SPELLER"
            color: "white"
            font.bold: true
            font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
        }

        // The Grid
        Rectangle {
            Layout.alignment: Qt.AlignCenter
            width: 500
            height: 500
            color: "#1A1A2E"
            radius: 12
            border.color: "#333344"
            border.width: 2

            Grid {
                id: characterGrid
                anchors.centerIn: parent
                columns: config.cols || 6
                spacing: 8

                Repeater {
                    model: (config.rows || 6) * (config.cols || 6)

                    P300GridItem {
                        width: 60
                        height: 60
                        character: getCharacter(index)
                        isTarget: character === targetCharacter
                        isFlashing: flashSequence.includes(index)
                        experimentRunning: gridVisualization.experimentRunning

                        onClicked: characterSelected(character)
                    }
                }
            }
        }

        // Target Display
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            width: 200
            height: 50
            radius: 8
            color: "#252540"
            border.color: "#7C4DFF"
            border.width: 2

            Text {
                text: "Target: " + targetCharacter
                color: "#7C4DFF"
                font.bold: true
                font.pixelSize: 18
                anchors.centerIn: parent
            }
        }
    }

    function getCharacter(index) {
        var chars = config.charSet.split('')
        return chars[index % chars.length]
    }

    function highlightSequence(sequence) {
        flashSequence = sequence
        flashTimer.restart()
    }

    Timer {
        id: flashTimer
        interval: config.stimulusDuration || 100
        onTriggered: flashSequence = []
    }
}
