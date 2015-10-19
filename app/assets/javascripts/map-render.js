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
    // Show location search input
    $(".find-location").click(function(event) {
      event.preventDefault();
      collectTrash(trashToCollect);
      toggleSearchForm();
    });

    // Search for entered location
    $(".location-submit").click(function(event) {
      event.preventDefault();
      collectTrash(trashToCollect);
      collectLocationTrash();

      var locationQuery = $("input.location-query").val();
      var geocoder = L.mapbox.geocoder('mapbox.places');

      // API query -- leaflet geocoder
      geocoder.query(locationQuery, showMap);
    });

    // show queried location on map
    function showMap(err, data) {
      var featuresFound = data.results.features.length === 0 ? false :true;
      if (featuresFound) {
        map.osm_map.setView(data.latlng, 13);

        marker = new L.marker(data.latlng);
        map.osm_map.addLayer(marker);
        marker.bindPopup(data.results.features[0].place_name);

        toggleSearchForm();

      } else {
        var badQueryAlert = document.createElement('div');
        badQueryAlert.className = 'alert alert-danger ' + alertContent.badQuery.class;
        document.getElementsByClassName('alerts-div')[0].appendChild(badQueryAlert);
        $(badQueryAlert).text(alertContent.badQuery.text);
      }
    }

    // Find user's current location
    $(".my-location").click(function(event) {
      event.preventDefault();
      collectTrash(trashToCollect);
      collectLocationTrash();

      result.locate({setView: true, maxZoom: 16});
    });
    // Listener: When location found/error, execute function in my-location.js
    result.on('locationfound', onLocationFound);
    result.on('locationerror', onLocationError);

    // Populate markers on zoom or move.
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

  // Route to clicked bike node.
  $(document).on( "click", ".css-icon", function(event) {
    var nodeData = $( this ).data(),
      directions = L.mapbox.directions({
        profile: 'mapbox.cycling'
      }),
      routeFormat = {
        routeStyle: {
          color: '#F60131',
          weight: 7,
          opacity: 0.75,
          className: "route"
        }
      },
      originLatLng;

    if ($(".user-location").data()) {
      originLatLng = L.latLng($(".user-location").data().lat, $(".user-location").data().lng)
    } else {
      originLatLng = marker.getLatLng();
    }

    console.log(originLatLng);

    // WIP Origin is current location OR searched location
    directions.setOrigin(originLatLng);
    // Destination is clicked node
    directions.setDestination(L.latLng(nodeData.latitude, nodeData.longitude));

    directions.query();
    var directionsLayer = L.mapbox.directions.layer(directions, routeFormat)
      .addTo(map.osm_map);
    var directionsRoutesControl = L.mapbox.directions.routesControl('routes', directions)
      .addTo(map.osm_map);

    // Remove layers if another .css-icon is clicked
    $(document).on( "click", ".css-icon", function() {
      map.osm_map.removeLayer(directionsLayer);
      map.osm_map.removeLayer(directionsRoutesControl);
    });
  });

});

function toggleSearchForm() {
  $(".location-search").slideToggle();
}

function collectTrash(trashToCollect) {
  $(trashToCollect).remove();
}

function collectLocationTrash() {
  $(".user-location").parent().remove();
  $("img.leaflet-marker-icon img.leaflet-marker-shadow").remove();
}
