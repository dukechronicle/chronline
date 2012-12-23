class Admin::StaffController < Admin::BaseController

  def index
  end

  def new
    @staff = Staff.new
  end

  def create
    type = params[:staff].delete(:type)
    cls = Staff.subclasses.find {|cls| cls.name == type}

    if cls.nil?
      @staff = Staff.new(params[:staff])
      @staff.errors.add(:type, "must be selected")
      return render 'new'
    end

    @staff = cls.new(params[:staff])
    if @staff.save
      redirect_to admin_root_path
    else
      render 'new'
    end
  end

  def update

  end
end
