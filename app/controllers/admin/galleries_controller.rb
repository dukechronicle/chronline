class Admin::GalleriesController < Admin::BaseController

  def index
    @galleries = Gallery.all
  end

  def edit
    @gallery = Gallery.find_by_gid(params[:id])
  end

  def update
    @gallery = update_gallery(Gallery.find_by_gid(params[:id]))
    if @gallery.save
      redirect_to edit_admin_gallery_path(@gallery.gid)
    else
      render 'edit'
    end
  end

  private
  def update_gallery(gallery)
    gallery.update_attributes(params[:gallery])
    gallery
  end

 end
