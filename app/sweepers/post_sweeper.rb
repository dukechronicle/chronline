class PostSweeper < ActionController::Caching::Sweeper
  include ::BaseSweeper
  observe Post

  def after_create(post)
    expire_obj_cache_with_taxonomies(post)
  end

  def after_update(post)
    expire_obj_cache_with_taxonomies(post)
  end

  def after_destroy(post)
    expire_obj_cache_with_taxonomies(post)
  end
end
