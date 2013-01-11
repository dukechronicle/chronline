class Admin::PagesController < Admin::BaseController

  def index
    @pages = Page.page(params[:page]).order('updated_at DESC')
  end

  def new
    @page = Page.new
    render 'form'
  end

  def edit
    @page = Page.find(params[:id])
    render 'form'
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      redirect_to admin_pages_path
    else
      render 'form'
    end
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      redirect_to admin_pages_path
    else
      render 'form'
    end
  end

  def destroy
    page = Page.find(params[:id])
    page.destroy
    flash[:success] = "Page \"#{page.title}\" was deleted."
    redirect_to admin_pages_path
  end

end
