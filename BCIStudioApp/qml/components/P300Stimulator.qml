import QtQuick
import QtQuick.Controls

Item {
    id: root
    property bool isFlashing: false // برای کنترل شروع و توقف فلش زدن

    // مدل ماتریس
    readonly property var matrix: [
        ["A","B","C","D","E","F"],
        ["G","H","I","J","K","L"],
        ["M","N","O","P","Q","R"],
        ["S","T","U","V","W","X"],
        ["Y","Z","1","2","3","4"],
        ["5","6","7","8","9","_"]
    ]
    
    // متغیرهای کنترل انیمیشن فلش
    property int currentFlashIndex: -1 // -1 means no flash, 0-5 for rows, 6-11 for columns
    
    Timer {
        id: flashTimer
        interval: 125 // سرعت فلش زدن (8 Hz)
        repeat: true
        running: root.isFlashing
        onTriggered: {
            // یک سطر یا ستون تصادفی را انتخاب کن
            root.currentFlashIndex = Math.floor(Math.random() * 12);
            // TODO: Send marker to C++ backend here!
            // console.log("Flashing index:", root.currentFlashIndex)
        }
    }

    Rectangle { // پس‌زمینه تیره برای حداکثر کنتراست
        anchors.fill: parent
        color: "black"
    }

    Grid {
        id: characterGrid
        anchors.centerIn: parent
        rows: 6; columns: 6; spacing: 10
        
        Repeater {
            model: 36 // 6x6 grid
            
            delegate: Rectangle {
                id: cell
                
                // محاسبه اینکه آیا این سلول در سطر/ستون در حال فلش است
                property int rowIndex: Math.floor(index / 6)
                property int colIndex: index % 6
                property bool shouldFlash: (root.currentFlashIndex === rowIndex) || (root.currentFlashIndex === colIndex + 6)

                width: 100; height: 100
                color: shouldFlash ? "white" : "#222222"
                radius: 8
                
                Label {
                    anchors.centerIn: parent
                    text: root.matrix[cell.rowIndex][cell.colIndex]
                    color: cell.shouldFlash ? "black" : "white"
                    font.pixelSize: 64
                    font.bold: true
                }
            }
        }
    }
}