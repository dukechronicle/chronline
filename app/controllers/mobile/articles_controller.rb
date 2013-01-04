class Mobile::ArticlesController < Mobile::BaseController

  def index
    @taxonomy = Taxonomy.new("/#{params[:section]}/")
    @articles = Article.includes(:authors, :image)
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

  def search
  end

end
