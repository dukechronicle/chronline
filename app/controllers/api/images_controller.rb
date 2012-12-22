class Api::ImagesController < ApplicationController
  def index
    images = Image.order('created_at DESC')
    render json: images
  end
end
