class Admin::BlogPostsController < Admin::BaseController
  include ::PostsController
  before_filter :redirect_blog_post, only: :edit


  def index
    if params[:blog_id]
      @blog = Blog.find(params[:blog_id])
      @blog_posts = @blog.posts.page(params[:page])
    end
  end

  def new
    @blog_post = Blog::Post.new(blog: params[:blog_id])
  end

  def create
    @blog_post = update_blog_post(Blog::Post.new)
    if @blog_post.save
      redirect_to admin_blog_posts_path(params[:blog_id])
    else
      render 'new'
    end
  end

  def edit
    @blog_post = Blog::Post.find(params[:id])
  end

  def update
    @blog_post = update_blog_post(Blog::Post.find(params[:id]))
    if @blog_post.update_attributes(params[:blog_post])
      redirect_to admin_blog_posts_path(params[:blog_id])
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
    author_names = params[:blog_post].delete(:author_ids).reject { |s| s.blank? }
    blog_post.assign_attributes(params[:blog_post])
    blog_post.authors = Staff.find_or_create_all_by_name(author_names)
    blog_post.assign_attributes(params[:blog_post])
    blog_post
  end

end
