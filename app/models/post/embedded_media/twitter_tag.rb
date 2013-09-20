require 'oembed'
class Post
  class EmbeddedMedia
    class TwitterTag < ActionView::Base
      include ActionView::Helpers

      def initialize(_embedded_media, url)
        @html = get_html(url)
      end

      def to_html(float: :right)
        @html
      end

      private
      def get_html(url)
        Rails.cache.fetch("twitter:#{url}") do
          res = OEmbed::Providers::Twitter.get(url).html
        end
      end

    end
  end
end
