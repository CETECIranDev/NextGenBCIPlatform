import QtQuick

Item {
    id: experimentController

    property bool running: false
    property int trialDuration: 4
    property int restDuration: 2
    property var classes: ["Left Hand", "Right Hand", "Both Hands", "Feet"]
    property int trialsPerClass: 10

    property int currentTrial: 0
    property int totalTrials: classes.length * trialsPerClass
    property string currentCue: "Rest"
    property int countdown: 0

    signal cueChanged(string cue)
    signal trialCompleted()
    signal classificationResult(string predictedClass, real confidence)
    signal experimentStarted()
    signal experimentStopped()

    // Timers
    Timer {
        id: countdownTimer
        interval: 1000
        repeat: true
        onTriggered: {
            countdown--
            if (countdown <= 0) {
                countdownTimer.stop()
                startTrial()
            }
        }
    }

    Timer {
        id: trialTimer
        interval: trialDuration * 1000
        onTriggered: completeTrial()
    }

    Timer {
        id: restTimer
        interval: restDuration * 1000
        onTriggered: prepareNextTrial()
    }

    // Control running state
    onRunningChanged: {
        if (running) {
            startExperiment()
        } else {
            stopExperiment()
        }
    }

    function startExperiment() {
        console.log("Starting Motor Imagery Experiment")
        currentTrial = 0
        currentCue = "Rest"
        cueChanged(currentCue)
        experimentStarted()
        prepareNextTrial()
    }

    function stopExperiment() {
        console.log("Stopping Motor Imagery Experiment")
        countdownTimer.stop()
        trialTimer.stop()
        restTimer.stop()
        currentCue = "Rest"
        cueChanged(currentCue)
        experimentStopped()
    }

    function pauseExperiment() {
        running = false
    }

    function prepareNextTrial() {
        if (currentTrial >= totalTrials) {
            stopExperiment()
            return
        }

        currentCue = "Get Ready"
        cueChanged(currentCue)
        countdown = 3
        countdownTimer.start()
    }

    function startTrial() {
        // Select random class for this trial
        var randomClass = classes[Math.floor(Math.random() * classes.length)]
        currentCue = randomClass
        cueChanged(currentCue)

        console.log("Trial", currentTrial + 1, "- Imagining:", currentCue)

        trialTimer.start()
    }

    function completeTrial() {
        // Simulate classification result
        var predictedClass = simulateClassification()
        var confidence = 0.7 + Math.random() * 0.25 // 70-95% confidence

        classificationResult(predictedClass, confidence)
        trialCompleted()

        currentTrial++
        currentCue = "Rest"
        cueChanged(currentCue)

        console.log("Trial", currentTrial, "completed - Predicted:", predictedClass, "Confidence:", confidence.toFixed(2))

        // Start rest period
        if (currentTrial < totalTrials) {
            restTimer.start()
        } else {
            console.log("Experiment completed!")
            stopExperiment()
        }
    }

    function simulateClassification() {
        // Simulate classification with some errors
        var correctClass = currentCue
        if (Math.random() < 0.85) { // 85% accuracy
            return correctClass
        } else {
            // Return random wrong class
            var wrongClasses = classes.filter(cls => cls !== correctClass)
            return wrongClasses[Math.floor(Math.random() * wrongClasses.length)]
        }
    }

    // Public API
    function start() {
        running = true
    }

    function stop() {
        running = false
    }

    function pause() {
        running = false
    }

    function getProgress() {
        return totalTrials > 0 ? currentTrial / totalTrials : 0
    }

    function getRemainingTrials() {
        return totalTrials - currentTrial
    }

    function updateConfig(newConfig) {
        if (newConfig.trialDuration) trialDuration = newConfig.trialDuration
        if (newConfig.restDuration) restDuration = newConfig.restDuration
        if (newConfig.classes) classes = newConfig.classes
        if (newConfig.trialsPerClass) trialsPerClass = newConfig.trialsPerClass

        totalTrials = classes.length * trialsPerClass
        console.log("Config updated. Total trials:", totalTrials)
    }
}
