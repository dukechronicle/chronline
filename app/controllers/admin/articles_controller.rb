class Admin::ArticlesController < Admin::BaseController
  include ::PostsController
  before_filter :redirect_article, only: :edit

  def index
    taxonomy_string = "/#{params[:section]}/" if params[:section]
    @taxonomy = Taxonomy.new(:sections, taxonomy_string)

    if params[:date] and not params[:page]
      date = Date.parse(params[:date]) + 1
      params[:page] = find_article_page_for_date(date, @taxonomy)
    end

    @articles = Article.unscoped do  # Include unpublished articles
      Article
        .includes(:authors, :image)
        .section(@taxonomy)
        .order('published_at IS NOT NULL, published_at DESC')
        .page(params[:page])
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = update_article(Article.new)
    if @article.save
      redirect_to site_article_url(@article, subdomain: 'www')
    else
      render 'new'
    end
  end

  def edit
  end

  def publish
    @article = Article.unscoped.find(params[:id])
    @article.published_at = DateTime.now
    if @article.save
      flash[:sucess] = %Q[Article "#{@article.title} was published."]
    else
      flash[:notice] = %Q[Article "#{@article.title} was not published."]
    end
    redirect_to :back
  end

  def update
    @article = update_article(Article.unscoped.find(params[:id]))
    if @article.save
      redirect_to site_article_url(@article, subdomain: 'www')
    else
      render 'edit'
    end
  end

  def destroy
    article = Article.unscoped.find(params[:id])
    article.destroy
    flash[:success] = %Q[Article "#{article.title}" was deleted.]
    redirect_to admin_articles_path
  end

  private
  def update_article(article)
    update_params = article_params
    author_names = update_params.delete(:author_ids).reject(&:blank?)
    article.assign_attributes(update_params)
    article.authors = Staff.find_or_create_all_by_name(author_names)
    article
  end

  def find_article_page_for_date(date, taxonomy)
    index = Article.section(taxonomy)
      .where(["published_at > ?", date]).count
    index / Article.per_page + 1
  end

  def article_params
    params.require(:article).permit(
      :body, :embed_url, :subtitle, author_ids: []
    )
  end
end
