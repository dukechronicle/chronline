class Admin::ArticlesController < Admin::BaseController

  def index
    taxonomy_string = "/#{params[:section]}/" if params[:section]
    @taxonomy = Taxonomy.new(taxonomy_string)

    if params[:date] and not params[:page]
      date = Date.parse(params[:date]) + 1
      params[:page] = find_article_page_for_date(date, @taxonomy)
    end

    @articles = Article.includes(:authors, :image)
      .order('created_at DESC')
      .page(params[:page])
      .find_by_section(@taxonomy)
  end

  def new
    @article = Article.new
  end

  def create
    @article = update_article(Article.new)
    if @article.save
      redirect_to admin_articles_path,
        with: flash[:success] = "Your article was successfully created!"
    else
      render 'new'
    end
  end

  def edit
    @article = Article.find(params[:id])
    if request.path != edit_admin_article_path(@article)
      redirect_to [:edit, :admin, @article], status: :moved_permanently
    end
  end

  def update
    @article = update_article(Article.find(params[:id]))
    if @article.save
      redirect_to admin_root_path
    else
      render 'edit'
    end
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy
    flash[:success] = %Q[Article "#{article.title}" was deleted.]
    redirect_to admin_articles_path
  end

  def search

    if params.has_key? :article_search
      @article_search = Article::Search.new(params[:article_search])
      @article_search.page = params[:page] if params.has_key? :page
      @articles = @article_search.results
    else
      @article_search = Article::Search.new
      @articles = []
    end
  end

  private

  def update_article(article)
    # Last element of taxonomy array may be an empty string
    params[:article][:section].pop if params[:article][:section].last.blank?
    author_names = params[:article].delete(:author_ids).reject {|s| s.blank? }
    article.assign_attributes(params[:article])
    article.authors = Staff.find_or_create_all_by_name(author_names)
    article
  end

  def find_article_page_for_date(date, taxonomy)
    index = Article.find_by_section(taxonomy)
      .where(["created_at > ?", date]).count
    index / Article.per_page + 1
  end

end
