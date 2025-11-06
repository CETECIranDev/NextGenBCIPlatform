import QtQuick

QtObject {
    id: experimentController
    
    property string currentState: "idle" // idle, running, paused, stopped
    property var currentExperiment: null
    property var experimentQueue: []
    
    signal experimentStateChanged(string state)
    signal experimentStarted(string paradigm)
    signal experimentCompleted(string paradigm, var results)
    signal experimentError(string paradigm, string error)
    
    function startExperiment(paradigm, config) {
        console.log("Starting experiment:", paradigm)
        currentState = "running"
        currentExperiment = {
            paradigm: paradigm,
            config: config,
            startTime: Date.now(),
            results: {}
        }
        experimentStateChanged("running")
        experimentStarted(paradigm)
    }
    
    function pauseExperiment() {
        if (currentState === "running") {
            currentState = "paused"
            experimentStateChanged("paused")
        }
    }
    
    function resumeExperiment() {
        if (currentState === "paused") {
            currentState = "running"
            experimentStateChanged("running")
        }
    }
    
    function stopExperiment() {
        if (currentState !== "idle") {
            var results = currentExperiment ? currentExperiment.results : {}
            var paradigm = currentExperiment ? currentExperiment.paradigm : ""
            
            currentState = "idle"
            currentExperiment = null
            experimentStateChanged("stopped")
            
            if (paradigm) {
                experimentCompleted(paradigm, results)
            }
        }
    }
    
    function queueExperiment(paradigm, config) {
        experimentQueue.push({
            paradigm: paradigm,
            config: config,
            queueTime: Date.now()
        })
        console.log("Experiment queued:", paradigm, "Queue length:", experimentQueue.length)
    }
    
    function getExperimentStatistics() {
        return {
            currentState: currentState,
            queueLength: experimentQueue.length,
            activeExperiment: currentExperiment ? currentExperiment.paradigm : "None",
            queue: experimentQueue.map(exp => exp.paradigm)
        }
    }
}