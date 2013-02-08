class Api::ImagesController < ApplicationController

  def index
    images = Image.order('date DESC')
      .paginate(page: params[:page], per_page: params[:limit])
    render json: images, methods: :thumbnail_url
  end

end
