class Site::GalleriesController < Site::BaseController

  def index
    begin
      custom_page and return
    rescue ActiveRecord::RecordNotFound
      nil
    end

    @galleries =  Gallery.all
  end

  def show
    @gallery = Gallery.find_by_gid(params[:id])
    #@images = gallery.get_gallery_images
    @recent = Gallery.all(:order => 'created_at DESC', :limit => 3)
  end

end
