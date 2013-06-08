class Api::StaffController < Api::BaseController

  def index
    respond_with Staff.search(params[:search])
  end

end
