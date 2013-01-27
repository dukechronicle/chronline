class Site::StaffController < Site::BaseController

  def show
    @staff = Staff.find(params[:id])
    render 'author'
  end

end
