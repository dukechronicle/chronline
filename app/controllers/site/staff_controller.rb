class Site::StaffController < Site::BaseController

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
