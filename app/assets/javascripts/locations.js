$(document).ready(function() {
  var map = new Map({
    overpassPrefix: "http://overpass-api.de/api/interpreter?data=",
    mapboxPk: "pk.eyJ1Ijoic2FsbHlhbW9vcmUiLCJhIjoiY2lmZm53MmlkOHA2YnNka25wd3BmNDB3dyJ9.F5FdTfUY5XLbzWMcWpRp2A",
    baseMap: 'sallyamoore.nkikgok3',
    startLatLon: [52.3081, 4.7642],
    startZoom: 12,
    bikeMapLayer: 'http://{s}.tile.thunderforest.com/cycle/{z}/{x}/{y}.png',
    markerFormat: {
      color: "#01D298",
      opacity: 1.0,
      fill: false,
      weight: 3.5,
      radius: 10
    }
  });
  map.loadMap();
})

// FOR CALLING CURRENT LOCATION FUNCTION
// map.locate({setView: true, maxZoom: 16});
// map.on('locationfound', onLocationFound);
// map.on('locationerror', onLocationError);


//
// finds current location.
// function onLocationFound(event) {
//     var radius = event.accuracy / 2;
//
//     L.marker(event.latlng).addTo(map)
//         .bindPopup("You are within " + radius + " meters from this point").openPopup();
//
//     L.circle(event.latlng, radius).addTo(map);
// }

// error if current location can't be found
// function onLocationError(event) {
//     alert(event.message);
// }
