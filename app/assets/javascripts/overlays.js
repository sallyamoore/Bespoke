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
    $(".menu-bars").toggleClass("fa-bars fa-3x").toggleClass("fa-close fa-3x");
    $(".menu").toggleClass("close-menu");
    $("#menu-list").slideToggle();
  });
});

function changeOverlay() {
  collectTrash('.alert');
  $(".location-search").slideUp();
  $("div.login").slideToggle();
  $("div.nav-bar").slideToggle();
  // $("div.logout").slideToggle();
  $("div.menu").slideToggle();
  $("div.login-or-register").slideToggle();

  logged_in_user = false;
}
