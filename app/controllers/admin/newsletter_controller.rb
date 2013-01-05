class Admin::NewsletterController < Admin::BaseController

  def show
  end

  def send_newsletter
    newsletter = ArticleNewsletter.new(params[:newsletter])
    newsletter.send_campaign
    flash[:success] = "Article sent successfully"
    redirect_to admin_newsletter_path
  end

end
