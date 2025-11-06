import QtQuick

Item {
    id: flashController

    property int gridSize: 36
    property int stimulusDuration: 100
    property int isiDuration: 200
    property bool running: false
    property int sequenceLength: 10

    property var currentSequence: []
    property int currentStep: 0
    property var flashHistory: []

    signal flashSequence(var sequence)
    signal sequenceComplete()
    signal trialComplete()

    function start() {
        console.log("Starting P300 flash controller")
        currentStep = 0
        flashHistory = []
        generateNewSequence()
        sequenceTimer.start()
    }

    function stop() {
        console.log("Stopping P300 flash controller")
        sequenceTimer.stop()
        currentSequence = []
        currentStep = 0
    }

    function generateNewSequence() {
        currentSequence = []

        // Generate random flash sequence
        for (let i = 0; i < sequenceLength; i++) {
            // Random row or column flash
            var isRowFlash = Math.random() > 0.5
            var index = Math.floor(Math.random() * (isRowFlash ? 6 : 6))

            var flashIndices = []
            if (isRowFlash) {
                // Flash entire row
                for (let col = 0; col < 6; col++) {
                    flashIndices.push(index * 6 + col)
                }
            } else {
                // Flash entire column
                for (let row = 0; row < 6; row++) {
                    flashIndices.push(row * 6 + index)
                }
            }

            currentSequence.push({
                indices: flashIndices,
                type: isRowFlash ? "row" : "column",
                position: index,
                timestamp: Date.now()
            })
        }

        console.log("Generated new flash sequence:", currentSequence.length, "steps")
    }

    function executeNextFlash() {
        if (currentStep >= currentSequence.length) {
            sequenceComplete()
            generateNewSequence()
            currentStep = 0
        }

        var flashStep = currentSequence[currentStep]
        flashSequence(flashStep.indices)

        // Record flash for analysis
        flashHistory.push({
            step: currentStep,
            indices: flashStep.indices,
            type: flashStep.type,
            position: flashStep.position,
            timestamp: Date.now()
        })

        console.log("Flash step", currentStep + 1, ":", flashStep.type, flashStep.position)

        currentStep++

        if (currentStep >= currentSequence.length) {
            trialComplete()
        }
    }

    // Main sequence timer
    Timer {
        id: sequenceTimer
        interval: flashController.stimulusDuration + flashController.isiDuration
        running: false
        repeat: true
        onTriggered: flashController.executeNextFlash()
    }

    // Control running state
    onRunningChanged: {
        if (running) {
            sequenceTimer.start()
        } else {
            sequenceTimer.stop()
        }
    }

    // Analysis functions
    function getFlashStatistics() {
        var stats = {
            totalFlashes: flashHistory.length,
            rowFlashes: 0,
            columnFlashes: 0,
            averageInterval: 0,
            targetFlashRate: 0
        }

        if (flashHistory.length > 0) {
            flashHistory.forEach(function(flash) {
                if (flash.type === "row") stats.rowFlashes++
                else stats.columnFlashes++
            });

            if (flashHistory.length > 1) {
                var totalInterval = flashHistory[flashHistory.length - 1].timestamp - flashHistory[0].timestamp
                stats.averageInterval = totalInterval / (flashHistory.length - 1)
            }

            stats.targetFlashRate = 1000 / (stimulusDuration + isiDuration)
        }

        return stats
    }

    function getRecentFlashPattern() {
        if (flashHistory.length < 5) return []

        return flashHistory.slice(-5).map(function(flash) {
            return {
                type: flash.type,
                position: flash.position
            }
        })
    }

    // Configuration validation
    function validateConfiguration() {
        var issues = []

        if (stimulusDuration < 50) {
            issues.push("Stimulus duration too short (min 50ms)")
        }

        if (stimulusDuration > 500) {
            issues.push("Stimulus duration too long (max 500ms)")
        }

        if (isiDuration < 50) {
            issues.push("ISI duration too short (min 50ms)")
        }

        if (isiDuration > 1000) {
            issues.push("ISI duration too long (max 1000ms)")
        }

        if (sequenceLength < 5) {
            issues.push("Sequence length too short (min 5)")
        }

        if (sequenceLength > 20) {
            issues.push("Sequence length too long (max 20)")
        }

        return issues
    }
}
