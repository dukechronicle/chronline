module SocialMediaHelper

  def facebook_recommend_post(post, options={})
    defaults = {
      href: permanent_post_url(post),
      layout: "button_count",
      width: "130",
      'show-faces' => "false",
      share: "false",
      action: "recommend",
      colorscheme: "light",
    }
    content_tag :div, nil, class: 'fb-like', data: defaults.merge(options)
  end

  def twitter_share_post(post, options={})
    defaults = {
      via: "dukechronicle",
      url: permanent_post_url(post)
    }
    link_to(
      "Tweet",
      "https://twitter.com/share",
      class: 'twitter-share-button',
      data: defaults.merge(options)
    )
  end

  def google_plusone_post(post, options={})
    defaults = {
      size: "medium",
      annotation: "bubble",
      href: permanent_post_url(post)
    }
    content_tag :div, nil, class: 'g-plusone', data: defaults.merge(options)
  end

end
