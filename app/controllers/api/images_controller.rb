class Api::ImagesController < Api::BaseController

  def index
    images = Image.order('created_at DESC')
    render json: images, methods: :thumbnail_url
  end

end
