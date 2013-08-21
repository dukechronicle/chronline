class Api::ArticlesController < Api::BaseController
  include ArticleHelper
  before_filter :authenticate_user!, only: [:create, :update, :destroy, :unpublish]

  def index
    taxonomy = Taxonomy.new("/#{params[:section]}/")
    articles = Article.includes(:authors, :image)
      .published
      .section(taxonomy)
      .order('published_at DESC')
      .paginate(page: params[:page], per_page: params[:limit])
    respond_with_article(articles, include: :authors, methods: :thumb_square_s_url)
  end

  def search
    article_search = Article::Search.new(query: params[:query],
                                         sort: params[:sort],
                                         highlight: false)
    respond_with article_search.results
  end

  def show
    article = Article.find(params[:id])
    respond_with_article(article)
  end

  def create
    article = Article.new(request.POST)
    if article.valid?
      if article.save
        respond_with_article(article, status: :created, location: api_articles_url)
      else
        head :internal_server_error
      end
    else
      head :unproccessable_entity
    end
  end

  def unpublish
    article = Article.find(params[:id])
    article.update_attributes(published_at: nil)
    if article.save
      respond_with_article(article, status: :ok)
    else
      head :internal_server_error
    end
  end

  def update
    article = Article.find(params[:id])
    article.update_attributes(request.POST)
    if article.valid?
      if article.save
        head :no_content
      else
        head :internal_server_error
      end
    else
      render json: article.errors, status: :unproccessable_entity
    end
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy
    head :no_content
  end

  private

  def respond_with_article(article, options = {})
    defaults = {
      methods: :author_ids,
      except: :previous_id,
      properties:
        { published_url: ->(article) { site_article_url(article, subdomain: :www) } } }
    options.merge!(defaults) { |k, a, b| Array(a) + Array(b) }
    respond_with(:api, article, options)
  end
end
