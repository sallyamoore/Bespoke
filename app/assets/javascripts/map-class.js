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
    this.iconClassName = options.iconClassName;
    this.iconSize = options.iconSize;
    this.attribution = options.attribution;
    this.osm_map;
  }
  exports.Map = Map;

  Map.prototype = {
    loadMap: function(callback) {
      L.mapbox.accessToken = this.mapboxPk;

      var new_map = L.mapbox.map('map', this.baseMap, {
        scrollWheelZoom: false,
        minZoom: this.minZoom,
        maxZoom: this.maxZoom }).setView(this.startLatLon, this.startZoom);

      L.tileLayer(this.bikeMapLayer, {
        attribution: this.attribution
      }).addTo(new_map);

      this.osm_map = new_map;
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
      // comment out to avoid making too many requests to overpass api. Need to limit or cache this query.
      // this.apiCall(map, bounds);
    },

    apiCall: function(map, bounds) {
      var iconClassName = this.iconClassName;
      var iconSize = this.iconSize;

      $.getJSON(this.overpassPrefix + '[out:json][bbox:' + (bounds.join()) +
      '];(relation["type"="network"]["network"="rcn"];node["rcn_ref"~"^[0-9][0-9]$"];);out body;>;out skel qt;',
        function(data) {

        // create clickable markers for each bike node in bounds
        for (var i = 0; i < data.elements.length - 1; i++) {
          var nodeNum = "node-" + data.elements[i].id;
          var notPresent = $("." + nodeNum).closest(document.documentElement).length === 0;

          if (data.elements[i].tags && data.elements[i].lat && notPresent) {
            var cssIcon = L.divIcon({
              className: nodeNum,
              iconSize: iconSize,
              html: data.elements[i].tags.rcn_ref
            });

            new L.marker([data.elements[i].lat, data.elements[i].lon], {
              icon: cssIcon
            }).addTo(map);

            $( "." + nodeNum ).addClass(iconClassName);
          }
        }
      });
    },
  };
})(this);
