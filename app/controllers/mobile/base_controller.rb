class Mobile::BaseController < ApplicationController
  layout 'mobile'

  def not_found
    render 'errors/404m'
  end
end
