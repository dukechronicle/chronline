module ArticlesController

  def redirect_article
    @article = Article.find(params[:id])
    expected_path = url_for(
      id: @article,
      controller: controller_path,
      action: action_name,
      only_path: true
    )
    if not social_crawler? and request.path != expected_path
      return redirect_to expected_path, status: :moved_permanently
    end
  end

  def search
    if params[:article_search]
      @article_search = Article::Search.new(params[:article_search])
      @article_search.page = params[:page] if params.has_key?(:page)
      @articles = @article_search.results
    else
      @article_search = Article::Search.new
      @articles = []
    end
  end
end
