class Api::ArticlesController < Api::BaseController
  before_filter :authenticate_user!, only: [:create, :update, :destroy, :unpublish]

  def index
    taxonomy = Taxonomy.new("/#{params[:section]}/")
    articles = Article
      .includes(:authors, :image)
      .published
      .section(taxonomy)
      .order('published_at DESC')
      .paginate(page: params[:page], per_page: params[:limit])
    respond_with_article articles
  end

  def search
    article_search = Article::Search.new(query: params[:query],
                                         sort: params[:sort],
                                         highlight: false)
    respond_with article_search.results
  end

  def show
    article = Article.find(params[:id])
    respond_with_article article
  end

  def create
    article = Article.new(request.POST)
    if article.save
      respond_with_article article, status: :created,
        location: api_article_url(article)
    else
      render json: article.errors, status: :unprocessable_entity
    end
  end

  def unpublish
    article = Article.find(params[:id])
    article.update_attributes!(published_at: nil)
    respond_with_article article, status: :ok
  end

  def update
    article = Article.find(params[:id])
    if article.update_attributes(request.POST)
      head :no_content
    else
      render json: article.errors, status: :unprocessable_entity
    end
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy
    head :no_content
  end

  private
  def respond_with_article(article, options = {})
    published_url = ->(article) { site_article_url(article, subdomain: :www) }
    options.merge!(
      include: :authors,
      methods: [:author_ids, :thumb_square_s_url],
      except: [:previous_id, :block_bots],
      properties: {
        published_url: published_url,
        section_id: ->(article) { article.section.id },
      },
    )
    respond_with :api, article, options
  end
end
