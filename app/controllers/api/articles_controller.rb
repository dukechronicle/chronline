class Api::ArticlesController < ApplicationController

  def index
    taxonomy = Taxonomy.new("/#{params[:section]}/")
    articles = Article.includes(:authors, :image)
      .find_by_section(taxonomy)
      .paginate(page: 1, per_page: params[:limit])
    render json: articles, include: :authors, methods: :thumb_square_s_url
  end

end
