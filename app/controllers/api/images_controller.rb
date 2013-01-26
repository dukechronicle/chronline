class Api::ImagesController < ApplicationController

  def index
    images = Image.order('date DESC')
    render json: images, methods: :thumbnail_url
  end

end
