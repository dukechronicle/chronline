class Admin::ImagesController < ApplicationController
  layout 'admin'

  def upload
  end

  def create
    p params[:image][:original]
    @image = Image.new
    @image.original = params[:image][:original]
    @image.save!
    render json: @image.to_jq_upload
  end
end
