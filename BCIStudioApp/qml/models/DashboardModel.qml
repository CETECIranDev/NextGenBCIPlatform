// models/DashboardModel.qml
import QtQuick

QtObject {
    id: dashboardModel

    // وضعیت اتصال
    property bool isConnected: false
    property string connectedDeviceName: "OpenBCI Cyton"
    property real batteryLevel: 85
    property string sessionTime: "00:15:30"
    property bool isStreaming: false
    property bool isPredicting: false

    // کیفیت سیگنال
    property real overallSignalQuality: 78.5
    property var signalQuality: [
        {"channel": "Fp1", "quality": 85, "impedance": 12.3},
        {"channel": "Fp2", "quality": 78, "impedance": 15.7},
        {"channel": "C3", "quality": 92, "impedance": 8.4},
        {"channel": "C4", "quality": 88, "impedance": 9.1},
        {"channel": "O1", "quality": 76, "impedance": 16.2},
        {"channel": "O2", "quality": 81, "impedance": 14.8}
    ]

    // داده‌های شناختی
    property real attentionLevel: 65
    property real meditationLevel: 42
    property real fatigueLevel: 28
    property real engagementLevel: 71

    // خروجی BCI
    property string lastCommand: "LEFT"
    property real commandConfidence: 0.87
    property int predictionLatency: 145

    // داده‌های فرکانسی
    property var frequencyBands: ({
        "delta": { "power": 15.2, "range": [0.5, 4] },
        "theta": { "power": 22.8, "range": [4, 8] },
        "alpha": { "power": 18.3, "range": [8, 13] },
        "beta": { "power": 12.7, "range": [13, 30] },
        "gamma": { "power": 8.1, "range": [30, 45] }
    })

    // لاگ رویدادها
    property ListModel eventLog: ListModel {
        Component.onCompleted: {
            // مقداردهی اولیه لاگ
            append({ timestamp: "14:30:25", message: "System initialized", type: "info" })
            append({ timestamp: "14:30:30", message: "Device connected: OpenBCI Cyton", type: "success" })
            append({ timestamp: "14:31:15", message: "Signal quality stabilized", type: "info" })
            append({ timestamp: "14:32:45", message: "Command detected: LEFT (87% confidence)", type: "command" })
            append({ timestamp: "14:33:20", message: "Attention level increased to 65%", type: "metric" })
        }
    }

    // داده‌های سیگنال زنده
    property var channelSignals: [
        {"name": "Fp1", "data": generateSignalData()},
        {"name": "Fp2", "data": generateSignalData()},
        {"name": "C3", "data": generateSignalData()},
        {"name": "C4", "data": generateSignalData()}
    ]

    property int samplingRate: 250
    property int frameRate: 60

    // موقعیت الکترودها برای نقشه توپوگرافی
    property var electrodePositions: [
        {"label": "Fp1", "x": 0.3, "y": 0.1},
        {"label": "Fp2", "x": 0.7, "y": 0.1},
        {"label": "C3", "x": 0.2, "y": 0.5},
        {"label": "C4", "x": 0.8, "y": 0.5},
        {"label": "O1", "x": 0.4, "y": 0.9},
        {"label": "O2", "x": 0.6, "y": 0.9}
    ]

    // سیگنال‌ها
    signal dataUpdated()
    signal connectionStatusChanged(bool connected)
    signal newCommandReceived(string command, real confidence)

    // توابع
    function toggleStreaming() {
        isStreaming = !isStreaming
        console.log("Streaming:", isStreaming ? "STARTED" : "STOPPED")

        if (isStreaming) {
            addLogEntry(getCurrentTime(), "Data streaming started", "info")
        } else {
            addLogEntry(getCurrentTime(), "Data streaming stopped", "info")
        }

        dataUpdated()
    }

    function startCalibration() {
        console.log("Starting calibration...")
        addLogEntry(getCurrentTime(), "Calibration started", "info")
        // شبیه‌سازی کالیبراسیون
    }

    function exportData() {
        console.log("Exporting dashboard data...")
        addLogEntry(getCurrentTime(), "Data export requested", "info")
    }

    function generateSignalData() {
        var data = []
        for (var i = 0; i < 100; i++) {
            data.push(Math.sin(i * 0.1) * 50 + Math.random() * 20 - 10)
        }
        return data
    }

    function addLogEntry(timestamp, message, type) {
        if (eventLog.count >= 50) {
            eventLog.remove(0) // حذف قدیمی‌ترین entry
        }

        eventLog.append({
            timestamp: timestamp,
            message: message,
            type: type || "info"
        })

        dataUpdated()
    }

    function getCurrentTime() {
        var now = new Date()
        return now.toTimeString().split(' ')[0] // بازگرداندن زمان به فرمت HH:MM:SS
    }

    function connectDevice() {
        if (!isConnected) {
            isConnected = true
            addLogEntry(getCurrentTime(), "Device connected: " + connectedDeviceName, "success")
            connectionStatusChanged(true)
        }
    }

    function disconnectDevice() {
        if (isConnected) {
            isConnected = false
            isStreaming = false
            addLogEntry(getCurrentTime(), "Device disconnected", "info")
            connectionStatusChanged(false)
        }
    }

    function simulateNewCommand(command, confidence) {
        lastCommand = command
        commandConfidence = confidence
        addLogEntry(getCurrentTime(),
                   "Command detected: " + command + " (" + Math.round(confidence * 100) + "% confidence)",
                   "command")
        newCommandReceived(command, confidence)
        dataUpdated()
    }

    // // تایمر برای شبیه‌سازی داده‌های real-time
    // Timer {
    //     interval: 100
    //     running: dashboardModel.isStreaming
    //     repeat: true
    //     onTriggered: {
    //         if (dashboardModel.isStreaming) {
    //             // به‌روزرسانی داده‌ها برای شبیه‌سازی
    //             dashboardModel.attentionLevel = Math.max(0, Math.min(100,
    //                 dashboardModel.attentionLevel + (Math.random() * 4 - 2)))
    //             dashboardModel.meditationLevel = Math.max(0, Math.min(100,
    //                 dashboardModel.meditationLevel + (Math.random() * 3 - 1.5)))
    //             dashboardModel.engagementLevel = Math.max(0, Math.min(100,
    //                 dashboardModel.engagementLevel + (Math.random() * 5 - 2.5)))
    //             dashboardModel.fatigueLevel = Math.max(0, Math.min(100,
    //                 dashboardModel.fatigueLevel + (Math.random() * 2 - 1)))

    //             // شبیه‌سازی تغییرات سیگنال
    //             dashboardModel.overallSignalQuality = Math.max(0, Math.min(100,
    //                 dashboardModel.overallSignalQuality + (Math.random() * 6 - 3)))

    //             dashboardModel.dataUpdated()
    //         }
    //     }
    // }

    // // تایمر برای شبیه‌سازی دستورات تصادفی
    // Timer {
    //     interval: 8000
    //     running: dashboardModel.isStreaming
    //     repeat: true
    //     onTriggered: {
    //         if (dashboardModel.isStreaming && Math.random() > 0.7) {
    //             var commands = ["LEFT", "RIGHT", "UP", "DOWN", "SELECT"]
    //             var randomCommand = commands[Math.floor(Math.random() * commands.length)]
    //             var randomConfidence = 0.7 + Math.random() * 0.25
    //             dashboardModel.simulateNewCommand(randomCommand, randomConfidence)
    //         }
    //     }
    // }

    Component.onCompleted: {
        console.log("DashboardModel initialized")
        // مقداردهی اولیه
        connectDevice()
    }
}
