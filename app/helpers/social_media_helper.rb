module SocialMediaHelper

  def facebook_recommend(url, options={})
    defaults = {
      href: url,
      layout: "button_count",
      width: "130",
      'show-faces' => "false",
      share: "false",
      action: "recommend",
      colorscheme: "light",
    }
    content_tag :div, nil, class: 'fb-like', data: defaults.merge(options)
  end

  def twitter_share(url, options={})
    defaults = {
      via: "dukechronicle",
      url: url,
    }
    link_to(
      "Tweet",
      "https://twitter.com/share",
      class: 'twitter-share-button',
      data: defaults.merge(options)
    )
  end

  def google_plusone(url, options={})
    defaults = {
      size: "medium",
      annotation: "bubble",
      href: url
    }
    content_tag :div, nil, class: 'g-plusone', data: defaults.merge(options)
  end

  def coinbase_tip(url, options={})
    defaults = {
      'content-location' => url,
      'href' => 'https://www.coinbase.com/tip_buttons/show_tip',
      'to-user-id' => ENV['COINBASE_USER_ID']
    }
    content_tag :div, nil, class: 'cb-tip-button', data: defaults.merge(options)
  end

end
