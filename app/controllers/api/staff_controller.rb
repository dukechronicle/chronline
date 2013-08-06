class Api::StaffController < Api::BaseController
  before_filter :authenticate_user!, only: [:create, :update, :destroy]


  def index
    staff = Staff.paginate(page: params[:page], per_page: params[:limit])
    respond_with staff
  end

  def search
    respond_with Staff.search(params[:search])
  end

  def show
    staff = Staff.find(params[:id])
    respond_with staff
  end

  def create
    staff = Staff.new(params[:staff])
    if staff.save
      respond_with staff, status: :created, location: api_staff_url(staff)
    else
      render json: staff.errors, status: :bad_request
    end
  end

  def update
    staff = Staff.find(params[:id])
    if staff.update_attributes(params[:staff])
      head :no_content
    else
      respond_with staff.errors, status: :bad_request
    end
  end

  def destroy
    staff = Staff.find(params[:id])
    staff.destroy
    head :no_content
  end

end
