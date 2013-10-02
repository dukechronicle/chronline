class Site::GalleriesController < Site::BaseController
  before_filter :authenticate

  def index
    galleries = Rails.cache.fetch(:galleries) do
      @api.get_all_galleries
    end
    galleries.each do |gallery|
      if !Gallery.exists?(:pid => gallery['id']) then
        Gallery.create(pid: gallery['id'], name: gallery['name'], description: gallery['description'])
      end
    end
    render json: Gallery.all
  end

  def show
    render json: @api.get_gallery_images(params[:id])
  end

  private

    def authenticate
      @api = PhotoshelterAPI.new(Settings.photoshelter.email, Settings.photoshelter.password)
      @api.authenticate
    end
end
