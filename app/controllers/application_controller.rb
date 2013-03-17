class ApplicationController < ActionController::Base
  CRAWLERS = [/facebookexternalhit\//i]

  protect_from_forgery
  cache_sweeper :article_sweeper
  cache_sweeper :image_sweeper
  cache_sweeper :staff_sweeper
  cache_sweeper :page_sweeper


  protected

  def social_crawler?
    CRAWLERS.any? {|crawler| request.user_agent =~ crawler}
  end

end
