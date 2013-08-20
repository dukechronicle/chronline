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

end
