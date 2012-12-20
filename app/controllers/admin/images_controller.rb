class Admin::ImagesController < Admin::BaseController

  def index
    @images = Image.page(params[:page]).order('created_at DESC')
  end

  def upload
  end

  def create
    @image = Image.new(params[:image])
    if @image.save
      render json: {files: @image.to_jq_upload}
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  def edit
    @image = Image.find(params[:id])
  end

  def update
    @image = Image.find(params[:id])
    if @image.update_attributes(params[:image])
      redirect_to [:edit, :admin, @image]
    else
      render 'edit'
    end
  end

  def crop
    image = Image.find(params[:id])
    image.assign_attributes(params[:image], without_protection: true)
    image.original.reprocess!(image.crop_style.underscore.to_sym)
    flash[:success] = "#{image.crop_style} version was cropped."
    redirect_to [:edit, :admin, image]
  end

  def destroy
    image = Image.find(params[:id])
    success_message = "Image \"#{image.original_file_name}\" was deleted."
    image.destroy
    flash[:success] = success_message
    redirect_to admin_images_path
  end

end
