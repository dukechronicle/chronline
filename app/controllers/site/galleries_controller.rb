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
    @galleries =  Gallery.all
  end

  def show
    gallery = Gallery.find(params[:id])
    @images =  @api.get_gallery_images(gallery.pid)
  end

  private

    def authenticate
      @api = PhotoshelterAPI.new(Settings.photoshelter.email, Settings.photoshelter.password)
      @api.authenticate
    end
end
