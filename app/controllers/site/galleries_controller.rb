class Site::GalleriesController < Site::BaseController

  def index
    @galleries =  Gallery.all
    begin
      custom_page and return
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def show
    @gallery = Gallery.find_by_gid(params[:id])
    #@images = gallery.get_gallery_images
    @recent = Gallery.order('created_at DESC').limit(3)
  end

end
