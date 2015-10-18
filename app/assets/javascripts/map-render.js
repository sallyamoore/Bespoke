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
      var geocoder = L.mapbox.geocoder('mapbox.places');

      // API query -- leaflet geocoder
      geocoder.query(locationQuery, showMap);
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

  function showMap(err, data) {
    var featuresFound = data.results.features.length === 0 ? false :true;
    if (featuresFound) {
      map.osm_map.setView(data.latlng, 13);
      L.marker(data.latlng).addTo(map.osm_map)
        .bindPopup(data.results.features[0].place_name);
      toggleSearchForm();

    } else {
      var badQueryAlert = document.createElement('div');
      badQueryAlert.className = 'alert alert-danger ' + alertContent.badQuery.class;
      document.getElementsByClassName('alerts-div')[0].appendChild(badQueryAlert);
      $(badQueryAlert).text(alertContent.badQuery.text);
    }
  }

});



function toggleSearchForm() {
  $(".location-search").slideToggle();
}

function collectTrash(trashToCollect) {
  $(trashToCollect).remove();
}
