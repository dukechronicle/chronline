class Mobile::ArticlesController < Mobile::BaseController
  include ::ArticlesController

  before_filter :redirect_and_register_view, only: :show


  def index
    begin
      @taxonomy = Taxonomy.new("/#{params[:section]}/")
    rescue Taxonomy::InvalidTaxonomyError
      return not_found
    end

    @articles = Article.includes(:authors, :image)
      .published
      .section(@taxonomy)
      .order('published_at DESC')
      .limit(7)
  end

  def show
  end

  def search
    params[:article_search] ||= {}
    params[:article_search][:include] = [:authors, :image]
    super
  end

end
