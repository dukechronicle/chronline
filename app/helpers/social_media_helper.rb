module SocialMediaHelper

  def facebook_recommend_article(article, options={})
    defaults = {
      href: site_article_url(article, protocol: 'http'),
      send: "false",
      layout: "button_count",
      width: "130",
      'show-faces' => "false",
      font: "lucida grande",
      action: "recommend"
    }
    content_tag :div, nil, class: 'fb-like', data: defaults.merge(options)
  end

  def twitter_share_article(article, options={})
    defaults = {
      via: "dukechronicle",
      url: permanent_article_url(article)
    }
    link_to("Tweet", "https://twitter.com/share", class: 'twitter-share-button',
            data: defaults.merge(options))
  end

  def google_plusone_article(article, options={})
    defaults = {
      size: "medium",
      annotation: "bubble",
      href: permanent_article_url(article)
    }
    content_tag :div, nil, class: 'g-plusone', data: defaults.merge(options)
  end

end
