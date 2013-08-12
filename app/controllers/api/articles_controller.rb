class Api::ArticlesController < Api::BaseController

  def index
    taxonomy = Taxonomy.new("/#{params[:section]}/")
    articles = Article.includes(:authors, :image)
      .published
      .section(taxonomy)
      .order('published_at DESC')
      .paginate(page: 1, per_page: params[:limit])
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
    respond_with article
  end

  def create
    article = Article.new(params[:article])
    if article.valid?
      if article.save
        respond_with article, status: :created, location: api_articles_url
      else
        head :internal_server_error
      end
    else
      head :bad_request
    end
  end

  def update
    article = Article.find(params[:id])
    article.update_attributes(params[:article])
    if article.valid?
      if article.save
        head :no_content
      else
        head :internal_server_error
      end
    else
        head :bad_request
    end
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy
  end

end
