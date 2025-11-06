import QtQuick

QtObject {
    function createConfig(paradigmType) {
        switch(paradigmType) {
            case "p300":
                return {
                    type: "p300",
                    rows: 6,
                    cols: 6,
                    stimulusDuration: 100,
                    isiDuration: 200,
                    trialsPerChar: 10,
                    flashMode: 0,
                    charSet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                }
            
            case "ssvep":
                return {
                    type: "ssvep",
                    numTargets: 4,
                    stimulationDuration: 5,
                    breakDuration: 3,
                    frequencies: [8, 10, 12, 14],
                    stimulusType: 0
                }
            
            case "motor_imagery":
                return {
                    type: "motor_imagery",
                    trialDuration: 4,
                    restDuration: 2,
                    numTrials: 40,
                    cueType: 0,
                    classes: ["Left Hand", "Right Hand"],
                    realtimeFeedback: false,
                    visualFeedback: true,
                    auditoryFeedback: false
                }
            
            default:
                return {
                    type: "custom",
                    name: "Custom Paradigm",
                    parameters: {}
                }
        }
    }
}