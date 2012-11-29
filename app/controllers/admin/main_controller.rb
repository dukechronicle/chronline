class Admin::MainController < ApplicationController

  def home
    print request.subdomain
  end

end
