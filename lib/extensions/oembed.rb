require 'oembed'
module OEmbed
  class Providers
    Twitter = OEmbed::Provider.new("https://api.twitter.com/1/statuses/oembed.json")
    Twitter << "https://twitter.com/*/status/*"
    Twitter << "http://twitter.com/*/status/*"
  end
end
