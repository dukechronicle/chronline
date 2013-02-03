// function initializeFacebook() {
//   console.log("test")
  window.fbAsyncInit = function() {
    FB.init({
      // appId      : '335954613131615', // App ID
      appId      : '150954285059117', // DEV ID
      //channelUrl : '//WWW.YOUR_DOMAIN.COM/channel.html', // Channel File
      status     : true, // check login status
      cookie     : true, // enable cookies to allow the server to access the session
      xfbml      : true  // parse XFBML
    });

    if ($("#facebook-social-share").length > 0)
      socialShare();

    if ($("#fb\\:like").length > 0) {
      // subscribe to like button
      FB.Event.subscribe('edge.create', function(url) {
          _gaq.push(['_trackSocial', 'facebook', 'like', url]);
      });
    }
  };

  // Load the SDK Asynchronously
  // (function(d){
  //   var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
  //   if (d.getElementById(id)) {return;}
  //   js = d.createElement('script'); js.id = id; js.async = true;
  //   js.src = "//connect.facebook.net/en_US/all.js";
  //   ref.parentNode.insertBefore(js, ref);
  // }(document));
// }

function socialShare() {
  var readTrigger = null;
  var readTriggerTime = 500; //20000
  FB.Event.subscribe('auth.statusChange', function(response) {

    if (response.authResponse) {
      var accessToken = response.authResponse.accessToken;
      var status = "on";

      if ($.cookie("disable-sharing")) {
        status = "off";
      }

      updateRecentActivities(accessToken);
      if (status === "on") {
        readTrigger = setTimeout(function(){markRead(accessToken)}, readTriggerTime);
      }

      $('#facebook-social-share').show();
      $('#facebook-social-share .status').html(status);

      $('#facebook-social-share .activity-button').click(function(event) {
        event.stopPropagation();
        event.preventDefault();
        $('#facebook-social-share .activities').toggle();
      });
      var shareButton = $('#facebook-social-share .share-button');
      shareButton.click(function(event) {
        event.stopPropagation();
        event.preventDefault();
        if (status === "on") {
          status = "off";
          $.cookie("disable-sharing", true);
          clearTimeout(readTrigger)
        } else {
          status = "on"
          $.cookie("disable-sharing", null);
          readTrigger = setTimeout(function(){markRead(accessToken)}, readTriggerTime);
        }
        shareButton.children(".status").html(status);
      });
    }
  });
}

function markRead(accessToken) {
  console.log("markign read")
  var url = "http://www.dukechronicle.com" + location.pathname;
  console.log(accessToken)
  FB.api('/me/news.reads', 'post', { article: url, access_token: accessToken }, function(response) {
    console.log(response)
    if (!response || response.error) {
      alert('Error occured');
    } else {
      alert('Post ID: ' + response.id);
      updateRecentActivities(accessToken);
    }
  });
  // $.post(
  //   "https://graph.facebook.com/me/news.reads",
  //   {article: url, access_token: accessToken},
  //   function(data) {
  //     console.log(data)
  //     updateRecentActivities(accessToken);
  //   },
  //   "json"
  // )
}

function updateRecentActivities(accessToken) {
  console.log("updating")
  $.getJSON('https://graph.facebook.com/me/news.reads',
    {limit: 5, access_token: accessToken},
    function(data) {
      var html = "<h4>Recent Activity</h4><table>";
      var first = "first";
      _.forEach(data.data, function(row) {
        html+= "<tr id='activity-" + row.id + "' class='" + first + "'>" +
          "<td class='url'><a href='" + row.data.article.url + "'>" + row.data.article.title + "</a></td>" +
          "<td class='delete'><a class='delete' data-id='" + row.id + "' href='#'>x</a></td>" +
          "</tr>"
        first = "";
      });
      html += "</table>";
      $('#facebook-social-share .activities').empty();
      $('#facebook-social-share .activities').append(html);
      $('#facebook-social-share .activities td.delete').delegate("a", "click", function() {
        var activityId = $(this).attr("data-id");
        $.ajax({
          async:true, 
          dataType:'script', 
          type:'delete', 
          url:"https://graph.facebook.com/" + activityId,
          success: function(msg){ 
            alert("success");
            $('#activity-' + activityId).remove();
          },
          error: function(msg){
            alert("error:" + msg);
          }
        });
        // $.get("/xhrproxy/delete_activity", {activity_id: activityId, access_token: accessToken });
        return false;
      });
    }
  );
}