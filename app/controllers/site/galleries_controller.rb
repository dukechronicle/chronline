class Site::GalleriesController < Site::BaseController

  def index
    @galleries =  Gallery.order('date DESC')
    begin
      custom_page and return
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end

  def show
    @gallery = Gallery.find(params[:id])
    @recent = Gallery.order('created_at DESC').limit(3).reject(&:empty?)
  end

end
