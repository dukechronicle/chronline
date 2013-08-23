class Site::NewslettersController < Site::BaseController

  def show
  end

  def subscribe
    @email = params[:email]
    gb = Gibbon.new(Settings.mailchimp.api_key)
    begin
      gb.list_subscribe(
        id: Settings.mailchimp.list_id,
        email_address: @email,
        send_welcome: true
      )
    rescue Gibbon::MailChimpError => e
      case e.code
      when 214
        # List_AlreadySubscribed
        @error = "#{params[:email]} is already subscribed."
      else
        raise e
      end
    end
    render 'show'
  end

  def unsubscribe
    @email = params[:email]
    gb = Gibbon.new(Settings.mailchimp.api_key)
    begin
      gb.list_unsubscribe(
        id: Settings.mailchimp.list_id,
        email_address: @email,
        send_goodbye: true
      )
    rescue Gibbon::MailChimpError => e
      case e.code
      when 215
        # List_NotSubscribed
        @error = "#{params[:email]} is not subscribed."
      else
        raise e
      end
    end
    render 'show'
  end

end
