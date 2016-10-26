class Admin::GalleriesController < Admin::BaseController
  def index
    @galleries =  Gallery.order('date DESC').page(params[:page])
  end

  def edit
    @gallery = Gallery.find(params[:id])
  end

  def update
    @gallery = Gallery.find(params[:id])
    if @gallery.update_attributes(gallery_params)
      redirect_to edit_admin_gallery_path(@gallery)
    else
      render 'edit'
    end
  end

  def scrape
    Resque.enqueue(PhotoshelterWorker)
    flash[:success] = "The galleries are being updated in the background. This may take a few minutes."
    redirect_to admin_galleries_path
  end

  private
  def gallery_params
    params.require(:gallery).permit(:name, :date, :description)
  end
end
