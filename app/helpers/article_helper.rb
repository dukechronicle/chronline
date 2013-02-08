module ArticleHelper

  def display_date(article, format="%B %-d, %Y")
    article.created_at.strftime(format)
  end

  def disqus_options(article)
    {
      production: Rails.env.production?,
      shortname: Settings.disqus.shortname,
      identifier: article.previous_id || "_#{article.id}",
      title: article.title,
      url: site_article_url(article, subdomain: 'www'),
    }.to_json
  end

end
