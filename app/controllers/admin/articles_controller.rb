class Admin::ArticlesController < ApplicationController
  layout 'admin'

  def new
    @article = Article.new
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
end
