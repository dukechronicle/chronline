class Site::StaffController < Site::BaseController

  def show
    @staff = Staff.find(params[:id])
    @articles = @staff.articles.page(params[:page]).order('created_at DESC')
    render 'author'
  end

end
