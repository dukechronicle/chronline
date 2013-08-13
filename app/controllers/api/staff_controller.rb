class Api::StaffController < Api::BaseController
  before_filter :authenticate_user!, only: [:create, :update, :destroy]


  def index
    staff = Staff.paginate(page: params[:page], per_page: params[:limit])
    if params.include? :search
      staff = staff.search(params[:search])
    end
    if params.include? :columnist
      value = params[:columnist] != 'false' ? true : [false, nil]
      staff = staff.where(columnist: value)
    end
    if params.include? :photographer
      comparison = params[:photographer] != 'false' ? '>' : '='
      staff = staff
        .joins('LEFT OUTER JOIN images ON staff.id = images.photographer_id')
        .group('staff.id')
        .having("COUNT(images.id) #{comparison} 0")
    end
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
