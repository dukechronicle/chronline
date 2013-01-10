class Admin::PagesController < Admin::BaseController

  def index
    @pages = Page.page(params[:page]).order('updated_at DESC')
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      redirect_to admin_pages_path
    else
      render 'new'
    end
  end

end
