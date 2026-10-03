import QtQuick
import QtQuick.Controls
import org.kde.kirigami as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

Kirigami.ScrollablePage {
    id: configRoot
    title: i18n("General")

    QtObject {
        id: unidWeatherValue
        property var value
    }

    QtObject {
        id: fontsizeValue
        property var value
    }

    QtObject {
        id: textColors
        property string textColor: ""
        property string temperatureColor: ""
    }

    QtObject {
        id: weatherLanguageValue
        property string value: "system"
    }

    signal configurationChanged

    property int cfg_temperatureUnitDefault: 0
    property int cfg_sizeFontConfigDefault: 11
    property string cfg_latitudeCDefault: "0"
    property string cfg_longitudeCDefault: "0"
    property bool cfg_useCoordinatesIpDefault: true
    property bool cfg_boldfontsDefault: false
    property bool cfg_textweatherDefault: true
    property alias cfg_textColor: textColors.textColor
    property string cfg_textColorDefault: ""
    property alias cfg_temperatureColor: textColors.temperatureColor
    property string cfg_temperatureColorDefault: ""
    property alias cfg_weatherLanguage: weatherLanguageValue.value
    property string cfg_weatherLanguageDefault: "system"

    property alias cfg_temperatureUnit: unidWeatherValue.value
    property alias cfg_sizeFontConfig: fontsizeValue.value
    property alias cfg_latitudeC: latitude.text
    property alias cfg_longitudeC: longitude.text
    property alias cfg_useCoordinatesIp: autamateCoorde.checked
    property alias cfg_boldfonts: boldfont.checked
    property alias cfg_textweather: textweather.checked

    Kirigami.FormLayout {
        width: parent.width

        ComboBox {
            id: weatherLanguageBox
            textRole: "text"
            valueRole: "value"
            Kirigami.FormData.label: i18n("Widget language:")
            model: [
                {text: i18n("System language"), value: "system"},
                {text: "English", value: "en"},
                {text: "Português", value: "pt"},
                {text: "Español", value: "es"},
                {text: "Français", value: "fr"},
                {text: "Deutsch", value: "de"},
                {text: "Italiano", value: "it"},
                {text: "日本語", value: "ja"},
                {text: "한국어", value: "ko"},
                {text: "Русский", value: "ru"},
                {text: "中文", value: "zh"},
            ]
            onActivated: weatherLanguageValue.value = currentValue
            Component.onCompleted: currentIndex = indexOfValue(weatherLanguageValue.value)
        }

        ComboBox {
            textRole: "text"
            valueRole: "value"
            id: positionComboBox
            Kirigami.FormData.label: i18n("Temperature Unit:")
            model: [
                {text: i18n("Celsius (°C)"), value: 0},
                {text: i18n("Fahrenheit (°F)"), value: 1},
            ]
            onActivated: unidWeatherValue.value = currentValue
            Component.onCompleted: currentIndex = indexOfValue(unidWeatherValue.value)
        }
        CheckBox {
            id: textweather
            Kirigami.FormData.label: i18n('weather conditions text on panel:')
        }

        CheckBox {
            id: autamateCoorde
            Kirigami.FormData.label: i18n('Use IP location')
        }
        TextField {
            id: latitude
            visible: !autamateCoorde.checked
            Kirigami.FormData.label: i18n("Latitude:")
            width: 200
        }
        TextField {
            id: longitude
            visible: !autamateCoorde.checked
            Kirigami.FormData.label: i18n("Longitude:")
            width: 200
        }
        CheckBox {
            id: boldfont
            Kirigami.FormData.label: i18n('Bold font:')
        }
        ComboBox {
            textRole: "text"
            valueRole: "value"
            Kirigami.FormData.label: i18n('Font Size:')
            id: valueForSizeFont
            model: [
                {text: i18n("8"), value: 8},
                {text: i18n("9"), value: 9},
                {text: i18n("10"), value: 10},
                {text: i18n("11"), value: 11},
                {text: i18n("12"), value: 12},
                {text: i18n("13"), value: 13},
                {text: i18n("14"), value: 14},
                {text: i18n("15"), value: 15},
                {text: i18n("16"), value: 16},
                {text: i18n("17"), value: 17},
                {text: i18n("18"), value: 18},

            ]
            onActivated: fontsizeValue.value = currentValue
            Component.onCompleted: currentIndex = indexOfValue(fontsizeValue.value)
        }
    }

}
