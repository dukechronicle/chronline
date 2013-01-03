class Api::ArticlesController < ApplicationController

  def index
    taxonomy = Taxonomy.new("/#{params[:section]}/")
    articles = Article.find_by_section(taxonomy)
    render json: articles
  end

end
