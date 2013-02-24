class ApplicationController < ActionController::Base
  protect_from_forgery
  cache_sweeper :article_sweeper
  cache_sweeper :image_sweeper
  cache_sweeper :staff_sweeper
  cache_sweeper :page_sweeper
end
