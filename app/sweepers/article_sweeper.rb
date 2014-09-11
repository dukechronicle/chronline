class ArticleSweeper < ActionController::Caching::Sweeper
  include ::BaseSweeper
  observe Article


  def after_create(article)
    expire_article_cache(article)
  end

  def after_update(article)
    expire_article_cache(article)
  end

  def after_destroy(article)
    expire_article_cache(article)
  end

end
