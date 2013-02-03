class Api::StaffController < ApplicationController

  def index
    render json: Staff.search(params[:search])
  end

end
