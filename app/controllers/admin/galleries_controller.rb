class Admin::GalleriesController < Admin::BaseController

  def index
    @galleries = Gallery.all
  end

  def edit
    @gallery = Gallery.find_by_gid(params[:id])
  end

  def update
    @gallery = update_gallery(Gallery.find_by_gid(params[:id]))
    puts "gallery: #{@gallery.name}"
    if @gallery.save
      redirect_to edit_admin_gallery_path(@gallery.gid)
    else
      render 'edit'
    end
  end

  def destroy
  end

  private
  def update_gallery(gallery)
    new_name = params[:gallery][:name]
    if new_name
      gallery.name = new_name
    end
    return gallery
  end

 end
