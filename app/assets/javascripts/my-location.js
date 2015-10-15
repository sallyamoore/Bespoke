// $(document).ready(function() {
//   $(".my-location").click(function(event){
//     event.preventDefault();
//     map.locate({setView: true, maxZoom: 16});
//     map.on('locationfound', map.onLocationFound(event, map));
//     map.on('locationerror', map.onLocationError(event, map));
//   )};
// });

// FOR CALLING CURRENT LOCATION FUNCTION

// ON CLICK OF FIND ME:
// map.locate({setView: true, maxZoom: 16});
// map.on('locationfound', map.onLocationFound);
// map.on('locationerror', map.onLocationError);

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
