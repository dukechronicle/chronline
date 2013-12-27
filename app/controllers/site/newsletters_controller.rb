class Site::NewslettersController < Site::BaseController

  def show
  end

  def subscribe
    @email = params[:email]
    gb = Gibbon::API.new(ENV['MAILCHIMP_API_KEY'])
    begin
      logger.debug @email
      gb.lists.subscribe(
        id: ENV['MAILCHIMP_LIST_ID'],
        email: { email: @email },
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
    gb = Gibbon::API.new(ENV['MAILCHIMP_API_KEY'])
    begin
      gb.lists.unsubscribe(
        id: ENV['MAILCHIMP_LIST_ID'],
        email: { email: @email },
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
