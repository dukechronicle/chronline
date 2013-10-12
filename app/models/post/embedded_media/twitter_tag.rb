require 'oembed'
class Post
  class EmbeddedMedia
    class TwitterTag < ActionView::Base

      def initialize(_embedded_media, url)
        @html = get_html(url).html_safe
      end

      def self.convert_camayak(url)
        "{{Twitter:#{url}}}"
      end

      def to_html(float: :right)
        content_tag :div, @html, class: 'embedded-tweet'
      end

      private
      def get_html(url)
        Rails.cache.fetch("twitter:#{url}") do
          OEmbed::Providers::Twitter.get(url).html
        end
      end

    end
  end
end
