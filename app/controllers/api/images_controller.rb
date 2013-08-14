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
      head :bad_request
    end
  end

  def update
    image = update_image(Image.find(params[:id]))
    if image.save
      head :no_content
    else
      head :bad_request
    end
  end

  def destroy
    image = Image.find(params[:id])
    image.destroy
    head :no_content
  end

  private

  def update_image(image)
    photographer_name = request.POST.delete(:photographer_id)
    image.assign_attributes(request.POST)
    if photographer_name.blank?
      image.photographer = nil
    else
      image.photographer = Staff.find_or_create_by_name(photographer_name)
    end
    image
  end
end
