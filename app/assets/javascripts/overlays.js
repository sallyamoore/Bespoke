$(document).ready(function() {

  if ($("body").data("logged-in-user") && $("div.nav-bar").css("display") == "none") {
    changeOverlay();
  }

  $(".guest-user").click(function(event){
    event.preventDefault();
    changeOverlay();
    $(".alert").remove();
  });

  $(".logout").click(function(event) {
    changeOverlay();
  });

  $(".login-or-register").click(function(event) {
    event.preventDefault();
    changeOverlay();
  });

  $(".directions-icon").click( function(event) {
    $(".directions-icon").toggleClass("fa-flip-horizontal");
    $(".directions").slideToggle();
  });
});

function changeOverlay() {
  collectTrash('.alert');
  $(".location-search").slideUp();
  $("div.login").slideToggle();
  $("div.nav-bar").slideToggle();
  $("div.logout").slideToggle();
  $("div.login-or-register").slideToggle();

  logged_in_user = false;
}
