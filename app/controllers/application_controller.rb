class ApplicationController < ActionController::Base
  protect_from_forgery
  cache_sweeper :article_sweeper
end
