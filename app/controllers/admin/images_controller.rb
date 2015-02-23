class Admin::ImagesController < Admin::BaseController
  def index
    @images = Image.page(params[:page]).order('date DESC')
  end

  def upload
  end

  def create
    image_params = params.require(:image).permit(:original)
    @image = Image.new(image_params)
    if @image.save
      render json: { files: [jq_upload_data(@image)] }
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  def edit
    @image = Image.find(params[:id])
  end

  def update
    @image = update_image(Image.find(params[:id]))
    if @image.save
      redirect_to [:edit, :admin, @image]
    else
      render 'edit'
    end
  end

  def crop
    image_params = params[:image]
    image = Image.find(params[:id])
    image.crop!(
      image_params[:crop_style],
      image_params[:crop_x].to_i,
      image_params[:crop_y].to_i,
      image_params[:crop_w].to_i,
      image_params[:crop_h].to_i
    )
    flash[:success] = "#{image.crop_style.capitalize} version was cropped."
    redirect_to [:edit, :admin, image]
  end

  def destroy
    image = Image.find(params[:id])
    success_message = "Image \"#{image.original_file_name}\" was deleted."
    image.destroy
    flash[:success] = success_message
    redirect_to admin_images_path
  end

  private
  def update_image(image)
    image_params = params.require(:image).permit(
      :attribution, :caption, :credit, :date, :location, :photographer_id
    )
    photographer_name = image_params.delete(:photographer_id)
    image.assign_attributes(image_params)
    if photographer_name.blank?
      image.photographer = nil
    else
      image.photographer = Staff.find_or_create_by_name(photographer_name)
    end
    image
  end

  def jq_upload_data(image)
    {
      name: image.original_file_name,
      size: image.original_file_size,
      url: edit_admin_image_path(image),
      thumbnail_url: image.original.url(:rectangle_183x),
      delete_url: admin_image_path(image),
      delete_type: 'DELETE',
     }
  end
end
