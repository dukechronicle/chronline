class Api::ImagesController < Api::BaseController
  before_filter :authenticate_user!, only: [:create, :update, :destroy]

  def index
    images = Image
      .order('date DESC')
      .paginate(page: params[:page], per_page: params[:limit])
    respond_with_image images
  end

  def show
    image = Image.find(params[:id])
    respond_with_image image
  end

  def create
    image = Image.new(request.POST)
    if image.save
      respond_with_image image, status: :created, location: api_image_url(image)
    else
      render json: image.errors, status: :unproccessable_entity
    end
  end

  def update
    image = Image.find(params[:id])
    if image.update_attributes(request.POST)
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

  private
  def respond_with_image(image, options = {})
    options.merge!(
      methods: :thumbnail_url,
      properties: { published_url: ->(image) { image.original.url } },
    )
    respond_with image, options
  end
end
