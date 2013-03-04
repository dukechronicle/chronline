class Mobile::ArticlesController < Mobile::BaseController
  include ::ArticlesController

  before_filter :redirect_and_register_view, only: :show


  def index
    @taxonomy = Taxonomy.new("/#{params[:section]}/")
    @articles = Article.includes(:authors, :image)
      .section(@taxonomy)
      .order('created_at DESC')
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
