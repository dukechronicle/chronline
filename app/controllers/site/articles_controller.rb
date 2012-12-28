class Site::ArticlesController < ApplicationController
  layout 'site'

  def index
  end

  def show
    @article = Article.find(params[:id])
  end

  def print
    @article = Article.find(params[:id])
    render 'print', layout: 'print'
  end
end
