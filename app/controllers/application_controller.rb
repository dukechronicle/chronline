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
    redirect_ssl if user_signed_in?
  end

  def redirect_ssl
    if user_signed_in? and request.protocol != "https://"
      redirect_to protocol: "https://"
    end
  end

end
