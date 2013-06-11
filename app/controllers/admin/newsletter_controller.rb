class Admin::NewsletterController < Admin::BaseController

  def show
    @newsletter_page = Page.find_by_path('/newsletter')
    @timezone = "Eastern Time (US & Canada)"
  end

  def send_newsletter
    params[:newsletter][:scheduled_time] = construct_time(params[:newsletter])

    if params[:newsletter].has_key?(:article)
      message = "Article sent successfully"
      newsletter = ArticleNewsletter.new(params[:newsletter])
    else
      message = "Newsletter sent successfully"
      newsletter = DailyNewsletter.new(params[:newsletter])
    end

    newsletter.send_campaign
    flash[:success] = message
    redirect_to admin_newsletter_path
  end

  private
  def construct_time(params)
    timezone = params.delete(:scheduled_timezone)
    if timezone.present?
      # Rails form helper time inputs are named scheduled_time(1i)...
      date = 1.upto(5).map { |i| params.delete("scheduled_time(#{i}i)").to_i }
      scheduled_time = ActiveSupport::TimeZone[timezone].local(*date)
      if scheduled_time.past?
        scheduled_time + 1.day
      else
        scheduled_time
      end
    end
  end

end
