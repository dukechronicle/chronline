class Api::StaffController < Api::BaseController

  def index
    staff = Staff.paginate page: params[:page], per_page: params[:limit]
    respond_with staff
  end

  def show
    staff = Staff.find params[:id]
    respond_with staff
  end

  def create
    staff = Staff.new params[:staff]
    if staff.save
      respond_with staff, status: :created, location: api_staff_index_url
    else
      head :bad_request, location: api_staff_index_url
    end
  end

  def update
    staff = Staff.find params[:id]
    if staff.update_attributes params[:staff]
      head :no_content
    else
      head :bad_request
    end
  end

  def destroy
    staff = Staff.find params[:id]
    staff.destroy
  end
end
