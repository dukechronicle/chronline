class Api::BlogPostsController < ApplicationController

  def index
    blog = Blog.find(params[:blog_id])
    blog_posts = Blog::Post
      .published
      .includes(:author, :image)
      .where(blog: blog.id)
      .order('published_at DESC')
      .paginate(page: 1, per_page: params[:limit])
    render json: blog_posts, include: :author, methods: :square_80x_url
  end

end
