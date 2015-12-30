$(document).ready(function() {

  if ($("body").data("logged-in-user") && $("div.nav-bar").css("display") == "none") {
    changeOverlay();
  }

  $(".guest-user").click(function(event){
    event.preventDefault();
    changeOverlay();
    $(".alert").remove();
  });

  $(".logout").click(function() {
    changeOverlay();
  });

  $(".login-or-register").click(function(event) {
    event.preventDefault();
    changeOverlay();
  });

  $(".directions-icon").click( function() {
    $(".directions-icon").toggleClass("fa-flip-vertical");
    $("#directions").slideToggle();
  });

  $(".menu").click( function() {
    event.preventDefault();
    $("#menu-list").slideToggle();
  });
});

function changeOverlay() {
  collectTrash('.alert');
  $(".location-search").slideUp();
  $("div.login").slideToggle();
  $("div.nav-bar").slideToggle();
  $("div.logout").slideToggle();
  $("div.menu").slideToggle();
  $("div.login-or-register").slideToggle();

  logged_in_user = false;
}
