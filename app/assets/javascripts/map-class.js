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
    this.bounds;
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
      this.bounds = bounds;
      this.getNodesFromDB(map);
      this.apiCall(map);
    },

    getNodesFromDB: function(leaflet_map) {
      // Query db for these bounds
      var this_map = this;
      var from_api = false;
      var bounds = { swLat: this.bounds[0], swLng: this.bounds[1], neLat: this.bounds[2], neLng: this.bounds[3] };
      $.get( "/locations/nodes", bounds, function(nodeData) {
          // populate node markers using DB info
          this_map.createNodeMarkers(leaflet_map, nodeData.data, from_api);
        }, 'json'
      );
    },

    apiCall: function(leaflet_map) {
      var this_map = this;
      var bounds = this.bounds;
      var from_api = true;

      $.getJSON(this.overpassPrefix + '[out:json][bbox:' + (bounds.join()) +
      '];(relation["type"="network"]["network"="rcn"];node["rcn_ref"~"^[0-9][0-9]$"];);out body;>;out skel qt;',
        function(data) {
          // populate node markers using API info
          this_map.createNodeMarkers(leaflet_map, data.elements, from_api);
      });
    },

    createNodeMarkers: function(leaflet_map, data, from_api) {
      // create clickable markers for each bike node in bounds
      var iconClassName = this.iconClassName;
      var iconSize = this.iconSize;

      for (var i = 0; i < data.length; i++) {
        var nodeIdTag = "node-" + data[i].id;
        var notPresent = $("." + nodeIdTag).closest(document.documentElement).length === 0;

        if (data[i].tags && data[i].lat && notPresent) {
          var nodeData = {
            node_id: data[i].id,
            node_number: data[i].tags.rcn_ref,
            latitude: data[i].lat,
            longitude: data[i].lon
          };

          if (from_api) { populateDB(nodeData); }

          var cssIcon = L.divIcon({
            className: nodeIdTag,
            iconSize: iconSize,
            html: nodeData.node_number
          });

          var nodeMarker = new L.marker([nodeData.latitude, nodeData.longitude], {
            icon: cssIcon
          }).addTo(leaflet_map);

          $( "." + nodeIdTag ).addClass(iconClassName);
          $( "." + nodeIdTag ).data(nodeData);
        }

        if ($("body").data("logged-in-user")) {
          addLocationSave();
        }
      }
    }
  };
})(this);
