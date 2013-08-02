class Api::ImagesController < Api::BaseController

  def index
    images = Image.order('date DESC')
      .paginate(page: params[:page], per_page: params[:limit])
    respond_with images, methods: :thumbnail_url
  end

  def show
    image = Image.find(params[:id])
    respond_with image, methods: :thumbnail_url
  end

  def create
    image = Image.new(params[:image])
    if image.save
      respond_with image, status: :created
    else
      head :bad_request
    end
  end

  def update
    @image = update_image(Image.find(params[:id]))
    if @image.save
      head :no_content
    else
      head :bad_request
    end
  end

  def destroy
    image = Image.find(params[:id])
    image.destroy
  end
end
