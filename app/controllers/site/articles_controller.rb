class Site::ArticlesController < ApplicationController
  layout 'site'

  def show
    @article = Article.find(params[:id])
  end
end
