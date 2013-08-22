//= require jquery.cookie/jquery.cookie

initialize('#facebook-social-share', function () {
    $('#fb-root').on('fbinit', socialShare);
});

function activateSocial(accessToken) {
  var readTrigger = null;
  var readTriggerTime = 20000;

  var status = "on";
  var shareButton = $('#facebook-social-share .share-button').html("Sharing is <u class=\"status\">on</u>");

  if ($.cookie("disable-sharing")) {
    status = "off";
    $('#facebook-social-share .activities').hide();
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

  var shareButton = $('#facebook-social-share .share-button').unbind('click');
  shareButton.click(function(event) {
    event.stopPropagation();
    event.preventDefault();
    if (status === "on") {
      status = "off";
      $.cookie("disable-sharing", true, {expires: 365 * 50});
      clearTimeout(readTrigger)
    } else {
      status = "on"
      $.cookie("disable-sharing", null, {expires: 365 * 50});
      readTrigger = setTimeout(function(){markRead(accessToken)}, readTriggerTime);
    }
    shareButton.children(".status").html(status);
  });
}

function checkPermisions(accessToken) {
  // Check if we have the right permissions
  FB.api('/me/permissions', function (response) {
    // Check if we have the correct permissions
    if (response.data[0] != undefined && response.data[0].publish_actions != undefined && response.data[0].publish_actions == 1) {
      // User has enabled publish_actions
      activateSocial(accessToken);
    }
  });
}

function socialShare() {
  // On Status Change, if auto login
  statusChangeHandle = function(response) {
    if (response.authResponse) {
      console.log("Auto Login"); console.log(response);
      var accessToken = response.authResponse.accessToken;
      checkPermisions(accessToken);
    }
  }
  FB.Event.subscribe('auth.statusChange', statusChangeHandle);

  // Setup Login Button
  $('#facebook-social-share .share-button').click(function(event) {
    event.stopPropagation();
    event.preventDefault();
    FB.Event.unsubscribe('auth.statusChange', statusChangeHandle);
    FB.login(function(response) {
      console.log("Manual Login"); console.log(response);
      if (response.authResponse) {
        console.log('Welcome!  Fetching your information.... ');
        var accessToken = response.authResponse.accessToken;
        checkPermisions(accessToken)
      } else {
        console.log('User cancelled login or did not fully authorize.');
      }
    }, {scope: 'publish_actions'});
  });


  $('#facebook-social-share').show();
  $('#facebook-social-share .activities').hide();
}

function markRead(accessToken) {
  console.log(accessToken)
  var url = location.href;
  FB.api('/me/news.reads', 'post', { article: url, access_token: accessToken }, function(response) {
    if (!response || response.error) {
      console.log('Error occured when marking article as read: ' + response.error);
      console.log(response.error)
    } else {
      console.log("Sucess marking article as read.")
      updateRecentActivities(accessToken);
    }
  });
}

function updateRecentActivities(accessToken) {
  FB.api('/me/news.reads', { limit: 5, access_token: accessToken }, function(response) {
    var html = "<h4>Recent Activity</h4><table>";
    var first = "first";
    _.forEach(response.data, function(row) {
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
        FB.api(activityId, 'delete', function(response) {
          if (!response || response.error) {
            console.log('Error occured');
          } else {
            $('#activity-' + activityId).remove();
            console.log('Post was deleted');
          }
        });
        return false;
      });
    }
  );
}
