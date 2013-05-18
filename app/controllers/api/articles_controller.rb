class Api::ArticlesController < ApplicationController

  def index
    taxonomy = Taxonomy.new("/#{params[:section]}/")
    articles = Article.includes(:authors, :image)
      .published
      .section(taxonomy)
      .order('published_at DESC')
      .paginate(page: 1, per_page: params[:limit])
    render json: articles, include: :authors, methods: :thumb_square_s_url
  end

  def search
    article_search = Article::Search.new(query: params[:query],
                                         sort: params[:sort],
                                         highlight: false)
    render json: article_search.results
  end

end
