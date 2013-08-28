class Site::GalleriesController < Site::BaseController
  before_filter :authenticate

  def index
    render json: @api.get_all_galleries
  end

  def show
    render json: @api.get_gallery_images(params[:gallery_id])
  end

  private

    def authenticate
      @api = PhotoshelterAPI.new(Settings.photoshelter.email, Settings.photoshelter.password)
      @api.authenticate
    end
end
