class Admin::NewsletterController < Admin::BaseController

  def show
    @newsletter_page = Page.find_by_path('/newsletter')
    @timezone = "Eastern Time (US & Canada)"
  end

  def send_newsletter
    params[:newsletter][:scheduled_time] = construct_time(params[:newsletter])

    if params[:newsletter].has_key?(:article)
      newsletter = ArticleNewsletter.new(params[:newsletter])
    else
      newsletter = DailyNewsletter.new(params[:newsletter])
    end

    newsletter.create_campaign
    message = newsletter.send_campaign!
    flash[:success] = message
    redirect_to admin_newsletter_path
  end

  private
  def construct_time(params)
    timezone = params.delete(:scheduled_timezone)
    if timezone.present?
      # Hour and minute are passed as scheduled_time(4i), scheduled_time(5i) by
      # Rails form helper. Find next future date at which that time.
      current_time = ActiveSupport::TimeZone[timezone].now
      date = 1.upto(5).map { |i| params.delete("scheduled_time(#{i}i)").to_i }
      date[0..2] = [current_time.year, current_time.month, current_time.day]
      scheduled_time = ActiveSupport::TimeZone[timezone].local(*date)
      if scheduled_time.past?
        scheduled_time + 1.day
      else
        scheduled_time
      end
    end
  end

end
