class Admin::BlogPostsController < Admin::BaseController
  include ::PostsController
  before_filter :redirect_blog_post, only: :edit

  def index
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])
      @blog_posts = Blog::Post.unscoped do  # Allow unpublished articles
        @blog.posts
          .order('published_at IS NOT NULL, published_at DESC')
          .paginate(page: params[:page], per_page: 25)
      end
    end
  end

  def new
    @blog_post = Blog::Post.new(blog: params[:blog_id])
  end

  def create
    @blog_post = update_blog_post(Blog::Post.new)
    if @blog_post.save
      redirect_to site_blog_post_url(
        @blog_post.blog, @blog_post, subdomain: 'www')
    else
      render 'new'
    end
  end

  def edit
    @blog_post = Blog::Post.find(params[:id])
  end

  def update
    @blog_post = update_blog_post(Blog::Post.find(params[:id]))
    if @blog_post.save
      redirect_to site_blog_post_url(
        @blog_post.blog, @blog_post, subdomain: 'www')
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

  private
  def update_blog_post(blog_post)
    update_params = blog_post_params
    author_names = update_params.delete(:author_ids).reject(&:blank?)
    blog_post.assign_attributes(update_params)
    blog_post.authors = Staff.find_or_create_all_by_name(author_names)
    blog_post
  end

  def blog_post_params
    params.require(:blog_post).permit(
      :blog_id, :body, :embed_url, :subtitle, :tag_list, author_ids: []
    )
  end
end
