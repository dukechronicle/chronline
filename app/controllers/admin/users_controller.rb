class Admin::UsersController < Admin::BaseController
  def index
    @users = User
      .order(:email)
      .page(params[:page])
    if params[:role].present?
      @users = @users.where(role: params[:role])
    end
  end
end
