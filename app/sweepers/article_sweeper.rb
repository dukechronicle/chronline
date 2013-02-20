class ArticleSweeper < ActionController::Caching::Sweeper
  observe Article


  def after_create(article)
    expire_cache_for(article)
  end

  def after_update(article)
    expire_cache_for(article)
  end

  def after_destroy(article)
    expire_cache_for(article)
  end


  private

  def expire_cache_for(article)
    # expire_action controller: 'site/articles', action: :index, subdomain: :www
    # article.section.parents.each do |taxonomy|
    #   expire_action(controller: 'site/articles', subdomain: :www,
    #                 action: :index, section: taxonomy.to_s[1...-1])
    # end
    expire_action controller: 'site/articles', action: :show, subdomain: :www
    expire_action controller: 'site/articles', action: :print, subdomain: :www
  end

end
