class Api::StaffController < ApplicationController

  def index
    cls = Staff.subclasses.find {|cls| cls.name == params[:type]} || Staff
    render json: cls.search(params[:search])
  end

end
