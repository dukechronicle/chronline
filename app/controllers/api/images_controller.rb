class Api::ImagesController < ApplicationController

  def index
    images = Image.order('date DESC')
      .paginate(page: 1, per_page: params[:limit])
    render json: images, methods: :thumbnail_url
  end

end
