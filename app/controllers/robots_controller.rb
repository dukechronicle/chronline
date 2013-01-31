class RobotsController < ApplicationController
  caches_action :show  # Heroku doesn't support page caching

  def show
    file = case request.subdomain.to_sym
           when :m   then :mobile
           when :www then :site
           else request.subdomain
           end
    render "#{file}.txt"
  end

end
