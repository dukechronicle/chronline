//= require jquery
//= require jquery_ujs
//= require jquery-ui/ui/jquery-ui
//= require foundation
//= require modernizr/modernizr
//= require underscore/underscore
//= require backbone/backbone
//= require marionette/lib/backbone.marionette
//= require jade/runtime
//= require lightbox2/js/lightbox

//= require util
//= require initialize
//= require common/social-media
//= require common/analytics
//= require common/local-time
//= require_tree ./site

$(document).foundation({
  tooltip: {
    tip_template: function (selector, content) {
      return '<span data-selector="' + selector + '" class="'
        + Foundation.libs.tooltip.settings.tooltip_class.substring(1)
        + '">' + content + '</span>';
    }
  }
});
