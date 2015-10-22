$(document).on( "click", ".css-icon", function(event) {
  console.log("double clicked!");
  $.ajax({
    type: "POST",
    url: "/location/create",
    data: $(event.target).data(),
    success: function(data) {
      // change color of node,
      showAlert(nodeSaved);
    }
  });
});
