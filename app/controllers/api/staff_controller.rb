class Api::StaffController < Api::BaseController
  before_filter :authenticate_user!, only: [:create, :update, :destroy]

  def index
    staff = Staff.paginate(page: params[:page], per_page: params[:limit])
    if params.include? :search
      staff = staff.search(params[:search])
    end
    if params.include? :columnist
      staff = staff.columnist(!params[:columnist].inquiry.false?)
    end
    if params.include? :photographer
      staff = staff.photographer(!params[:photographer].inquiry.false?)
    end
    respond_with_staff staff
  end

  def show
    staff = Staff.find(params[:id])
    respond_with_staff staff
  end

  def create
    staff = Staff.find_by_name(params[:name])
    unless staff.nil?
      redirect_to api_staff_url(staff), status: :found
      return
    end

    staff = Staff.new(params[:staff])
    if staff.save
      respond_with_staff staff, status: :created, location: api_staff_url(staff)
    else
      render json: staff.errors, status: :unprocessable_entity
    end
  end

  def update
    staff = Staff.find(params[:id])
    if staff.update_attributes(params[:staff])
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

  private
  def respond_with_staff(staff, options = {})
    options.merge!(
      properties: { photographer: ->(staff) { staff.photographer? } }
    )
    respond_with staff, options
  end
end
