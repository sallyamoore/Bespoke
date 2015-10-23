function addLocationSave() {
  // Show/hide save icon
  $(".css-icon").on("mouseenter", function(event){
    // console.log($(event.target).css("top", event.target.));
    var position = $(event.target).offset();
    var nodeData = $(event.target).data();

    $(".save-location").css("top", position.top);
    $(".save-location").css("left", position.left);
    $(".save-location").data(nodeData);
    $(".save-location").show();
  });

  $(".css-icon").on("mouseleave", function(){
    $(".save-location").delay(2000).fadeOut('fast');
    // console.log($(".save-location"));
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
