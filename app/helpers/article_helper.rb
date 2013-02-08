module ArticleHelper

  def byline(article, options={})
    article.authors.map do |author|
      if options[:link]
        link_to author.name, site_staff_path(author)
      else
        author.name
      end
    end.to_sentence.html_safe
  end

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
