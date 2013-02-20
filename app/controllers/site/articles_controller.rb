class Site::ArticlesController < Site::BaseController
  before_filter :redirect_and_register_view, only: [:show, :print]
  #caches_action :index, layout: false, expires_in: 1.minute
  caches_action :show,  layout: false
  caches_action :print, layout: false


  def index
    @taxonomy = Taxonomy.new("/#{params[:section]}/")
    begin
      custom_page and return
    rescue ActiveRecord::RecordNotFound
      nil
    end
    @articles = Article.includes(:authors, :image)
      .section(@taxonomy)
      .order('created_at DESC')
      .page(params[:page])
    unless @taxonomy.root?
      @popular = Article.popular(@taxonomy[0].downcase, limit: 5)
    end
  end

  def show
  end

  def print
    render 'print', layout: 'print'
  end

  def search
    if params[:article_search].present?
      @article_search = Article::Search.new(params[:article_search])
      @article_search.page = params[:page] if params.has_key? :page
      @articles = @article_search.results
    else
      params[:article_search] = {}
      @article_search = Article::Search.new
      @articles = []
    end
  end


  private

  def redirect_and_register_view
    @article = Article.find(params[:id])
    expected_path = url_for(controller: 'site/articles', action: action_name,
                            id: @article.slug, only_path: true)
    if request.path != expected_path
      return redirect_to expected_path, status: :moved_permanently
    end
    @article.register_view
    @taxonomy = @article.section  # TODO: this shouldn't be here
  end

end
