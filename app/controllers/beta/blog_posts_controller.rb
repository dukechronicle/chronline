class Beta::BlogPostsController < Beta::BaseController
  include ::PostsController
  before_filter :redirect_blog_post, only: :show


  def index
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])
      @taxonomy = @blog.taxonomy
      @blog_posts = @blog
        .posts
        .includes(:authors, :image, :tags, series: :image)
        .order('published_at DESC')
        .page(params[:page])
    else
      @taxonomy = Taxonomy.new(:blogs)
      render 'site/blogs/index'
    end
  end

  def show
    @blog = @blog_post.blog
    @taxonomy = @blog.taxonomy
  end

  def tags
    @blog = Blog.find(params[:blog_id])
    @taxonomy = @blog.taxonomy
    @blog_posts = @blog.posts
      .tagged_with(params[:tag])
      .order('published_at DESC')
      .page(params[:page])
  end

  def categories
    @blog = Blog.find(params[:blog_id])
    @taxonomy = Taxonomy.new(:blogs, [@blog.name, params[:category]])
    @blog_posts = Blog::Post
      .section(@taxonomy)
      .order('published_at DESC')
      .page(params[:page])
    render 'index'
  end
end
