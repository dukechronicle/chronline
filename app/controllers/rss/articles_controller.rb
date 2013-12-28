class Rss::ArticlesController < ApplicationController

  def index
    @taxonomy = Taxonomy.new("/#{params[:section]}/")
    @posts = Article
      .includes(:authors, :image)
      .section(@taxonomy)
      .order('published_at DESC')
      .limit(30)
    render 'rss/posts/index'
  end

end
