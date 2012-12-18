class Admin::ImagesController < ApplicationController
  layout 'admin'

  def upload
  end

  def create
    @image = Image.new(params[:image])
    @image.save!
    render json: @image.to_jq_upload
  end
end
