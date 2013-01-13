class Admin::NewsletterController < Admin::BaseController

  def show
    @newsletter_page = Page.find_by_path('/newsletter')
  end

  def send_newsletter
    if params[:newsletter] && params[:newsletter].has_key?(:article)
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

end
