###
# This controller is used mainly by Camayak so this class contains some
# necessary hacks.
#
class Api::PostsController < Api::BaseController
  include PostHelper
  before_filter :authenticate_user!, only: [:create, :update, :destroy, :unpublish]

  def index
    posts = Post
      .includes(:authors, :image)
      .order('published_at DESC')
      .paginate(page: params[:page], per_page: params[:limit])
    respond_with_post posts
  end

  def show
    post = Post.find(params[:id])
    respond_with_post post
  end

  def create
    klass =
      if params[:post][:section].try :starts_with?, '/blog/'
        Blog::Post
      else
        Article
      end
    params[:post][:teaser] = params[:post][:teaser]
      .try(:truncate, 200, separator: ' ')
    post = klass.new(params[:post])
    post.authors = [default_staff] if post.authors.blank?
    post.body = Post::EmbeddedMedia.convert_camayak_tags(post.body)
    if post.save
      respond_with_post post, status: :created,
        location: api_article_url(post)
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  def unpublish
    post = Post.unscoped.find(params[:id])
    post.update_attributes!(published_at: nil)
    respond_with_post post, status: :ok
  end

  def update
    post = Post.unscoped.find(params[:id])
    params[:post][:teaser] = params[:post][:teaser]
      .try(:truncate, 200, separator: ' ')
    post.assign_attributes(params[:post])
    post.body = Post::EmbeddedMedia.convert_camayak_tags(post.body)
    if post.save
      head :no_content
    else
      render json: post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.unscoped.find(params[:id])
    post.destroy
    head :no_content
  end

  private
  def respond_with_post(post, options = {})
    published_url = ->(post) { site_post_url(post, subdomain: :www) }
    options.merge!(
      include: :authors,
      methods: [:author_ids, :square_80x_url, :section_id],
      except: [:previous_id, :block_bots],
      properties: {
        published_url: published_url,
      },
    )
    respond_with :api, post, options
  end

  def default_staff
    # HAX: Used by the Chronicle as the default staff writer
    Staff.find_or_create_by_name('Staff Reports')
  end
end
