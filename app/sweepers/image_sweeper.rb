class ImageSweeper < ActionController::Caching::Sweeper
  include ::BaseSweeper
  observe Image

  def after_create(image)
    expire_cache_for(image)
  end

  def after_update(image)
    expire_cache_for(image)
  end

  def after_destroy(image)
    expire_cache_for(image)
  end

  private
  def expire_cache_for(image)
    image.articles.each do |article|
      expire_article_cache article
    end
  end
end
