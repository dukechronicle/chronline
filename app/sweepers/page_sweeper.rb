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
    fragment = site_root_url(subdomain: :www, protocol: false)
      .gsub(%r[(^/*)|(/*$)], '')  # Remove leading and trailing slashes
    # Frontpage is stored as /index since it's an article index page
    fragment += page.path == '/' ? '/index' : page.path
    expire_fragment fragment
  end

end
