module ArticlesController

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

  protected

  def redirect_article
    # TODO: Don't perform the join in the filter
    @article = Article.includes(:authors, :image => :photographer)
      .find(params[:id])
    expected_path = url_for(controller: controller_path, action: action_name,
                            id: @article, only_path: true)
    if request.path != expected_path
      return redirect_to expected_path, status: :moved_permanently
    end
  end

  def redirect_and_register_view
    redirect_article
    @article.register_view
    @taxonomy = @article.section  # TODO: this shouldn't be here
  end

end
