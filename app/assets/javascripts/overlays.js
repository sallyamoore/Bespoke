$(document).ready(function() {

  if ($("body").data("logged-in-user") && $("div.nav-bar").css("display") == "none") {
    changeOverlay();
  }

  $(".guest-user").click(function(event){
    event.preventDefault();
    changeOverlay();
  });

  $(".logout").click(function(event) {
    changeOverlay();
  });

  $(".login-or-register").click(function(event) {
    event.preventDefault();
    changeOverlay();
  });
});

function changeOverlay() {
  $("div.login").slideToggle();
  $("div.nav-bar").slideToggle();
  $("div.logout").slideToggle();
  $("div.login-or-register").slideToggle();

  logged_in_user = false;
}
