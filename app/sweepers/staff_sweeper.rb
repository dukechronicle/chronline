class StaffSweeper < ActionController::Caching::Sweeper
  include ::BaseSweeper
  observe Staff

  def after_create(staff)
    expire_cache_for(staff)
  end

  def after_update(staff)
    expire_cache_for(staff)
  end

  def after_destroy(staff)
    expire_cache_for(staff)
  end


  private

  def expire_cache_for(staff)
    articles = staff.images.map(&:articles).flatten

    articles.concat staff.articles

    articles.each do |article|
      expire_all article
    end
  end

end
