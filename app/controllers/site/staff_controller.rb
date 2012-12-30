class Site::StaffController < Site::BaseController

  def show
    @staff = Staff.find(params[:id])
    if @staff.is_a? Author
      render 'author'
    elsif @staff.is_a? Photographer
      render 'photographer'
    end
  end

end
