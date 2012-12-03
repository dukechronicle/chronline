class Admin::ArticlesController < ApplicationController
  layout 'admin'

  def new
    @article = Article.new
  end
end
