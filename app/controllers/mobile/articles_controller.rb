class Mobile::ArticlesController < Mobile::BaseController
  include ::PostsController
  before_filter :redirect_article, only: :show


  def index
    begin
      @taxonomy = Taxonomy.new("/#{params[:section]}/")
    rescue Taxonomy::InvalidTaxonomyError
      return not_found
    end

    @articles = Article.includes(:authors, :image)
      .section(@taxonomy)
      .order('published_at DESC')
      .limit(7)
  end

  def show
    @article = Article
      .includes(:authors, :slugs, image: :photographer)
      .find(@article)
    @article.register_view
  end

  def search
    params[:article_search] ||= {}
    params[:article_search][:include] = [:authors, :image]
    super
  end
end
