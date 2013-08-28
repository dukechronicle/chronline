class Api::GalleriesController < ApplicationController
  # include PhotoshelterAPI

  def index
    @api = PhotoshelterAPI.new(Settings.photoshelter.email, Settings.photoshelter.password)
    @api.authenticate
    render json: @api.get_all_galleries
  end

end