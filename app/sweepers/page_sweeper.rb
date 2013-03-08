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
    frontpage = ''
    if page.path[0..5] == '/'
      frontpage = 'index'
    end
    expire_fragment site_root_url(subdomain: :www)[7..-1] + page.path[1..-1] + frontpage
  end

end
