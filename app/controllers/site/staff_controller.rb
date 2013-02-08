class Site::StaffController < Site::BaseController

  def show
    @staff = Staff.find(params[:id])
    @articles = @staff.articles.page(params[:page]).order('created_at DESC')
    #puts "p? #{@staff.is_photographer?} a? #{@staff.is_author?}"
    puts "staff params #{params}"
    if @staff.is_author?
      redirect_to site_staff_articles_path params[:id]
    elsif @staff.is_photographer?
      redirect_to site_staff_images_path params[:id]
    else
      redirect_to site_staff_articles_path params[:id]
    end
    #render 'author'
  end

end
