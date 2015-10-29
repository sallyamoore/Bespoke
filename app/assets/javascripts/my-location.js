function onLocationFound(event) {
  collectLocationTrash();
  var radius = event.accuracy / 2;
  L.circleMarker(event.latlng, {
    className: 'user-location'
  })
  .addTo(this)
  .bindPopup("You are within " + radius + " meters from this point");

  $( ".user-location" ).data(event.latlng);

  L.circle(event.latlng, radius, {
    className: 'user-location'
  }).addTo(this);
}

function onLocationError(event) {
  var alert = document.createElement('div');
  alert.className = 'alert alert-warning no-geoloc'
  document.getElementsByClassName('alerts-div')[0].appendChild(alert);
  $(alert).text(event.message);
  setTimeout(function() {
    $('.alert').fadeOut('fast');
  }, 3000);
}
