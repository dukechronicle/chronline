module PostsController
  def redirect_article
    redirect_post
    @article = @post
  end

  def redirect_blog_post
    redirect_post
    @blog_post = @post
  end

  private
  def redirect_post
    @post = Post.find(params[:id])
    expected_path = url_for(
      id: @post,
      controller: controller_path,
      action: action_name,
      only_path: true
    )
    if not social_crawler? and request.path != expected_path
      return redirect_to expected_path, status: :moved_permanently
    end
    if !@post.published? and !user_signed_in?
      return not_found
    end
  end
end
