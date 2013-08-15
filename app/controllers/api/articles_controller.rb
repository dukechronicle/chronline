class Api::ArticlesController < Api::BaseController
  before_filter :authenticate_user!, only: [:create, :update, :destroy, :unpublish]

  def index
    taxonomy = Taxonomy.new("/#{params[:section]}/")
    articles = Article.includes(:authors, :image)
      .published
      .section(taxonomy)
      .order('published_at DESC')
      .paginate(page: params[:page], per_page: params[:limit])
    respond_with articles, include: :authors, methods: :thumb_square_s_url
  end

  def search
    article_search = Article::Search.new(query: params[:query],
                                         sort: params[:sort],
                                         highlight: false)
    respond_with article_search.results
  end

  def show
    article = Article.find(params[:id])
    respond_with(article, methods: :author_ids)
  end

  def create
    article = Article.new(request.POST)
    if article.valid?
      if article.save
        respond_with(
          article, status: :created, location: api_articles_url,
          except: :previous_id, methods: :author_ids)
      else
        head :internal_server_error
      end
    else
      head :bad_request
    end
  end

  def unpublish
    article = Article.find(params[:id])
    article.update_attributes(published_at: nil)
    if article.save
      respond_with(:api, article, status: :ok, except: :previous_id)
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
      render json: article.errors, status: :bad_request
    end
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy
    head :no_content
  end

end
