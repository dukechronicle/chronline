class Admin::StaffController < Admin::BaseController
  def index
  end

  def new
    @staff = Staff.new
  end

  def create
    @staff = Staff.new(staff_params)
    if @staff.save
      redirect_to site_staff_url(@staff, subdomain: :www)
    else
      render 'new'
    end
  end

  def edit
    @staff = Staff.find(params[:id])
  end

  def update
    @staff = Staff.find(params[:id])
    if @staff.update_attributes(staff_params)
      redirect_to site_staff_url(@staff, subdomain: :www)
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

  private
  def staff_params
    params.require(:staff).permit(
      :affiliation, :biography, :columnist, :headshot_id, :name, :tagline,
      :twitter
    )
  end
end
