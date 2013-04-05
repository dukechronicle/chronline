class ApplicationController < ActionController::Base
  CRAWLERS = [/facebookexternalhit\//i]

  protect_from_forgery
  cache_sweeper :article_sweeper

  before_filter :force_ssl if Rails.env.production?


  protected

  def social_crawler?
    CRAWLERS.any? {|crawler| request.user_agent =~ crawler}
  end

  def force_ssl
    if user_signed_in? and request.protocol != "https://"
      redirect_ssl
    end
  end

  def redirect_ssl
    redirect_to protocol: "https://"
  end

end
