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
    },
    attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>'
  });

  map.loadMap(function(result) {
    $(".my-location").click(function(event){
      event.preventDefault();
      result.locate({setView: true, maxZoom: 16});
      console.log(map);
      result.on('locationfound', map.onLocationFound());
      result.on('locationerror', map.onLocationError());
    });

  });


});
