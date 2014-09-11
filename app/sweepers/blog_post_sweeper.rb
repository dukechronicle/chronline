class BlogPostSweeper < ActionController::Caching::Sweeper
  include ::BaseSweeper
  observe Blog::Post

  def after_create(post)
    expire_blog_post_cache(post)
  end

  def after_update(post)
    expire_blog_post_cache(post)
  end

  def after_destroy(post)
    expire_blog_post_cache(post)
  end
end
