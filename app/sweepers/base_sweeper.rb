module BaseSweeper

  def expire_article_cache(article)
    expire_action controller: 'site/articles', action: :index, subdomain: :www
    article.section.parents.each do |taxonomy|
      expire_action(controller: 'site/articles', subdomain: :www,
                    action: :index, section: taxonomy.to_s[1...-1])
    end
    expire_action id: article, controller: 'site/articles', action: :show, subdomain: :www
    expire_action id: article, controller: 'site/articles', action: :print, subdomain: :www
  end

end
