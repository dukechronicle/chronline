require 'taxonomy'

class Site::NewslettersController < Site::BaseController

  def show
  end

  def subscribe
    @email = params[:email]
    gb = Gibbon.new(Settings.mailchimp.api_key)
    gb.list_subscribe(id: Settings.mailchimp.list_id,
                      email_address: @email,
                      send_welcome: true)
    render 'show'
  end

  def unsubscribe
    @email = params[:email]
    gb = Gibbon.new(Settings.mailchimp.api_key)
    gb.list_subscribe(id: Settings.mailchimp.list_id,
                      email_address: @email,
                      send_goodbye: true)
    render 'show'
  end

end
