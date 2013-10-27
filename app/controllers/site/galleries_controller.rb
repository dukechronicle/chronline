class Site::GalleriesController < Site::BaseController

  def index
    galleries = Rails.cache.fetch(:galleries) do
      PhotoshelterAPI.instance.get_all_galleries
    end
    galleries.each do |gallery|
      if !Gallery.exists?(:pid => gallery['id']) then
        Gallery.create(pid: gallery['id'], name: gallery['name'], description: gallery['description'])
      end
    end
    render json: Gallery.all
  end

  def show
    @gallery = Gallery.find_by_pid params[:id]
    render json: @gallery.get_gallery_images
  end

end