class Site::StaffController < Site::BaseController

  def index
    if params[:view] == :images
      @staff = Staff.find(params[:staff_id])
      @images = @staff.images.page(params[:page]).order('created_at DESC')
      @except = params[:view]
      render 'site/staff/photographer'
    else
      @except = params[:view]
      @staff = Staff.find(params[:staff_id])
      @articles = @staff.articles.page(params[:page]).order('created_at DESC')
      render 'site/staff/author'
    end
  end
  def show
    @staff = Staff.find(params[:id])
    @articles = @staff.articles.page(params[:page]).order('created_at DESC')
    if @staff.author?
      redirect_to site_staff_articles_path params[:id]
    elsif @staff.photographer?
      redirect_to site_staff_images_path params[:id]
    else
      redirect_to site_staff_articles_path params[:id]
    end
  end

end
