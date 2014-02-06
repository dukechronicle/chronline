$(document).ready ->
  $("#response-input").focus ->
    $("#recaptcha").show()

$(document).ready ->
  $("#up_vote").on "ajax:success", (e, data, status, xhr) ->
    alert "upvoted."
  $("#down_vote").on "ajax:success", (e, data, status, xhr) ->
    alert "downvoted."

$(document).ready ->
  $("#response-form").on("ajax:success", (e, data, status, xhr) ->
    alert "posted"
  ).bind "ajax:error", (e, xhr, status, error) ->
    alert "post failed"