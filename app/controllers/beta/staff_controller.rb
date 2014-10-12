class Beta::StaffController < Beta::BaseController

  def articles
    @staff = Staff.find(params[:id])
    @posts = @staff.articles.order('published_at DESC').page(params[:page])
    render 'posts'
  end

  def blog_posts
    @staff = Staff.find(params[:id])
    @posts = @staff.blog_posts.order('published_at DESC').page(params[:page])
    render 'posts'
  end

  def images
    @staff = Staff.find(params[:id])
    @images = @staff.images.page(params[:page]).order('date DESC').includes(:articles)
  end

  def show
    @staff = Staff.find(params[:id])
    if social_crawler?
      nil # Render "show" view
    elsif @staff.photographer? and not @staff.author?
      redirect_to images_site_staff_path(@staff)
    else
      redirect_to articles_site_staff_path(@staff)
    end
  end

end
