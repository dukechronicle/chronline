class Rss::ArticlesController < ApplicationController

  def index
    @taxonomy = Taxonomy.new("/#{params[:section]}/")
    @articles = Article.includes(:authors, :image)
      .find_by_section(@taxonomy)
      .order('created_at DESC')
      .limit(30)
  end

end
