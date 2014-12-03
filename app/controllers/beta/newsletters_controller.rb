class Beta::NewslettersController < Beta::BaseController
  def show
    redirect_to site_newsletter_url(subdomain: :beta)
  end
end
