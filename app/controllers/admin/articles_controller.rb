class Admin::ArticlesController < Admin::BaseController

  def index
    taxonomy_string = "/#{params[:section]}/" if params[:section]
    @taxonomy = Taxonomy.new(taxonomy_string)

    if params[:date]
      date = Date.parse(params[:date]) + 1
      params[:page] = find_article_page_for_date(date, @taxonomy)
    end

    @article_search = Article::Search.new
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

  private

  def update_article(article)
    # Last element of taxonomy array may be an empty string
    params[:article][:section].pop if params[:article][:section].last.blank?
    author_names = params[:article].delete(:author_ids).reject {|s| s.blank? }
    article.assign_attributes(params[:article])
    article.authors = Author.find_or_create_all_by_name(author_names)
    article
  end

  def find_article_page_for_date(date, taxonomy)
    first_article = Article.where(["created_at <= ?", date])
      .order('created_at DESC').limit(1).first
    index = Article.order('created_at DESC')
      .find_by_section(@taxonomy)
      .index(first_article)
    index = Article.count if index.nil?
    index / Article.per_page + 1
  end

end
