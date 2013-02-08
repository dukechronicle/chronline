class Mobile::ArticlesController < Mobile::BaseController

  def index
    @taxonomy = Taxonomy.new("/#{params[:section]}/")
    @articles = Article.includes(:authors, :image)
      .order('created_at DESC')
      .find_by_section(@taxonomy).limit(7)
  end

  def show
    @article = Article.includes(:authors, :image => :photographer)
      .find(params[:id])
    if request.path != mobile_article_path(@article)
      return redirect_to [:mobile, @article], status: :moved_permanently
    end
    @article.register_view
  end

  # Almost a duplicate of site/articles#search (highlighting, but should be
  # moved to a decorator)
  def search
    @taxonomy = Taxonomy.new
    if params[:article_search].present?
      @article_search = Article::Search.new(params[:article_search])
      @articles = @article_search.results highlight: true
    else
      params[:article_search] = {}
      @articles = []
    end
  end

end
