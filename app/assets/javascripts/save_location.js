function populateDB(data) {
  var nodeData = data;
  $.ajax({
    type: "POST",
    url: "/locations/create",
    data: nodeData,
    success: function(data) {
      console.log("Bike node location saved to database");
    }
  });
}

function addLocationSave() {
  // Show/hide save icon
  $(".css-icon").on("click", function(event){
    var position = $(event.target).offset();
    var nodeData = $(event.target).data();

    $(".save-location").css("top", position.top);
    $(".save-location").css("left", position.left);
    $(".save-location").data(nodeData);
    $(".save-location").show();
    setTimeout(function() {
      $('.save-location').fadeOut('fast');
    }, 2000);
  });
}

var nodeSaved = {
  class: 'alert-success node-saved',
  text: "Success! Location saved to your account."
};

$(document).ready(function() {
  $(".save-location").on("click", function(event) {
    // click event is returning the child of '.save-location' (IDK why)
    // so below calls parent to get the data.
    var nodeData = $(event.target).parent().data();
    $.ajax({
      type: "POST",
      url: "/locations/create",
      data: nodeData,
      success: function(data) {
        // change color of node,
        showAlert(nodeSaved);
      }
    });
  });
});
