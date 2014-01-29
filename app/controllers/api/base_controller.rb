class Api::BaseController < ApplicationController
  respond_to :json

  def allow_cors
    headers['Access-Control-Allow-Origin'] = '*'
  end
end
