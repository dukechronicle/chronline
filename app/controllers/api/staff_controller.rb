class Api::StaffController < Api::BaseController
  before_filter :authenticate_user!, only: [:create, :update, :destroy]


  def index
    staff = Staff.paginate(page: params[:page], per_page: params[:limit])
    respond_with staff,
      properties: { photographer: ->(staff) { staff.photographer? } }
  end

  def show
    staff = Staff.find(params[:id])
    respond_with staff,
      properties: { photographer: ->(staff) { staff.photographer? } }
  end

  def create
    staff = Staff.new(request.POST)
    if staff.save
      respond_with staff, status: :created, location: api_staff_url(staff)
    else
      render json: staff.errors, status: :unprocessable_entity
    end
  end

  def update
    staff = Staff.find(params[:id])
    if staff.update_attributes(request.POST)
      head :no_content
    else
      render json: staff.errors, status: :unprocessable_entity
    end
  end

  def destroy
    staff = Staff.find(params[:id])
    staff.destroy
    head :no_content
  end

end
