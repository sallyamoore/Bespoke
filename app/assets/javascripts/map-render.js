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

  var trashToCollect = '.bad-query, .zoom-alert';
  var alertContent = {
    badQuery:  {
      class: 'bad-query',
      text: 'No matching locations! Check your query and try again.'
    },
    zoomAlert: {
      class: 'zoom-alert',
      text: 'Zoom in to view clickable nodes.' }
  };

  map.loadMap(function(result) {
    $(".find-location").click(function(event) {
      event.preventDefault();
      collectTrash(trashToCollect);
      toggleSearchForm();
    });

    $(".location-submit").click(function(event) {
      event.preventDefault();
      collectTrash(trashToCollect);
      var locationQuery = $("input.location-query").val();
      // var geocoder = L.mapbox.geocoder('mapbox.places');
      // geocoder.query(locationQuery, function(res){
      //   console.log(res);
      // })
      var latlng = map.startLatLon.join(",");
      var geocodeQuery = "https://api.mapbox.com/v4/geocode/mapbox.places/"
        + locationQuery + ".json?proximity=" + latlng + "&access_token="
        + map.mapboxPk

      $.getJSON(geocodeQuery, function(data) {
        // returns array of place objects
        // each object has bbox, center [lat,lon], id, place_name and other attrs
        // For now, I map to first one (closest match to startLatLon).
        // Possible refactor: Show list of place objects and user selects.
        if (data && data.features.length !== 0) {
          toggleSearchForm();

          // returns 'center' in format [lon, lat], so must reverse
          var dataLatLng = data.features[0].center.reverse();

          // for first object, add clickable marker (display place name as popup)
          L.marker(dataLatLng).addTo(map.osm_map)
            .bindPopup(data.features[0].place_name);

          // move center of map to location
           map.osm_map.setView(dataLatLng, map.startZoom);
        } else {
          var badQueryAlert = document.createElement('div');
          badQueryAlert.className = 'alert alert-danger ' + alertContent.badQuery.class;
          document.getElementsByClassName('alerts-div')[0].appendChild(badQueryAlert);
          $(badQueryAlert).text(alertContent.badQuery.text);
        }
      });

    });

    $(".my-location").click(function(event) {
      event.preventDefault();
      collectTrash(trashToCollect);
      result.locate({setView: true, maxZoom: 16});
      result.on('locationfound', onLocationFound);
      result.on('locationerror', onLocationError);
    });

    result.on('zoomend, moveend', function(event) {
      collectTrash(trashToCollect);
      var zoom = result.getZoom();
      if (zoom > 11) {
        map.findBounds(map.osm_map);
      } else {
        $('.css-icon').remove();
        var zoomAlert = document.createElement('div');
        zoomAlert.className = 'alert alert-warning ' + alertContent.zoomAlert.class;
        document.getElementsByClassName('alerts-div')[0].appendChild(zoomAlert);
        $(zoomAlert).text(alertContent.zoomAlert.text);
      }
    });

  });

});

function toggleSearchForm() {
  $(".location-search").slideToggle();
}

function collectTrash(trashToCollect) {
  $(trashToCollect).remove();
}
