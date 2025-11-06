import QtQuick
import QtQuick.Layouts

Rectangle {
    id: brainMap
    
    property string predictedClass: "Left Hand"
    property real activationLevel: 0.75
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
            text: "MOTOR CORTEX ACTIVATION MAP"
            color: "white"
            font.bold: true
            font.pixelSize: 12
            font.family: "Segoe UI"
        }
        
        // Brain Visualization
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "#0F0F1A"
            radius: 6
            border.color: "#252540"
            border.width: 1
            
            Canvas {
                id: brainCanvas
                anchors.fill: parent
                anchors.margins: 10
                
                onPaint: {
                    var ctx = getContext("2d")
                    ctx.reset()
                    
                    var width = brainCanvas.width
                    var height = brainCanvas.height
                    var centerX = width / 2
                    var centerY = height / 2
                    
                    // Draw brain outline
                    drawBrainOutline(ctx, width, height, centerX, centerY)
                    
                    // Draw activation areas based on predicted class
                    drawActivationAreas(ctx, width, height, centerX, centerY)
                    
                    // Draw labels
                    drawLabels(ctx, width, height)
                }
                
                function drawBrainOutline(ctx, width, height, centerX, centerY) {
                    ctx.strokeStyle = "#666677"
                    ctx.lineWidth = 2
                    ctx.beginPath()
                    
                    // Simplified brain outline
                    ctx.ellipse(centerX - 80, centerY - 60, 160, 120)
                    ctx.stroke()
                    
                    // Central sulcus
                    ctx.strokeStyle = "#444455"
                    ctx.lineWidth = 1
                    ctx.beginPath()
                    ctx.moveTo(centerX, centerY - 60)
                    ctx.lineTo(centerX, centerY + 60)
                    ctx.stroke()
                }
                
                function drawActivationAreas(ctx, width, height, centerX, centerY) {
                    var activationColor = getActivationColor(brainMap.predictedClass)
                    var alpha = brainMap.activationLevel
                    
                    ctx.fillStyle = Qt.rgba(
                        parseInt(activationColor.substring(1, 3), 16) / 255,
                        parseInt(activationColor.substring(3, 5), 16) / 255,
                        parseInt(activationColor.substring(5, 7), 16) / 255,
                        alpha
                    )
                    
                    // Draw activation based on predicted class
                    switch(brainMap.predictedClass) {
                        case "Left Hand":
                            ctx.beginPath()
                            ctx.ellipse(centerX - 50, centerY - 20, 40, 30)
                            ctx.fill()
                            break
                            
                        case "Right Hand":
                            ctx.beginPath()
                            ctx.ellipse(centerX + 10, centerY - 20, 40, 30)
                            ctx.fill()
                            break
                            
                        case "Both Hands":
                            ctx.beginPath()
                            ctx.ellipse(centerX - 50, centerY - 20, 40, 30)
                            ctx.ellipse(centerX + 10, centerY - 20, 40, 30)
                            ctx.fill()
                            break
                            
                        case "Feet":
                            ctx.beginPath()
                            ctx.ellipse(centerX - 20, centerY + 20, 60, 25)
                            ctx.fill()
                            break
                            
                        case "Tongue":
                            ctx.beginPath()
                            ctx.ellipse(centerX - 15, centerY - 40, 30, 20)
                            ctx.fill()
                            break
                    }
                    
                    // Pulsing effect for active areas
                    if (brainMap.experimentRunning) {
                        ctx.strokeStyle = activationColor
                        ctx.lineWidth = 2
                        ctx.setLineDash([5, 5])
                        ctx.beginPath()
                        
                        switch(brainMap.predictedClass) {
                            case "Left Hand":
                                ctx.ellipse(centerX - 50, centerY - 20, 40 + 5 * Math.sin(Date.now() / 200), 30 + 3 * Math.sin(Date.now() / 200))
                                break
                            case "Right Hand":
                                ctx.ellipse(centerX + 10, centerY - 20, 40 + 5 * Math.sin(Date.now() / 200), 30 + 3 * Math.sin(Date.now() / 200))
                                break
                            case "Both Hands":
                                ctx.ellipse(centerX - 50, centerY - 20, 40 + 5 * Math.sin(Date.now() / 200), 30 + 3 * Math.sin(Date.now() / 200))
                                ctx.ellipse(centerX + 10, centerY - 20, 40 + 5 * Math.sin(Date.now() / 200), 30 + 3 * Math.sin(Date.now() / 200))
                                break
                            case "Feet":
                                ctx.ellipse(centerX - 20, centerY + 20, 60 + 5 * Math.sin(Date.now() / 200), 25 + 3 * Math.sin(Date.now() / 200))
                                break
                            case "Tongue":
                                ctx.ellipse(centerX - 15, centerY - 40, 30 + 5 * Math.sin(Date.now() / 200), 20 + 3 * Math.sin(Date.now() / 200))
                                break
                        }
                        ctx.stroke()
                        ctx.setLineDash([])
                    }
                }
                
                function drawLabels(ctx, width, height) {
                    ctx.fillStyle = "#AAAAAA"
                    ctx.font = "bold 10px Segoe UI"
                    ctx.textAlign = "center"
                    
                    ctx.fillText("Left Motor Cortex", width * 0.25, height - 10)
                    ctx.fillText("Right Motor Cortex", width * 0.75, height - 10)
                    ctx.fillText("Primary Motor Cortex", width * 0.5, 15)
                }
                
                function getActivationColor(className) {
                    switch(className) {
                        case "Left Hand": return "#2196F3"
                        case "Right Hand": return "#4CAF50"
                        case "Both Hands": return "#FF9800"
                        case "Feet": return "#9C27B0"
                        case "Tongue": return "#E91E63"
                        default: return "#666677"
                    }
                }
            }
        }
        
        // Activation Level Indicator
        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            
            Text {
                text: "ACTIVATION LEVEL"
                color: "#AAAAAA"
                font.pixelSize: 10
                font.family: "Segoe UI"
            }
            
            Rectangle {
                Layout.fillWidth: true
                height: 8
                radius: 4
                color: "#333344"
                
                Rectangle {
                    width: parent.width * brainMap.activationLevel
                    height: parent.height
                    radius: 4
                    color: getActivationColor(brainMap.predictedClass)
                    
                    Behavior on width {
                        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
                    }
                }
            }
            
            Text {
                text: Math.floor(brainMap.activationLevel * 100) + "%"
                color: getActivationColor(brainMap.predictedClass)
                font.bold: true
                font.pixelSize: 10
                font.family: "Segoe UI"
            }
        }
    }
    
    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: brainCanvas.requestPaint()
    }
    
    function getActivationColor(className) {
        switch(className) {
            case "Left Hand": return "#2196F3"
            case "Right Hand": return "#4CAF50"
            case "Both Hands": return "#FF9800"
            case "Feet": return "#9C27B0"
            case "Tongue": return "#E91E63"
            default: return "#666677"
        }
    }
}