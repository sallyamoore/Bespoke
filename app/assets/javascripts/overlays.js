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

    var visible = $("#menu-list").hasClass('slide-right');
    $("#menu-list")
      .css("display", "block")
      .toggleClass('slide-left', visible)
      .toggleClass('slide-right', !visible);
  });
});

function changeOverlay() {
  collectTrash('.alert');
  $(".location-search").slideUp();
  $("div.login").slideToggle();
  $("div.nav-bar").slideToggle();
  $("div.menu").slideToggle();
  $("div.login-or-register").slideToggle();

  if ($("#menu-list").hasClass('slide-right')) {
    $("#menu-list").addClass('slide-left');
    $("#menu-list").removeClass('slide-right');
  }

  if ($(".menu-bars").hasClass('fa-close')) {
    $(".menu-bars").toggleClass("fa-bars fa-3x").toggleClass("fa-close fa-3x");
  }

  logged_in_user = false;
}
