class Site::BlogPostsController < Site::BaseController

  def index
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])
      @blog_posts = Blog::Post.includes(:author, :image)
        .where(blog: @blog.id).page(params[:page])
    else
      @blog = true  # Sets blog nav tab active
      render 'site/blogs/index'
    end
  end

  def show
    @blog_post = Blog::Post.includes(:author, :image).find(params[:id])
    @blog = @blog_post.blog
  end

end
