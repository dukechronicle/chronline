class Site::ArticlesController < ApplicationController
  layout 'site'

  def index
    section = Taxonomy.new("/#{params[:section]}/")
    @articles = Article.find_by_section(section)
  end

  def show
    @article = Article.find(params[:id])
  end

  def print
    @article = Article.find(params[:id])
    render 'print', layout: 'print'
  end
end
