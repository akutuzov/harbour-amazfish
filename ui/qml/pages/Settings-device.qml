import QtQuick 2.0
import uk.co.piggz.amazfish 1.0
import "../components"
import "../components/platform"

PagePL {
    id: page
    title: qsTr("Device Settings")

    Column {
        id: column
        width: parent.width
        anchors.top: parent.top
        anchors.margins: styler.themePaddingMedium
        spacing: styler.themePaddingLarge

        FormLayoutPL {
            ComboBoxPL {
                id: cboLanguage
                label: qsTr("Language")

                //"zh_CN", "zh_TW", "en_US", "es_ES", "ru_RU", "de_DE", "it_IT", "fr_FR", "tr_TR"
                model: ListModel {
                    ListElement { itemText: qsTr("en_US") }
                    ListElement { itemText: qsTr("es_ES") }
                    ListElement { itemText: qsTr("zh_CN") }
                    ListElement { itemText: qsTr("zh_TW") }
                    ListElement { itemText: qsTr("ru_RU") }
                    ListElement { itemText: qsTr("de_DE") }
                    ListElement { itemText: qsTr("it_IT") }
                    ListElement { itemText: qsTr("fr_FR") }
                    ListElement { itemText: qsTr("tr_TR") }
                }

                Component.onCompleted: {
                    cboLanguage.currentIndex = AmazfishConfig.deviceLanguage;
                }
            }

            ComboBoxPL {
                id: cboDateDisplay
                label: qsTr("Date Display")

                model: ListModel {
                    ListElement { itemText: qsTr("Time") }
                    ListElement { itemText: qsTr("Date/Time") }
                }

                Component.onCompleted: {
                    cboDateDisplay.currentIndex = AmazfishConfig.deviceDateFormat;
                }
            }

            ComboBoxPL {
                id: cboTimeFormat
                label: qsTr("Time Format")

                model: ListModel {
                    ListElement { itemText: qsTr("24hr") }
                    ListElement { itemText: qsTr("12hr") }
                }

                Component.onCompleted: {
                    cboTimeFormat.currentIndex = AmazfishConfig.deviceTimeFormat;
                }
            }

            ComboBoxPL {
                id: cboDistanceUnit
                label: qsTr("Distance Unit")

                model: ListModel {
                    ListElement { itemText: qsTr("Metric") }
                    ListElement { itemText: qsTr("Imperial") }
                }

                Component.onCompleted: {
                    cboDistanceUnit.currentIndex = AmazfishConfig.deviceDistanceUnit;
                }
            }

            TextSwitchPL {
                id: chkDisconnectNotification
                width: parent.width
                text: qsTr("Disconnect Notification")

                Component.onCompleted: {
                    chkDisconnectNotification.checked = AmazfishConfig.deviceDisconnectNotification;
                }
            }

            ButtonPL {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Huami Display Items")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Settings-huami-shortcuts.qml"))
                }
            }

            SectionHeaderPL {
            }

            ButtonPL {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Save Settings")
                onClicked: {
                    saveSettings();
                }
            }
        }
        Timer {
            //Allow data to sync
            id: tmrSetDelay
            repeat: false
            interval: 500
            running: false
            onTriggered: {
                DaemonInterfaceInstance.applyDeviceSetting(Amazfish.SETTING_DEVICE_LANGUAGE);
                DaemonInterfaceInstance.applyDeviceSetting(Amazfish.SETTING_DEVICE_DATE);
                DaemonInterfaceInstance.applyDeviceSetting(Amazfish.SETTING_DEVICE_TIME);
                DaemonInterfaceInstance.applyDeviceSetting(Amazfish.SETTING_DEVICE_UNIT);
                DaemonInterfaceInstance.applyDeviceSetting(Amazfish.SETTING_DISCONNECT_NOTIFICATION);
            }
        }
    }

    function saveSettings() {
        AmazfishConfig.deviceLanguage = cboLanguage.currentIndex;
        AmazfishConfig.deviceDateFormat = cboDateDisplay.currentIndex;
        AmazfishConfig.deviceTimeFormat = cboTimeFormat.currentIndex;
        AmazfishConfig.deviceDistanceUnit = cboDistanceUnit.currentIndex;
        AmazfishConfig.deviceDisconnectNotification = chkDisconnectNotification.checked;
        tmrSetDelay.start();
    }
}
