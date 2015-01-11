class Site::NewslettersController < Site::BaseController
  def show
    redirect_to site_newsletter_url(subdomain: :beta)
  end
end
