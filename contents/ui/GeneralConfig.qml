import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
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
        id: boldFontValue
        property var value: false
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

    QtObject {
        id: locationNameValue
        property string value: ""
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
    property alias cfg_locationName: locationNameValue.value
    property string cfg_locationNameDefault: ""
    property var locationResults: []
    property var locationSearchRequest: null
    property int locationSearchGeneration: 0

    property alias cfg_temperatureUnit: unidWeatherValue.value
    property alias cfg_sizeFontConfig: fontsizeValue.value
    property alias cfg_latitudeC: latitude.text
    property alias cfg_longitudeC: longitude.text
    property alias cfg_useCoordinatesIp: autamateCoorde.checked
    property alias cfg_boldfonts: boldFontValue.value
    property alias cfg_textweather: textweather.checked

    function searchLocations() {
        var query = locationSearch.text.trim()
        if (query.length < 3) {
            locationResults = []
            locationSearchStatus.text = query.length === 0 ? "" : i18n("Enter at least 3 characters")
            return
        }

        locationSearchGeneration += 1
        var generation = locationSearchGeneration
        if (locationSearchRequest) {
            locationSearchRequest.abort()
        }

        var language = Qt.uiLanguage || Qt.locale().name
        var url = "https://nominatim.openstreetmap.org/search?format=jsonv2&addressdetails=1&limit=5&accept-language="
                + encodeURIComponent(language) + "&q=" + encodeURIComponent(query)
        var request = new XMLHttpRequest()
        locationSearchRequest = request
        console.log("Location search started")
        locationSearchStatus.text = i18n("Searching...")
        request.open("GET", url, true)
        request.timeout = 10000
        request.setRequestHeader("User-Agent", "Weatherline/1.0 (https://github.com/pdrso01/weatherline-plasmoid)")
        request.onreadystatechange = function() {
            if (request.readyState !== XMLHttpRequest.DONE || generation !== locationSearchGeneration) {
                return
            }

            locationSearchRequest = null
            if (request.status === 200) {
                try {
                    locationResults = JSON.parse(request.responseText)
                    console.log("Location search returned", locationResults.length, "results")
                    locationSearchStatus.text = locationResults.length === 0 ? i18n("No locations found") : ""
                } catch (error) {
                    locationResults = []
                    locationSearchStatus.text = i18n("Could not read search results")
                }
            } else {
                locationResults = []
                console.error("Location search failed with status", request.status, request.responseText)
                locationSearchStatus.text = i18n("Location search failed (HTTP %1)").arg(request.status)
            }
        }
        request.onerror = function() {
            if (generation === locationSearchGeneration) {
                locationSearchRequest = null
                locationResults = []
                console.error("Location search network error")
                locationSearchStatus.text = i18n("Location search failed")
            }
        }
        request.ontimeout = function() {
            if (generation === locationSearchGeneration) {
                locationSearchRequest = null
                locationResults = []
                console.error("Location search timed out")
                locationSearchStatus.text = i18n("Location search timed out")
            }
        }
        request.send()
    }

    function selectLocation(location) {
        locationSearchGeneration += 1
        if (locationSearchRequest) {
            locationSearchRequest.abort()
            locationSearchRequest = null
        }
        var address = location.address || {}
        locationNameValue.value = address.city || address.town || address.village || address.municipality || address.suburb || location.name || location.display_name.split(",")[0]
        latitude.text = location.lat
        longitude.text = location.lon
        autamateCoorde.checked = false
        locationSearch.text = location.display_name
        locationResults = []
        locationSearchStatus.text = i18n("Selected location")
    }

    Timer {
        id: locationSearchTimer
        interval: 1000
        repeat: false
        onTriggered: configRoot.searchLocations()
    }

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
            id: locationSearch
            Kirigami.FormData.label: i18n("Find a city or place:")
            placeholderText: i18n("Type at least 3 characters")
            Layout.fillWidth: true
            onTextEdited: {
                locationResults = []
                locationSearchStatus.text = ""
                locationSearchTimer.restart()
            }
        }
        ListView {
            id: locationResultsView
            visible: locationResults.length > 0
            model: locationResults
            implicitHeight: Math.min(contentHeight, 240)
            Layout.fillWidth: true
            clip: true

            delegate: ItemDelegate {
                width: locationResultsView.width
                text: modelData.display_name
                onClicked: configRoot.selectLocation(modelData)
            }
        }
        Label {
            id: locationSearchStatus
            visible: text.length > 0
            color: text.startsWith(i18n("Location search failed")) ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.textColor
            Layout.fillWidth: true
        }
        TextField {
            id: latitude
            visible: !autamateCoorde.checked
            Kirigami.FormData.label: i18n("Latitude:")
            width: 200
            onTextEdited: locationNameValue.value = ""
        }
        TextField {
            id: longitude
            visible: !autamateCoorde.checked
            Kirigami.FormData.label: i18n("Longitude:")
            width: 200
            onTextEdited: locationNameValue.value = ""
        }
    }

}
