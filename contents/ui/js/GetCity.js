function getNameCity(latitude, longitud, leng, callback) {
    let url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitud}&accept-language=${leng}`;
    console.log("Reverse geocoding URL:", url); // Debug the reverse geocoding URL.

    let req = new XMLHttpRequest();
    req.open("GET", url, true);
    req.setRequestHeader("User-Agent", "Weatherline/1.0 (https://github.com/pdrso01/weatherline-plasmoid)");

    req.onreadystatechange = function () {
        if (req.readyState === 4) {
            if (req.status === 200) {
                try {
                    let datos = JSON.parse(req.responseText);
                    let address = datos.address;
                    let full = address.city || address.town || address.village || address.municipality || address.suburb || address.county || address.state || "";
                    console.log("Resolved city:", full);
                    callback(full);
                } catch (e) {
                    console.error("Failed to parse the reverse geocoding response:", e);
                }
            } else {
                console.error(`Reverse geocoding request failed with status ${req.status}:`, req.responseText);
            }
        }
    };

    req.onerror = function () {
        console.error("Reverse geocoding request failed");
    };

    req.ontimeout = function () {
        console.error("Reverse geocoding request timed out");
    };

    req.send();
}

