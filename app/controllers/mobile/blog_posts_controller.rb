class Mobile::BlogPostsController < Mobile::BaseController

  def index
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])
      @blog_posts = @blog.posts
        .includes(:authors, :image)
        .page(params[:page])
    else
      render 'mobile/blogs/index'
    end
  end

  def show
    @blog_post = Blog::Post.includes(:authors, :image).find(params[:id])
    @blog = @blog_post.blog
  end

end
