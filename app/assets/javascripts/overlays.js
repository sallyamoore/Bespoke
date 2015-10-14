$(document).ready(function() {
  $(".guest-user").click(function(event){
    event.preventDefault();
    $("div.login").slideUp();
    $("div.nav-bar").slideDown();
  });
});
