$(document).ready(function() {
  var map = new Map({
    overpassPrefix: "http://overpass-api.de/api/interpreter?data=",
    mapboxPk: "pk.eyJ1Ijoic2FsbHlhbW9vcmUiLCJhIjoiY2lmZm53MmlkOHA2YnNka25wd3BmNDB3dyJ9.F5FdTfUY5XLbzWMcWpRp2A",
    baseMap: 'sallyamoore.nkikgok3',
    startLatLon: [52.3081, 4.7642],
    minZoom: 9,
    maxZoom: 18,
    startZoom: 13,
    bikeMapLayer: 'http://{s}.tile.thunderforest.com/cycle/{z}/{x}/{y}.png',
    iconClassName: 'css-icon',
    iconSize: [ 60, 60 ],
    attribution: '&copy; <a href="http://www.thunderforest.com/">Thunderforest</a>'
  });

  map.loadMap(function(result) {
    $(".find-location").click(function(event) {
      event.preventDefault();
      toggleSearchForm();
    });

    $(".location-submit").click(function(event) {
      $('.bad-query').remove();
      event.preventDefault();
      var locationQuery = $("input.location-query").val();
      // var geocoder = L.mapbox.geocoder('mapbox.places');
      // geocoder.query(locationQuery, function(res){
      //   console.log(res);
      // });

      var latlng = map.startLatLon.join(",");
      var geocodeQuery = "https://api.mapbox.com/v4/geocode/mapbox.places/"
        + locationQuery + ".json?proximity=" + latlng + "&access_token="
        + map.mapboxPk
      $.getJSON(geocodeQuery, function(data) {
        if (data && data.features.length !== 0) {
          console.log(data.features); // returns array of place objects
          // each object has bbox, center [lat,lon], id, place_name and other attrs
        } else {
          var badQueryAlert = document.createElement('div');
          badQueryAlert.className = 'alert alert-danger bad-query';
          document.getElementsByClassName('alerts-div')[0].appendChild(badQueryAlert);
          $(badQueryAlert).text("No results. Try a different query.");
        }
      });

    });

    $(".my-location").click(function(event) {
      event.preventDefault();
      result.locate({setView: true, maxZoom: 16});
      result.on('locationfound', onLocationFound);
      result.on('locationerror', onLocationError);
    });

    result.on('zoomend, moveend', function(event) {
      $('.zoom-alert').remove();
      var zoom = result.getZoom();
      if (zoom > 11) {
        map.findBounds(map.osm_map);
      } else {
        $('.css-icon').remove();
        var zoomAlert = document.createElement('div');
        zoomAlert.className = 'alert alert-warning zoom-alert';
        document.getElementsByClassName('alerts-div')[0].appendChild(zoomAlert);
        $(zoomAlert).text("Zoom in to view clickable nodes.");
      }
    });

  });

});

function toggleSearchForm() {
  $('.bad-query').remove();
  $(".location-search").slideToggle();
}

function showPlaceResults() {
  // slide up .location-search just a little to show options below
  //
}
