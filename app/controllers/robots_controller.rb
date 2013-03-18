class RobotsController < ApplicationController

  def show
    file = case request.subdomain.to_sym
           when :m   then :mobile
           when :www then :site
           else request.subdomain
           end
    render "#{file}.txt"
  end

end
