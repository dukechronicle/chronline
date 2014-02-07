$(document).ready ->
  $("#response-input").focus ->
    $("#recaptcha").show()

$(document).ready ->
  $(".up_vote").on "ajax:success", (e, data, status, xhr) ->
    $count = $(this).siblings(".up_vote_number")
    prev_number = parseInt($count.text())
    if $(this).hasClass("upvoted")
      $count.text(prev_number-1)
      $count.css("font-weight","normal")
      $(this).removeClass("upvoted")
    else
      $count.text(prev_number+1)
      $count.css("font-weight","bold")
      $(this).addClass("upvoted")

  $(".down_vote").on "ajax:success", (e, data, status, xhr) ->
    $count = $(this).siblings(".down_vote_number")
    prev_number = parseInt($count.text())
    if $(this).hasClass("downvoted")
      $count.text(prev_number-1)
      $count.css("font-weight","normal")
      $(this).removeClass("downvoted")
    else
      $count.text(prev_number+1)
      $count.css("font-weight","bold")
      $(this).addClass("downvoted")


$(document).ready ->
  $("#response-form").on("ajax:success", (e, data, status, xhr) ->
    alert "posted"
  ).bind "ajax:error", (e, xhr, status, error) ->
    alert "post failed"