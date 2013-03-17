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
      admin_blog_posts_path(params[:blog_id])
    else
      render 'new'
    end
  end

  def edit
    @blog_post = Blog::Post.find(params[:id])
  end

  def update
    @blog_post = Blog::Post.find(params[:id])
    if @blog_post.update_attributes(params[:blog_post])
      admin_blog_posts_path(params[:blog_id])
    else
      render 'edit'
    end
  end

  def destroy
    blog_post = Blog::Post.find(params[:id])
    blog_post.destroy
    flash[:success] = %Q[Blog post "#{blog_post.title}" was deleted.]
    redirect_to admin_blog_posts_path(params[:blog_id])
  end

end
