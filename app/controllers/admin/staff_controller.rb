class Admin::StaffController < Admin::BaseController

  def index
  end

  def new
    @staff = Staff.new
  end

  def create
    @staff = Staff.new(params[:staff])
    if @staff.save
      redirect_to admin_staff_index_path
    else
      render 'new'
    end
  end

  def edit
    @staff = Staff.find(params[:id])
  end

  def update
    @staff = Staff.find(params[:id])
    if @staff.update_attributes(params[:staff])
      redirect_to admin_staff_index_path
    else
      render 'edit'
    end
  end

  def destroy
    staff = Staff.find(params[:id])
    staff.destroy
    flash[:success] = "#{staff.class.name} \"#{staff.name}\" was deleted."
    redirect_to admin_staff_index_path
  end

end
