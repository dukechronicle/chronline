module ArticleHelper

  def byline(article, options={})
    authors = article.authors.sort_by(&:last_name)
    authors.map do |author|
      if options[:link]
        link_to author.name, articles_site_staff_path(author)
      else
        author.name
      end
    end.to_sentence.html_safe
  end

  def disqus_identifier(model)
    if model.is_a? Blog::Post
      # B is for blog post to differentiate identifiers from those of articles
      "B#{model.id}"
    else
      model.previous_id || "_#{model.id}"
    end
  end

  def disqus_options(model)
    url = if model.is_a? Blog::Post
            site_blog_post_url(model.blog, model, subdomain: :www)
          else
            site_article_url(model, subdomain: :www)
          end
    {
      production: Rails.env.production?,
      shortname: Settings.disqus.shortname,
      identifier: disqus_identifier(model),
      title: model.title,
      url: url,
    }.to_json
  end

  def permanent_article_url(article)
    slug = @article.slugs.last
    if slug.to_param.include?('/')
      site_article_url(slug, subdomain: :www)
    else
      site_article_deprecated_url(slug, subdomain: :www)
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
      ["#{facet[:value]} (#{facet[:count]})", facet[:lookup]]
    end
  end

end
