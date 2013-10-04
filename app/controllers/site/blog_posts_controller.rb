class Site::BlogPostsController < Site::BaseController
  include ::PostsController
  before_filter :redirect_blog_post, only: :show


  def index
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])
      @taxonomy = @blog.taxonomy
      @blog_posts = @blog.posts
        .published
        .includes(:authors, :image)
        .order('published_at DESC')
        .page(params[:page])
    else
      @taxonomy = Taxonomy['Blogs']
      render 'site/blogs/index'
    end
  end

  def show
    @blog_post = Blog::Post
      .includes(:authors, image: :photographer)
      .find(@blog_post)
    @blog = @blog_post.blog
    @taxonomy = @blog.taxonomy
  end

  def tags
    @blog = Blog.find(params[:blog_id])
    @taxonomy = @blog.taxonomy
    @blog_posts = @blog.posts
      .published
      .tagged_with(params[:tag])
      .order('published_at DESC')
      .page(params[:page])
  end

  def categories
    @blog = Blog.find(params[:blog_id])
    @taxonomy = Taxonomy['Blogs', params[:blog_id], params[:category]]
    @blog_posts = Blog::Post
      .published
      .section(@taxonomy)
      .order('published_at DESC')
      .page(params[:page])
    render 'index'
  end
end
