class Api::ImagesController < Api::BaseController
  before_filter :authenticate_user!, only: [:create, :update, :destroy]

  def index
    images = Image.order('date DESC')
      .paginate(page: params[:page], per_page: params[:limit])
    respond_with images, methods: :thumbnail_url,
      properties: { published_url: ->(image) { image.original.url } }
  end

  def show
    image = Image.find(params[:id])
    respond_with image, methods: :thumbnail_url,
      properties: { published_url: ->(image) { image.original.url } }
  end

  def create
    image = Image.new(request.POST)
    if image.save
      respond_with image, status: :created, location: api_images_url,
        properties: { published_url: ->(image) { image.original.url } }
    else
      head :unproccessable_entity
    end
  end

  def update
    image = Image.find(params[:id])
    image.update_attributes(request.POST)
    if image.save
      head :no_content
    else
      render json: image.errors, status: :unproccessable_entity
    end
  end

  def destroy
    image = Image.find(params[:id])
    image.destroy
    head :no_content
  end
end
