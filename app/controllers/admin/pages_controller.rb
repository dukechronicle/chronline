class Admin::PagesController < Admin::BaseController

  def index
    @pages = Page.page(params[:page]).order('updated_at DESC')
  end

  def new
    @page = Page.new
  end

end
