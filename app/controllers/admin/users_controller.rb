class Admin::UsersController < Admin::BaseController
  def index
    if params[:email].present?
      user = User.find_by_email(params[:email])
      redirect_to [:admin, user] and return
    end
    @users = User
      .order(:email)
      .page(params[:page])
    if params[:role].present?
      @role = params[:role]
      @users = @users.where(role: params[:role])
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
