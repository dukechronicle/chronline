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

  # Duplicate of site/articles#search
  def search
    @taxonomy = Taxonomy.new
    if params[:article_search].present?
      @articles = Article::Search.new(params[:article_search]).results
    else
      params[:article_search] = {}
      @articles = []
    end
  end

end
