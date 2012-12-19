class Admin::ImagesController < ApplicationController
  layout 'admin'

  def index
    @images = Image.page(params[:page]).order('created_at DESC')
  end

  def upload
  end

  def create
    @image = Image.new(params[:image])
    if @image.save
      render json: {files: @image.to_jq_upload}
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end
end
