class Site::ArticlesController < Site::BaseController
  include ::ArticlesController

  before_filter :redirect_and_register_view, only: [:show, :print]
  caches_action :index, layout: false
  caches_action :show, layout: false
  caches_action :index, layout: false


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
    params[:article_search][:include] = :authors
    super
  end

end
