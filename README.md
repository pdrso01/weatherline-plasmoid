# Weatherline

Weatherline is a compact weather widget for KDE Plasma 6, based on **Minimal Chaac Weather**, originally created by [zayronxio](https://github.com/zayronxio).

It shows the current temperature and conditions in your panel, and opens a forecast with your city, the next three days and the chance of rain. You can search for any place or use IP-based location, choose Celsius or Fahrenheit, and customize colors and fonts.

This repository is an independent continuation of the original project. The user-facing name has been simplified to Weatherline. The package ID was changed from the original `Minimal.chaac.weather` to `com.github.pdrso01.weatherline` so Plasma can identify and load this version correctly.

## Requirements

- KDE Plasma 6.
- Internet access for IP geolocation, city lookup, and weather data (ip-api.com, OpenStreetMap Nominatim, and Open-Meteo).
- On CachyOS or Arch Linux, install the Plasma/Qt runtime modules, package manager, and Plasma SDK:

```bash
sudo pacman -S qt6-declarative kirigami libplasma kpackage plasma-sdk
```

`plasma-sdk` provides `plasmoidviewer` for testing. `kpackage` provides `kpackagetool6` for installation and removal.

## Test and Install

Clone the repository and enter its directory:

```bash
git clone https://github.com/pdrso01/weatherline-plasmoid.git
cd weatherline-plasmoid
```

Run the widget in the Plasma test viewer:

```bash
plasmoidviewer -a .
```

Install it for the current user:

```bash
kpackagetool6 --type Plasma/Applet --install .
```

Then enter panel edit mode, choose **Add or Manage Widgets**, search for **Weatherline**, and add it to the panel or desktop.

To install changes from a later checkout:

```bash
kpackagetool6 --type Plasma/Applet --upgrade .
```

To remove it:

```bash
kpackagetool6 --type Plasma/Applet --remove com.github.pdrso01.weatherline
```

## Changes in This Version

- **Language:** by default, the widget follows the system interface language. You can choose a different language in the General settings. Available languages are English, Portuguese, Spanish, French, German, Italian, Japanese, Korean, Russian, and Chinese. If the system language is not available, the widget falls back to English.
- **Location:** search for a city or place in General settings and select a result to use its coordinates instead of IP-based location. Search results come from OpenStreetMap Nominatim.
- **Colors:** the Appearance tab lets you choose separate colors for text and temperatures, or restore the Plasma theme colors.
- **Typography:** font size and bold text are configurable in the Appearance tab. The current temperature is more prominent in the expanded forecast.
- **Diagnostics:** log messages have been standardized in English.
- **Metadata:** the widget is now named Weatherline, its package ID has changed from the original, and this repository's URL has been updated.

## Original Project

The original code and project history are available at [Chaac.Minimal.Weather by zayronxio](https://github.com/zayronxio/Chaac.Minimal.Weather/). The original author remains credited in the widget metadata.

## Repository

[github.com/pdrso01/weatherline-plasmoid](https://github.com/pdrso01/weatherline-plasmoid)
