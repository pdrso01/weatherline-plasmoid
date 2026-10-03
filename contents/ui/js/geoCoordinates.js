function obtenerCoordenadas(callback) {
    let url = "http://ip-api.com/json/?fields=lat,lon";

    let req = new XMLHttpRequest();
    req.open("GET", url, true);

    req.onreadystatechange = function () {
        if (req.readyState === 4) {
            if (req.status === 200) {
                try {
                    let datos = JSON.parse(req.responseText);
                    let latitud = datos.lat;
                    let longitud = datos.lon;
                    let full = `${latitud}, ${longitud}`;
                    console.log(`Coordinates resolved: ${full}`);
                    callback(full); // Devolver coordenadas completas
                } catch (error) {
                    console.error("Failed to parse the coordinates response:", error);
                    callback(null); // Devolver null en caso de error de parsing
                }
            } else {
                console.error(`Coordinate lookup request failed with status ${req.status}`);
                callback(null); // Devolver null en caso de error de solicitud
            }
        }
    };

    req.onerror = function () {
        console.error("Network error while looking up coordinates.");
        callback(null); // Devolver null en caso de error de red
    };

    req.send();
}
