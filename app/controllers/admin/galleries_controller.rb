class Admin::GalleriesController < Admin::BaseController

  def index
    @galleries =  Gallery.order('date DESC').page(params[:page])
  end

  def edit
    @gallery = Gallery.find(params[:id])
  end

  def update
    @gallery = Gallery.find(params[:id])
    if @gallery.update_attributes(params[:gallery])
      redirect_to edit_admin_gallery_path(@gallery)
    else
      render 'edit'
    end
  end

 end
