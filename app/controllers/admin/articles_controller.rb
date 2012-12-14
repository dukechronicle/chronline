class Admin::ArticlesController < ApplicationController
  layout 'admin'

  def index
    @articles = Article.page(params[:page]).order('created_at DESC')
  end

  def new
    @article = Article.new
  end

  def create
    @article = update_article(Article.new)
    @article.authors = Author.find_or_create_all_by_name(author_names)
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
