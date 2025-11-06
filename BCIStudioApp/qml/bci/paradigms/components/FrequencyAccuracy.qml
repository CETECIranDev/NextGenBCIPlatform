import QtQuick
import QtQuick.Layouts

Rectangle {
    id: frequencyAccuracy

    property string frequency: "10 Hz"
    property real accuracy: 0.85
    property color accuracyColor: accuracy > 0.8 ? "#00C853" : "#FFA000"  // محاسبه dynamic

    height: 50
    radius: 4
    color: "#1A1A2E"  // color داخلی
    border.color: "#333344"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 5
        spacing: 2

        Text {
            text: frequencyAccuracy.frequency
            color: "#AAAAAA"
            font.pixelSize: 9
            font.bold: true
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: Math.floor(frequencyAccuracy.accuracy * 100) + "%"
            color: frequencyAccuracy.accuracyColor  // استفاده از accuracyColor
            font.bold: true
            font.pixelSize: 12
            Layout.alignment: Qt.AlignHCenter
        }

        // Mini progress bar
        Rectangle {
            Layout.fillWidth: true
            height: 3
            radius: 1.5
            color: "#333344"

            Rectangle {
                width: parent.width * frequencyAccuracy.accuracy
                height: parent.height
                radius: 1.5
                color: frequencyAccuracy.accuracyColor  // استفاده از accuracyColor
            }
        }
    }
}
