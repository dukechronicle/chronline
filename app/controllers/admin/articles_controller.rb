class Admin::ArticlesController < Admin::BaseController

  def index
    if params.has_key? :article_search
      @article_search = Article::Search.new params[:article_search]
      if @article_search.valid?
        @articles = @article_search.results
        Rails.logger.debug(@articles.to_yaml)
        flash[:error] = "No results found!" if @articles.empty?
      else
        @articles = Article.page(params[:page]).order('created_at DESC')
      end
      render and return
    end

    @article_search = Article::Search.new
    @articles = Article.page(params[:page]).order('created_at DESC')
    #end
  end

  def new
    @article = Article.new
  end

  def create
    @article = update_article(Article.new)
    if @article.save
      redirect_to admin_root_path
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
      @article_search = Article::Search.new params[:article_search]
      @article_search.valid?
      @articles = @article_search.results
      render 'index' and return
    else
      @article_search = Article::Search.new
    end
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
end
