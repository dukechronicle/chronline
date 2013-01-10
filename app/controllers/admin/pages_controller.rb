class Admin::PagesController < Admin::BaseController
  def index
    @pages = Page.page(params[:page]).order('updated_at DESC')
  end

  def edit
  end

  def new
  end
end
