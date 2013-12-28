class Api::BlogPostsController < ApplicationController

  def index
    blog = Blog.find(params[:blog_id])
    blog_posts = blog.posts
      .includes(:authors, :image)
      .order('published_at DESC')
      .paginate(page: 1, per_page: params[:limit])
    render json: blog_posts, include: :authors,
      methods: [:square_80x_url, :blog]
  end

end
