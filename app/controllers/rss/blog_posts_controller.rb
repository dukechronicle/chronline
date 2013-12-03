class Rss::BlogPostsController < ApplicationController

  def index
    @taxonomy = @blog = Blog.find(params[:blog_id])
    @posts = @blog.posts
      .includes(:authors, :image)
      .order('published_at DESC')
      .limit(30)
    render 'rss/posts/index'
  end

end
