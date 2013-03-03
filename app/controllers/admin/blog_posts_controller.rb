class Admin::BlogPostsController < Admin::BaseController

  def index
  end

  def new
    @blog_post = BlogPost.new
  end

  def create
    @blog_post = BlogPost.new(params[:blog_post])
    if @blog_post.save
      redirect_to admin_blog_posts_path
    else
      render 'new'
    end
  end

  def edit
  end

end
