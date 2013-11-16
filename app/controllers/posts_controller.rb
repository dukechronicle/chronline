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
    @post = admin_scoped { Post.find(params[:id]) }
    expected_path = url_for(
      id: @post,
      controller: controller_path,
      action: action_name,
      only_path: true
    )
    if not social_crawler? and request.path != expected_path
      return redirect_to expected_path, status: :moved_permanently
    end
  end

  def admin_scoped
    if user_signed_in?
      Post.unscoped { yield }
    else
      yield
    end
  end
end
