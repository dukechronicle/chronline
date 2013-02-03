# Facebook
initialize '#fb-root', ->
  `(function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));`

# Google+
initialize '.g-plusone', ->
  `(function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/plusone.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();`

# Twitter
initialize '.twitter-share-button, .twitter-timeline', ->
  `(function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if(d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//platform.twitter.com/widgets.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(document,"script","twitter-wjs"));`
