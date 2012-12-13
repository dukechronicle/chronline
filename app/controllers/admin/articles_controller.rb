class Admin::ArticlesController < ApplicationController
  layout 'admin'

  def index
    @articles = Article.order('created_at DESC')
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
    if request.path != edit_admin_article_path(@article)
      redirect_to [:edit, :admin, @article], status: :moved_permanently
    end
  end

  def update
    # Last element of taxonomy array may be an empty string
    params[:article][:section].pop if params[:article][:section].last.blank?
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      redirect_to admin_root_path
    else
      render 'edit'
    end
  end

  def create
    # Last element of taxonomy array may be an empty string
    params[:article][:section].pop if params[:article][:section].last.blank?
    @article = Article.new(params[:article])
    if @article.save
      redirect_to admin_root_path
    else
      render 'new'
    end
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy
    flash[:success] = "Article \"#{article.title}\" was deleted."
    redirect_to admin_articles_path
  end
end
