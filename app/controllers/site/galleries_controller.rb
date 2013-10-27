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
    @galleries =  Gallery.all
  end

  def show
    gallery = Gallery.find(params[:id])
    @images = gallery.get_gallery_images
  end

end
