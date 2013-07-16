module SocialMediaHelper

  def facebook_recommend_post(postable, options={})
    defaults = {
      href: site_post_url(postable),
      send: "false",
      layout: "button_count",
      width: "130",
      'show-faces' => "false",
      font: "lucida grande",
      action: "recommend"
    }
    content_tag :div, nil, class: 'fb-like', data: defaults.merge(options)
  end

  def twitter_share_post(postable, options={})
    defaults = {
      via: "dukechronicle",
      url: permanent_post_url(postable)
    }
    link_to("Tweet", "https://twitter.com/share", class: 'twitter-share-button',
            data: defaults.merge(options))
  end

  def google_plusone_post(postable, options={})
    defaults = {
      size: "medium",
      annotation: "bubble",
      href: permanent_post_url(postable)
    }
    content_tag :div, nil, class: 'g-plusone', data: defaults.merge(options)
  end

end
