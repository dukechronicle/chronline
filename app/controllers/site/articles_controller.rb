class Site::ArticlesController < Site::BaseController

  def index
    if params[:staff_id]
      @staff = Staff.find(params[:staff_id])
      @articles = @staff.articles.page(params[:page]).order('created_at DESC')
      render 'site/staff/author'
    else
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
      unless @taxonomy.root?
        @popular = Article.popular(@taxonomy[0].downcase, limit: 5)
      end
    end
  end

  def show
    @article = Article.includes(:authors, :image => :photographer)
      .find(params[:id])
    if request.path != site_article_path(@article)
      return redirect_to [:site, @article], status: :moved_permanently
    end
    @taxonomy = @article.section
    @related = @article.related(5)
    @article.register_view
  end

  def print
    @article = Article.find(params[:id])
    if request.path != site_print_article_path(@article)
      return redirect_to site_print_article_path(@article), status: :moved_permanently
    end
    @article.register_view

    render 'print', layout: 'print'
  end

  def search
    if params[:article_search].present?
      @article_search = Article::Search.new(params[:article_search])
      @article_search.page = params[:page] if params.has_key? :page
      @articles = @article_search.results
    else
      params[:article_search] = {}
      @articles = []
    end
  end

end
