class Admin::ArticlesController < Admin::BaseController
  before_filter :persist_search

  def index
    if @article_search.query_set?
      @article_search.run
      @articles = @article_search.results
    else
      @articles = Article.page(params[:page]).order('created_at DESC')
    end
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
    flash[:success] = "Article \"#{article.title}\" was deleted."
    redirect_to admin_articles_path
  end

  def search
  end

  protected

  def persist_search
    @article_search = ArticleSearch.new params[:article_search]
    Rails.logger.debug "asdfasdfas dfasfasdfasdfasfasfasdfasfaasfasfasdfasdfas"
    Rails.logger.debug @article_search.to_yaml
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
