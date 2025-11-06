import QtQuick
import QtQuick.Layouts

Rectangle {
    id: experimentItem
    
    property string paradigm: ""
    property string subject: ""
    property string date: ""
    property string accuracy: ""
    
    height: 70
    radius: 6
    color: "#252540"
    border.color: "#333344"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 4
        
        RowLayout {
            Text {
                text: experimentItem.paradigm
                color: getParadigmColor(experimentItem.paradigm)
                font.bold: true
                font.pixelSize: 12
                font.family: "Segoe UI"
                Layout.fillWidth: true
            }
            
            Text {
                text: experimentItem.accuracy
                color: getAccuracyColor(experimentItem.accuracy)
                font.bold: true
                font.pixelSize: 12
                font.family: "Segoe UI"
            }
        }
        
        Text {
            text: "Subject: " + experimentItem.subject
            color: "#AAAAAA"
            font.pixelSize: 10
            font.family: "Segoe UI"
        }
        
        Text {
            text: experimentItem.date
            color: "#666677"
            font.pixelSize: 9
            font.family: "Segoe UI"
        }
    }
    
    function getParadigmColor(paradigm) {
        switch(paradigm) {
            case "P300": return "#7C4DFF"
            case "SSVEP": return "#00BFA5"
            case "Motor Imagery": return "#FF6D00"
            case "ERP": return "#2962FF"
            default: return "#AAAAAA"
        }
    }
    
    function getAccuracyColor(accuracy) {
        var value = parseInt(accuracy)
        if (value >= 90) return "#00C853"
        if (value >= 80) return "#FFA000"
        return "#F44336"
    }
}