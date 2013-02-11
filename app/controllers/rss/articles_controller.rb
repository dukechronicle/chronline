class Rss::ArticlesController < ApplicationController

  def index
    @taxonomy = Taxonomy.new("/#{params[:section]}/")
    @articles = Article.includes(:authors, :image)
      .section(@taxonomy)
      .order('created_at DESC')
      .limit(30)
    render 'index'
  end

end
