(function(exports) {
  "use strict";

  function Map(options) {
    this.overpassPrefix = options.overpassPrefix;
    this.mapboxPk = options.mapboxPk;
    this.baseMap = options.baseMap;
    this.startLatLon = options.startLatLon;
    this.startZoom = options.startZoom;
    this.bikeMapLayer = options.bikeMapLayer;
    this.markerFormat = options.markerFormat;
    this.attribution = options.attribution;
  }
  exports.Map = Map;

  Map.prototype = {
    loadMap: function() {
      L.mapbox.accessToken = this.mapboxPk;
      var new_map = L.mapbox.map('map', this.baseMap)
        .setView(this.startLatLon, this.startZoom);
      L.tileLayer(this.bikeMapLayer, {
        attribution: this.attribution
      }).addTo(new_map);
      this.getBounds(new_map);
    },

    getBounds: function(map) {
      var bounds = [
        map.getBounds()._southWest.lat,
        map.getBounds()._southWest.lng,
        map.getBounds()._northEast.lat,
        map.getBounds()._northEast.lng
      ];
      this.apiCall(map, bounds);
    },

    apiCall: function(map, bounds) {
      var markerFormat = this.markerFormat;
      $.getJSON(this.overpassPrefix + '[out:json];(relation["type"="network"]["network"="rcn"]('
        + (bounds.join()) +
        ');node(r)->.nodes;rel(r);way(r););out body;>;out skel qt;',
        function(data) {

          // create clickable markers for each bike node in bounds
          for (var i = 0; i < data.elements.length - 1; i++) {
            if (data.elements[i].tags && data.elements[i].lat)  {
              new L.circleMarker(
                [data.elements[i].lat, data.elements[i].lon],
                markerFormat)
              .addTo(map);
            }
          }
        });
    },

    onLocationFound: function(event, map) {
        var radius = event.accuracy / 2;

        L.marker(event.latlng).addTo(map)
            .bindPopup("You are within " + radius + " meters from this point").openPopup();

        L.circle(event.latlng, radius).addTo(map);
    },

    onLocationError: function(event) {
        alert(event.message);
    }
  };
})(this);
