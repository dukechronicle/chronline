class Beta::ArticlesController < Beta::BaseController
  include ::PostsController
  before_filter :redirect_article, only: [:show, :print]


  def index
    begin
      @taxonomy = Taxonomy.new(:sections, "/#{params[:section]}/")
    rescue Taxonomy::InvalidTaxonomyError
      return not_found
    end

    begin
      custom_page and return
    rescue ActiveRecord::RecordNotFound
      nil
    end

    @articles = Article
      .includes(:authors, :image)
      .section(@taxonomy)
      .order('published_at DESC')
      .page(params[:page])
    unless @taxonomy.root?
      @popular = Article.popular(@taxonomy[0].downcase, limit: 5)
    end
  end

  def show
    @article.register_view
    @taxonomy = @article.section
  end

  def print
    @article = Article.includes(:authors, image: :photographer).find(@article)
    @article.register_view
    render 'print', layout: 'print'
  end

end
