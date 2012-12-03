class Admin::ArticlesController < ApplicationController
  layout 'admin'

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])
    if @article.save
      redirect_to admin_root_path
    else
      render 'new'
    end
  end
end
