class Admin::BlogPostsController < Admin::BaseController

  def index
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])
      @blog_posts = Blog::Post.where(blog: @blog.id)
    end
  end

  def new
    @blog_post = Blog::Post.new(blog: params[:blog_id])
  end

  def create
    @blog_post = Blog::Post.new(params[:blog_post])
    if @blog_post.save
      redirect_to admin_blogs_path
    else
      render 'new'
    end
  end

  def edit
  end

end
