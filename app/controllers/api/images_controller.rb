class Api::ImagesController < ApplicationController
  def index
    images = Image.page(params[:page]).order('created_at DESC')
    render json: images
  end
end
