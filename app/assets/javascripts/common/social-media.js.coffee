# Facebook
initialize '#fb-root', ->
  # https://developers.facebook.com/docs/javascript/howto/jquery/
  $.ajaxSetup(cache: true)
  $.getScript '//connect.facebook.net/en_US/all.js', =>
    FB.init
      appId      : $(this).data('app-id')  # App ID from the app dashboard
      status     : true  # Check Facebook Login status
      xfbml      : true  # Look for social plugins on the page
      cookie     : true  # Enable cookie support

    $(this).trigger('fbinit')

# Google+
initialize '.g-plusone', ->
  `(function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/plusone.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();`

# Twitter
initialize '.twitter-share-button, .twitter-timeline, .twitter-tweet', ->
  `(function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if(d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//platform.twitter.com/widgets.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(document,"script","twitter-wjs"));`
