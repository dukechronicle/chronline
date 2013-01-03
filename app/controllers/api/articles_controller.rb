class Api::ArticlesController < ApplicationController

  def index
    taxonomy = Taxonomy.new("/#{params[:section]}/")
    articles = Article.includes(:authors, :image).
      find_by_section(taxonomy)
    render json: articles, include: :authors, methods: :thumb_square_s_url
  end

end
