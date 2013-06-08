class Api::ImagesController < Api::BaseController

  def index
    images = Image.order('date DESC')
      .paginate(page: params[:page], per_page: params[:limit])
    respond_with images, methods: :thumbnail_url
  end

end
