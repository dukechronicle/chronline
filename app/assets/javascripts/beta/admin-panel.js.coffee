initialize '.toggle-link', ->
  $(this).click ->
    adminNotif = $('.admin-notification')
    toggleLink = $(this)
    if adminNotif.hasClass('showing')
      adminNotif.removeClass('showing', 100, ->
          adminNotif.addClass('hiding') 
          toggleLink.html('[ Show ]')
      )
    else if adminNotif.hasClass('hiding')
      adminNotif.removeClass('hiding', 100, ->
          adminNotif.addClass('showing')
          toggleLink.html('[ Hide ]')
      )
    
