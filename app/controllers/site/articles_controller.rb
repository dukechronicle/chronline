class Site::ArticlesController < Site::BaseController

  def index
    @taxonomy = Taxonomy.new("/#{params[:section]}/")
    begin
      custom_page and return
    rescue ActiveRecord::RecordNotFound
      nil
    end
    @articles = Article.includes(:authors, :image)
      .order('created_at DESC')
      .page(params[:page])
      .find_by_section(@taxonomy)
    @popular = Article.popular(@taxonomy[0].downcase, limit: 5)
  end

  def show
    @article = Article.includes(:authors, :image => :photographer)
      .find(params[:id])
    if request.path != site_article_path(@article)
      return redirect_to [:site, @article], status: :moved_permanently
    end
    @article.register_view
  end

  def print
    @article = Article.find(params[:id])
    if request.path != print_site_article_path(@article)
      return redirect_to [:print, :site, @article], status: :moved_permanently
    end
    @article.register_view

    render 'print', layout: 'print'
  end

  def search
    if params.has_key?(:article_search)
      @article_search = Article::Search.new(params[:article_search])
      @article_search.valid?
      @articles = @article_search.results
    else
      @articles = []
      @article_search = Article::Search.new
    end
  end

end
