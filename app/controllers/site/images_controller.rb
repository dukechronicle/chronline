class Site::ImagesController < Site::BaseController

  def index
    @staff = Staff.find(params[:staff_id])
    render 'site/staff/photographer'
  end
end
