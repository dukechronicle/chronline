class Site::BlogPostsController < Site::BaseController

  def index
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])
      @blog_posts = Blog::Post
        .published
        .where(blog: @blog.id)
        .order('published_at DESC')
        .page(params[:page])
    else
      @blog = true  # Sets blog nav tab active
      render 'site/blogs/index'
    end
  end

  def show
    @blog_post = Blog::Post.find(params[:id])
    @blog = @blog_post.blog
  end

  def tags
    @blog = Blog.find(params[:blog_id])
    @blog_posts = Blog::Post
      .published
      .where(blog: @blog.id)
      .tagged_with(params[:tag])
      .order('published_at DESC')
      .page(params[:page])
  end

end
