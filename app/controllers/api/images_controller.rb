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
  end

  private

  def update_image(image)
    photographer_name = params[:image].delete(:photographer_id)
    image.assign_attributes(params[:image])
    if photographer_name.blank?
      image.photographer = nil
    else
      image.photographer = Staff.find_or_create_by_name(photographer_name)
    end
    image
  end
end
