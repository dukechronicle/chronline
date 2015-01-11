class Beta::GalleriesController < Beta::BaseController
  before_filter :redirect_gallery, only: :show
  def index
    begin
      custom_page and return
    rescue ActiveRecord::RecordNotFound
      @galleries =  Gallery.order('date DESC').page(params[:page])
      nil
    end
  end

  def show
    @gallery = Gallery.find(params[:id])
    @recent = Gallery.nonempty.order('date DESC').limit(3)
  end

  private
  def redirect_gallery
    @gallery = Gallery.find(params[:id])
    expected_path = url_for(
      id: @gallery,
      controller: controller_path,
      action: action_name,
      only_path: true
    )
    if not social_crawler? and request.path != expected_path
      return redirect_to expected_path, status: :moved_permanently
    end
  end

end
