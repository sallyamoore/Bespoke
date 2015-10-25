function onLocationFound(event) {
  collectLocationTrash();
  var radius = event.accuracy / 2;
  L.circleMarker(event.latlng, {
    className: 'user-location',
  })
  .addTo(this)
  .bindPopup("You are within " + radius + " meters from this point");

  $( ".user-location" ).data(event.latlng);

  L.circle(event.latlng, radius, {
    className: 'user-location',
  }).addTo(this);
}

function onLocationError(event) {
  alert(event.message);
}
