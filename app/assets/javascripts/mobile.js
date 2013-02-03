//= require jquery/jquery.js
//= require jquery.mobile-1.2.0.min.js
//= require underscore/underscore.js
//= require date.format.js

//= require util
//= require initialize
//= require common/social-media
//= require common/analytics
//= require site/disqus.js
//= require_tree ./mobile

// TODO: figure out scripting issues with ajax transitions
$.mobile.ajaxEnabled = false;

window.fbAsyncInit = function() {
  FB.init({
    status     : true, // check login status
    cookie     : true, // enable cookies to allow the server to access the session
    xfbml      : true  // parse XFBML
  });
};