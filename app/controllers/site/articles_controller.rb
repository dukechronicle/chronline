class Site::ArticlesController < ApplicationController
  layout 'site'

  def index
    @taxonomy = Taxonomy.new("/#{params[:section]}/")
    @articles = Article.find_by_section(@taxonomy)
  end

  def show
    @article = Article.find(params[:id])
  end

  def print
    @article = Article.find(params[:id])
    render 'print', layout: 'print'
  end
end
