class Admin::BlogSeriesController < Admin::BaseController
  def index
    @blog_series = Blog::Series.page(params[:page])
  end
end
