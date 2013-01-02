class Site::ArticlesController < Site::BaseController

  def index
    @taxonomy = Taxonomy.new("/#{params[:section]}/")
    @articles = Article.includes(:authors, :image)
      .find_by_section(@taxonomy)
  end

  def show
    @article = Article.includes(:authors, :image => :photographer)
      .find(params[:id])
    if request.path != site_article_path(@article)
      return redirect_to [:site, @article], status: :moved_permanently
    end
  end

  def print
    @article = Article.find(params[:id])
    if request.path != print_site_article_path(@article)
      return redirect_to [:print, :site, @article], status: :moved_permanently
    end

    render 'print', layout: 'print'
  end

end
