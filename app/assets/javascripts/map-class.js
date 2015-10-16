(function(exports) {
  "use strict";

  function Map(options) {
    this.overpassPrefix = options.overpassPrefix;
    this.mapboxPk = options.mapboxPk;
    this.baseMap = options.baseMap;
    this.startLatLon = options.startLatLon;
    this.minZoom = options.minZoom;
    this.maxZoom = options.maxZoom;
    this.startZoom = options.startZoom;
    this.bikeMapLayer = options.bikeMapLayer;
    this.markerFormat = options.markerFormat;
    this.attribution = options.attribution;
  }
  exports.Map = Map;

  Map.prototype = {
    loadMap: function(callback) {
      L.mapbox.accessToken = this.mapboxPk;

      var new_map = L.mapbox.map('map', this.baseMap, {
        minZoom: this.minZoom,
        maxZoom: this.maxZoom }).setView(this.startLatLon, this.startZoom);

      L.tileLayer(this.bikeMapLayer, {
        attribution: this.attribution
      }).addTo(new_map);

      this.findBounds(new_map);
      callback(new_map);
    },

    findBounds: function(map) {
      var bounds = [
        map.getBounds()._southWest.lat,
        map.getBounds()._southWest.lng,
        map.getBounds()._northEast.lat,
        map.getBounds()._northEast.lng
      ];
      console.log(bounds);
      // comment out to avoid making too many requests to overpass api. Need to limit or cache this query.
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
            .bindLabel(data.elements[i].tags.rcn_ref, {
              noHide: true,
              clickable: true,
              offset: [-17, -15],
              className: "node-marker"
            })
            .addTo(map);
          }
        }
      });
    },
  };
})(this);
