module PostableHelper

  def display_date(postable, format=nil, options={})
    publish_date = postable.published_at || postable.created_at
    datetime_tag(publish_date, format || 'mmmm d, yyyy', timestamp: !options[:notime])
  end

  def disqus_identifier(postable)
    if postable.is_a? Blog::Post
      # B is for blog post to differentiate identifiers from those of articles
      "B#{postable.id}"
    else
      postable.previous_id || "_#{postable.id}"
    end
  end

  def disqus_options(postable)
    url = if postable.is_a? Blog::Post
            site_blog_post_url(postable.blog, postable, subdomain: :www)
          else
            site_article_url(postable, subdomain: :www)
          end
    {
      production: Rails.env.production?,
      shortname: Settings.disqus.shortname,
      identifier: disqus_identifier(postable),
      title: postable.title,
      url: url,
    }.to_json
  end

  def permanent_post_url(postable)
    if postable.is_a? Blog::Post
      permanent_blog_post_url(postable)
    else
      permanent_article_url(postable)
    end
  end

end
