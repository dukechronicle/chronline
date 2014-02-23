class Admin::GalleriesController < Admin::BaseController

  def index
    @galleries =  Gallery.order('date DESC').page(params[:page])
  end

  def edit
    @gallery = Gallery.find(params[:id])
  end

  def update
    @gallery = Gallery.find(params[:id])
    @gallery.update_attributes(params[:gallery])
    if @gallery.save
      redirect_to edit_admin_gallery_path(@gallery)
    else
      render 'edit'
    end
  end

  def scrape
    Resque.enqueue(PhotoshelterWorker)
    redirect_to admin_galleries_path
  end
 end
