module PostHelper

  def display_date(post, format = nil, notime: true)
    publish_date = post.published_at || post.created_at
    datetime_tag(publish_date, format || 'mmmm d, yyyy', timestamp: !notime)
  end

  def disqus_identifier(post)
    if post.is_a? Blog::Post
      # B is for blog post to differentiate identifiers from those of articles
      "B#{post.id}"
    else
      post.previous_id || "_#{post.id}"
    end
  end

  def disqus_options(post)
    {
      production: Rails.env.production?,
      shortname: Settings.disqus.shortname,
      identifier: disqus_identifier(post),
      title: post.title,
      url: permanent_post_url(post),
    }.to_json
  end

  def site_post_url(post)
    if post.is_a? Blog::Post
      site_blog_post_url(
        post.blog, post, subdomain: :www, protocol: 'http')
    else
      site_article_url(post, subdomain: :www, protocol: 'http')
    end
  end

  def permanent_post_url(post)
    if post.is_a? Blog::Post
      permanent_blog_post_url(post)
    else
      permanent_article_url(post)
    end
  end

end
