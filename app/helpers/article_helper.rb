module ArticleHelper

  def permanent_article_url(article)
    slug = article.slugs.last
    if slug.to_param.include?('/')
      site_article_url(slug, subdomain: :www, protocol: 'http')
    else
      site_article_deprecated_url(slug, subdomain: :www, protocol: 'http')
    end
  end

  def mailto_article(article)
    subject = "Duke Chronicle: #{article.title}"
    body = <<EOS


--------------------------------------------------------------------------------

Duke Chronicle

#{article.title}

#{byline(article)} | #{display_date(article)}

#{article.teaser}

Visit #{site_article_url(article)} for the full story.
EOS
    "mailto:?subject=#{subject}&body=#{URI.escape(body)}"
  end

  def search_options(facets)
    facets.map do |facet|
      ["#{facet.name} (#{facet.count})", facet.value]
    end
  end

  def recent_articles_by_author(staff, limit: 5)
    staff.articles.limit(5)
    #staff.articles.limit(limit).order('published_at DESC')
  end

end
