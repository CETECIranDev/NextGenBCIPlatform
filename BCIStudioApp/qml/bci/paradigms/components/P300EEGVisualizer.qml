import QtQuick
import QtQuick.Layouts

Rectangle {
    id: eegVisualizer
    
    property bool experimentRunning: false
    
    color: "#1A1A2E"
    radius: 12
    border.color: "#333344"
    border.width: 2

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 8

        Text {
            text: "REAL-TIME EEG - Pz CHANNEL"
            color: "white"
            font.bold: true
            font.pixelSize: 12
            font.family: "Segoe UI"
        }

        // EEG Signal Canvas
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#0F0F1A"
            radius: 6
            border.color: "#252540"
            border.width: 1
            
            Canvas {
                id: eegCanvas
                anchors.fill: parent
                anchors.margins: 8
                
                property var signalData: []
                property int dataPoints: 200
                
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    
                    var width = eegCanvas.width
                    var height = eegCanvas.height
                    var centerY = height / 2
                    
                    // Draw grid
                    drawGrid(ctx, width, height)
                    
                    // Draw EEG signal
                    drawSignal(ctx, width, height, centerY)
                    
                    // Draw P300 markers
                    drawP300Markers(ctx, width, height)
                }
                
                function drawGrid(ctx, width, height) {
                    ctx.strokeStyle = "#252540"
                    ctx.lineWidth = 0.5
                    ctx.setLineDash([2, 2])
                    
                    // Horizontal lines
                    for (var i = 1; i <= 4; i++) {
                        var y = height * i / 5
                        ctx.beginPath()
                        ctx.moveTo(0, y)
                        ctx.lineTo(width, y)
                        ctx.stroke()
                    }
                    
                    ctx.setLineDash([])
                }
                
                function drawSignal(ctx, width, height, centerY) {
                    if (signalData.length === 0) return
                    
                    ctx.strokeStyle = "#00BFA5"
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    
                    for (var i = 0; i < signalData.length; i++) {
                        var x = (i / (signalData.length - 1)) * width
                        var y = centerY - signalData[i] * height * 0.4
                        
                        if (i === 0) {
                            ctx.moveTo(x, y)
                        } else {
                            ctx.lineTo(x, y)
                        }
                    }
                    ctx.stroke()
                    
                    // Draw P300 component highlight
                    if (experimentRunning) {
                        var p300Index = Math.floor(signalData.length * 0.3)
                        var p300X = (p300Index / (signalData.length - 1)) * width
                        var p300Y = centerY - signalData[p300Index] * height * 0.4
                        
                        ctx.fillStyle = "#7C4DFF"
                        ctx.beginPath()
                        ctx.arc(p300X, p300Y, 4, 0, Math.PI * 2)
                        ctx.fill()
                        
                        ctx.fillStyle = "#7C4DFF"
                        ctx.font = "10px Segoe UI"
                        ctx.fillText("P300", p300X + 8, p300Y - 8)
                    }
                }
                
                function drawP300Markers(ctx, width, height) {
                    if (!experimentRunning) return
                    
                    ctx.strokeStyle = "#7C4DFF"
                    ctx.lineWidth = 1
                    ctx.setLineDash([3, 3])
                    
                    // Stimulus markers
                    for (var i = 0; i < 3; i++) {
                        var x = width * (0.2 + i * 0.3)
                        ctx.beginPath()
                        ctx.moveTo(x, 0)
                        ctx.lineTo(x, height)
                        ctx.stroke()
                        
                        ctx.fillStyle = "#7C4DFF"
                        ctx.font = "9px Segoe UI"
                        ctx.fillText("Stimulus", x + 5, 15)
                    }
                    
                    ctx.setLineDash([])
                }
                
                function updateSignal() {
                    // Generate simulated EEG data
                    var newData = []
                    for (var i = 0; i < dataPoints; i++) {
                        var t = (i / dataPoints) * 2 * Math.PI
                        var signal = Math.sin(t * 8) * 0.3 + // Alpha
                                    Math.sin(t * 40) * 0.1 + // Gamma
                                    (Math.random() - 0.5) * 0.05 // Noise
                        
                        // Add P300 component when experiment is running
                        if (experimentRunning && i > dataPoints * 0.25 && i < dataPoints * 0.35) {
                            signal += Math.sin((i - dataPoints * 0.3) * 10) * 0.4
                        }
                        
                        newData.push(signal)
                    }
                    signalData = newData
                    requestPaint()
                }
            }
        }

        // Signal Info
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            SignalInfoItem {
                label: "AMPLITUDE"
                value: "42.3 µV"
                Layout.fillWidth: true
            }
            
            SignalInfoItem {
                label: "NOISE"
                value: "2.1 µV"
                Layout.fillWidth: true
            }
            
            SignalInfoItem {
                label: "SNR"
                value: "26.1 dB"
                Layout.fillWidth: true
            }
        }
    }

    Timer {
        interval: 50
        running: true
        repeat: true
        onTriggered: eegCanvas.updateSignal()
    }
}