class Mobile::BaseController < ApplicationController
  layout 'mobile'

  def not_found
    render 'mobile/404'
  end
end
