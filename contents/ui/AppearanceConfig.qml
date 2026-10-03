import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Kirigami.ScrollablePage {
    id: configRoot

    title: i18n("Appearance")
    property int cfg_temperatureUnit: 0
    property int cfg_temperatureUnitDefault: 0
    property int cfg_sizeFontConfig: 11
    property int cfg_sizeFontConfigDefault: 11
    property string cfg_latitudeC: "0"
    property string cfg_latitudeCDefault: "0"
    property string cfg_longitudeC: "0"
    property string cfg_longitudeCDefault: "0"
    property bool cfg_useCoordinatesIp: true
    property bool cfg_useCoordinatesIpDefault: true
    property bool cfg_boldfonts: false
    property bool cfg_boldfontsDefault: false
    property bool cfg_textweather: true
    property bool cfg_textweatherDefault: true
    property string cfg_weatherLanguage: "system"
    property string cfg_weatherLanguageDefault: "system"

    QtObject {
        id: textColorValue
        property string value: ""
    }

    QtObject {
        id: temperatureColorValue
        property string value: ""
    }

    property alias cfg_textColor: textColorValue.value
    property string cfg_textColorDefault: ""
    property alias cfg_temperatureColor: temperatureColorValue.value
    property string cfg_temperatureColorDefault: ""
    readonly property color effectiveTextColor: textColorValue.value === "" ? Kirigami.Theme.textColor : textColorValue.value
    readonly property color effectiveTemperatureColor: temperatureColorValue.value === "" ? Kirigami.Theme.textColor : temperatureColorValue.value

    Kirigami.FormLayout {
        width: parent.width

        RowLayout {
            Kirigami.FormData.label: i18n("Text color:")

            Rectangle {
                Layout.alignment: Qt.AlignVCenter
                width: 16
                height: 16
                radius: 2
                color: configRoot.effectiveTextColor
                border.color: Kirigami.Theme.disabledTextColor
            }

            Button {
                text: textColorValue.value === "" ? i18n("Theme default") : textColorValue.value
                onClicked: textColorDialog.open()
            }

            Button {
                text: i18n("Use theme color")
                enabled: textColorValue.value !== ""
                onClicked: textColorValue.value = ""
            }
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Temperature color:")

            Rectangle {
                Layout.alignment: Qt.AlignVCenter
                width: 16
                height: 16
                radius: 2
                color: configRoot.effectiveTemperatureColor
                border.color: Kirigami.Theme.disabledTextColor
            }

            Button {
                text: temperatureColorValue.value === "" ? i18n("Theme default") : temperatureColorValue.value
                onClicked: temperatureColorDialog.open()
            }

            Button {
                text: i18n("Use theme color")
                enabled: temperatureColorValue.value !== ""
                onClicked: temperatureColorValue.value = ""
            }
        }
    }

    ColorDialog {
        id: textColorDialog
        title: i18n("Choose text color")
        selectedColor: configRoot.effectiveTextColor
        onAccepted: textColorValue.value = selectedColor.toString()
    }

    ColorDialog {
        id: temperatureColorDialog
        title: i18n("Choose temperature color")
        selectedColor: configRoot.effectiveTemperatureColor
        onAccepted: temperatureColorValue.value = selectedColor.toString()
    }
}