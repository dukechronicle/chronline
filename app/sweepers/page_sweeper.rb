class PageSweeper < ActionController::Caching::Sweeper
  observe Page

  def after_create(page)
    expire_cache_for(page)
  end

  def after_update(page)
    expire_cache_for(page)
  end

  def after_destroy(page)
    expire_cache_for(page)
  end

  private

  def expire_cache_for(page)
    section = page.path.split "/"
    section = section[section.length-1]
    expire_action controller: 'site/articles', action: :index, subdomain: :www, section: section
  end

end
