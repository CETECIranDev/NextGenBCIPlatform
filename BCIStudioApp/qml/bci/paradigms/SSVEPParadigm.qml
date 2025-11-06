import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root

    // =========================================================================
    // --- Signals for Connection Logic ---
    // =========================================================================
    signal connectionStarted(int portIndex)
    signal connectionDropped(int portIndex)

    // =========================================================================
    // --- Properties ---
    // =========================================================================
    property string nodeName: "Node"
    property color nodeColor: themeManager.secondary
    property string nodeIcon: ""
    property var inputs: [{"name": "In"}]
    property var outputs: [{"name": "Out"}]
    property bool isSelected: false

    // =========================================================================
    // --- Public Functions ---
    // =========================================================================
    function getInputPortPosition(index) {
        if (index < inputPorts.children.length) {
            const portHandle = inputPorts.children[index].children[0];
            return portHandle.mapToItem(root, portHandle.width / 2, portHandle.height / 2);
        }
        return Qt.point(0, 0);
    }

    function getOutputPortPosition(index) {
        if (index < outputPorts.children.length) {
            const portHandle = outputPorts.children[index].children[1];
            return portHandle.mapToItem(root, portHandle.width / 2, portHandle.height / 2);
        }
        return Qt.point(0, 0);
    }

    function portAt(localPoint) {
            // چک کردن پورت‌های ورودی
            for (var i = 0; i < inputPorts.children.length; i++) {
                let portRow = inputPorts.children[i];
                // موقعیت ردیف پورت نسبت به بدنه پورت‌ها (portsBody)
                let rowPos = Qt.point(portRow.x, portRow.y);
                // موقعیت ردیف پورت نسبت به کل نود (root)
                let rowGlobalPos = portsBody.mapToItem(root, rowPos.x, rowPos.y);

                // مرزهای پورت در مختصات محلی نود
                if (rowGlobalPos.x <= localPoint.x && localPoint.x <= rowGlobalPos.x + portRow.width &&
                    rowGlobalPos.y <= localPoint.y && localPoint.y <= rowGlobalPos.y + portRow.height) {
                    return { type: 'input', index: i };
                }
            }
            // چک کردن پورت‌های خروجی
            for (var i = 0; i < outputPorts.children.length; i++) {
                let portRow = outputPorts.children[i];
                let rowPos = Qt.point(portRow.x, portRow.y);
                let rowGlobalPos = portsBody.mapToItem(root, rowPos.x, rowPos.y);

                if (rowGlobalPos.x <= localPoint.x && localPoint.x <= rowGlobalPos.x + portRow.width &&
                    rowGlobalPos.y <= localPoint.y && localPoint.y <= rowGlobalPos.y + portRow.height) {
                    return { type: 'output', index: i };
                }
            }
            return null;
        }

    // =========================================================================
    // --- Visual Appearance ---
    // =========================================================================
    width: 200
    height: 120
    radius: 10
    color: themeManager.surfaceDark
    border.color: isSelected ? themeManager.primary : themeManager.secondary
    border.width: isSelected ? 2 : 1.5
    antialiasing: true

    Behavior on border.color { ColorAnimation { duration: 150 } }

    // --- هدر ---
    Rectangle {
        id: header
        width: parent.width
        height: 40
        color: root.nodeColor
        anchors.top: parent.top
        radius: root.radius
        antialiasing: true

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: parent.radius
            color: parent.color
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 12; anchors.rightMargin: 12

            Image {
                source: root.nodeIcon
                sourceSize.width: 18; sourceSize.height: 18
                antialiasing: true
                Layout.alignment: Qt.AlignVCenter
            }

            Label {
                text: root.nodeName
                color: themeManager.textOnPrimary
                font.bold: true
                elide: Text.ElideRight
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }

    // --- بدنه برای پورت‌ها ---
    RowLayout {
        id: portsBody
        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 12
        anchors.rightMargin: 12

        ColumnLayout {
            id: inputPorts
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            spacing: 12

            Repeater {
                model: root.inputs
                delegate: Row {
                    spacing: 8
                    Rectangle { id: handleOut; width: 12; height: 12; radius: 6; color: themeManager.secondary; border.color: Qt.darker(color, 1.5) }
                    Label { text: modelData.name; color: themeManager.textSecondary }
                }
            }
        }

        ColumnLayout {
            id: outputPorts
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            spacing: 12

            Repeater {
                model: root.outputs
                delegate: Row {
                    spacing: 8
                    Label { text: modelData.name; color: themeManager.textSecondary }
                    Rectangle { id: handleIn; width: 12; height: 12; radius: 6; color: themeManager.primary; border.color: Qt.darker(color, 1.5) }
                }
            }
        }
    }

    // =========================================================================
    // --- یک MouseArea واحد برای مدیریت تمام تعاملات نود ---
    // =========================================================================
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        property var portHit: null
        property bool dragStarted: false

        onPressed: (mouse) => {
            portHit = root.portAt(Qt.point(mouse.x, mouse.y));
            if (portHit && portHit.type === 'output') {
                // اگر روی پورت خروجی کلیک شد، اتصال را شروع کن
                root.connectionStarted(portHit.index);
                mouse.accepted = true; // این رویداد برای اتصال است
            } else {
                // در غیر این صورت، برای جابجایی آماده شو
                drag.target = root;
                mouse.accepted = false; // اجازه بده سیستم drag جابجایی را مدیریت کند
            }
            dragStarted = false;
        }

        onPositionChanged: (mouse) => {
            if (drag.active && !dragStarted) {
                // اولین حرکت ماوس بعد از کلیک، انتخاب را فعال می‌کند
                root.isSelected = true;
                dragStarted = true;
            }
        }

        onReleased: (mouse) => {
            portHit = root.portAt(Qt.point(mouse.x, mouse.y));
            if (canvasRoot.isConnecting && portHit && portHit.type === 'input') {
                // اگر در حال اتصال بودیم و روی پورت ورودی رها شد، اتصال را کامل کن
                root.connectionDropped(portHit.index);
                mouse.accepted = true;
            }
        }

        onClicked: {
            // اگر یک کلیک ساده بود (بدون جابجایی)، نود را انتخاب کن
            if (!drag.active) {
                root.isSelected = true;
            }
        }
    }
}
