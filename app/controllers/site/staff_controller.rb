class Site::StaffController < Site::BaseController

  def articles
    @staff = Staff.find(params[:id])
    @articles = @staff.articles.page(params[:page]).order('created_at DESC')
  end

  def images
    @staff = Staff.find(params[:id])
    @images = @staff.images.page(params[:page]).order('date DESC')
  end

  def show
    @staff = Staff.find(params[:id])
    if @staff.photographer? and not @staff.author?
      redirect_to images_site_staff_path(@staff)
    else
      redirect_to articles_site_staff_path(@staff)
    end
  end

end
