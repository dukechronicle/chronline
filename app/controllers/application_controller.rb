class ApplicationController < ActionController::Base
  CRAWLERS = [/facebookexternalhit\//i]

  protect_from_forgery
  cache_sweeper :article_sweeper
  cache_sweeper :image_sweeper
  cache_sweeper :staff_sweeper
  cache_sweeper :page_sweeper

  before_filter :force_ssl if Rails.env.production?


  def authenticate_admin!
    authenticate_user!
    unless current_user.admin?
      respond_to do |format|
        format.html do
          render 'unauthorized', layout: 'error', status: :unauthorized
        end
        format.json do
          head :unauthorized
        end
      end
    end
  end

  def social_crawler?
    CRAWLERS.any? { |crawler| request.user_agent =~ crawler }
  end

  def force_ssl
    redirect_ssl if user_signed_in?
  end

  def redirect_ssl
    redirect_to protocol: "https://" if request.protocol != "https://"
  end
end
