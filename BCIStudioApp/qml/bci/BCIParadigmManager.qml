import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "./paradigms"
import "./paradigms/components"

Rectangle {
    id: paradigmManager

    property var theme
    property var appController
    property string activeParadigm: ""
    property var paradigmConfig: ({})
    property bool isExperimentRunning: false

    color: "#0F0F1A"

    // Background Pattern
    Canvas {
        anchors.fill: parent
        opacity: 0.03

        onPaint: {
            var ctx = getContext("2d")
            ctx.strokeStyle = "#7C4DFF"
            ctx.lineWidth = 0.5

            // Draw subtle grid pattern
            for (var x = 0; x < width; x += 40) {
                ctx.beginPath()
                ctx.moveTo(x, 0)
                ctx.lineTo(x, height)
                ctx.stroke()
            }

            for (var y = 0; y < height; y += 40) {
                ctx.beginPath()
                ctx.moveTo(0, y)
                ctx.lineTo(width, y)
                ctx.stroke()
            }
        }
    }

    StackLayout {
        id: mainStack
        anchors.fill: parent
        currentIndex: activeParadigm === "" ? 0 : 1

        // Paradigm Selection View
        ParadigmSelectionView {
            theme: paradigmManager.theme
            onParadigmSelected: (paradigmType) => {
                paradigmManager.activeParadigm = paradigmType
                paradigmManager.paradigmConfig = paradigmFactory.createConfig(paradigmType)
                console.log("Selected paradigm:", paradigmType)
            }
        }

        // Paradigm Execution View
        Loader {
            id: paradigmLoader
            active: activeParadigm !== ""
            sourceComponent: getParadigmComponent(activeParadigm)

            onLoaded: {
                item.theme = paradigmManager.theme
                item.config = paradigmManager.paradigmConfig
                item.appController = paradigmManager.appController
            }
        }
    }

    // Paradigm Factory
    ParadigmConfigFactory {
        id: paradigmFactory
    }

    function getParadigmComponent(paradigmType) {
        switch(paradigmType) {
            case "p300":
                return enterpriseP300Component
            case "ssvep":
                return enterpriseSSVEPComponent
            case "motor_imagery":
                return enterpriseMotorImageryComponent
            default:
                return enterpriseCustomComponent
        }
    }

    // Component Definitions
    Component {
        id: enterpriseP300Component
        EnterpriseP300View {
            onBackRequested: {
                paradigmManager.activeParadigm = ""
                paradigmManager.paradigmConfig = {}
            }
        }
    }

    Component {
        id: enterpriseSSVEPComponent
        EnterpriseSSVEPView {
            onBackRequested: {
                paradigmManager.activeParadigm = ""
                paradigmManager.paradigmConfig = {}
            }
        }
    }

    Component {
        id: enterpriseMotorImageryComponent
        EnterpriseMotorImageryView {
            onBackRequested: {
                paradigmManager.activeParadigm = ""
                paradigmManager.paradigmConfig = {}
            }
        }
    }

    // Component {
    //     id: enterpriseCustomComponent
    //     EnterpriseCustomParadigmView {
    //         onBackRequested: {
    //             paradigmManager.activeParadigm = ""
    //             paradigmManager.paradigmConfig = {}
    //         }
    //     }
    // }

    // Global Experiment Controller
    BCIExperimentController {
        id: experimentController
        onExperimentStateChanged: (state) => {
            paradigmManager.isExperimentRunning = state === "running"
        }
    }
}
