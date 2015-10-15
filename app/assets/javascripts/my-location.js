function onLocationFound(event) {
  var radius = event.accuracy / 2;
  L.circleMarker(event.latlng).addTo(this)
    .bindPopup("You are within " + radius + " meters from this point");

  L.circle(event.latlng, radius).addTo(this);
}

function onLocationError(event) {
  alert(event.message);
}
