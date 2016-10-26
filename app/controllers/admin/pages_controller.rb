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
    @page.layout.generate_model
    @embedded = @page.layout.embedded
    render 'form'
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(page_params)
      # TODO: refactor this
      redirect_to (site_root_url(subdomain: :www) + @page.path[1..-1])
    else
      render 'form'
    end
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to (site_root_url(subdomain: :www) + @page.path[1..-1])
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

  private
  def page_params
    params.require(:page).permit(
      :image_id, :description, :layout_data, :layout_template, :path, :title
    )
  end
end
