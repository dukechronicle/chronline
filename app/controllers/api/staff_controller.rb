class Api::StaffController < ApplicationController

  def index
    render json: Staff.search(params[:search]).limit(10)
  end

end
