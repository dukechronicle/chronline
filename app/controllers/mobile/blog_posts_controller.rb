class Mobile::BlogPostsController < Mobile::BaseController
  include ::PostsController
  before_filter :redirect_blog_post, only: :show


  def index
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])
      @blog_posts = @blog.posts
        .published
        .order('published_at DESC')
        .includes(:authors, :image)
        .page(params[:page])
    else
      render 'mobile/blogs/index'
    end
  end

  def show
    @blog_post = Blog::Post
      .includes(:authors, image: :photographer)
      .find(@blog_post)
    @blog = @blog_post.blog
  end
end
