class Site::BlogPostsController < Site::BaseController
  include ::PostsController
  before_filter :redirect_blog_post, only: :show


  def index
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])
      @blog_posts = @blog.posts
        .includes(:authors, :image)
        .order('published_at DESC')
        .page(params[:page])
    else
      @blog = true  # Sets blog nav tab active
      render 'site/blogs/index'
    end
  end

  def show
    @blog = @blog_post.blog
  end

  def tags
    @blog = Blog.find(params[:blog_id])
    @blog_posts = @blog.posts
      .published
      .tagged_with(params[:tag])
      .order('published_at DESC')
      .page(params[:page])
  end
end
