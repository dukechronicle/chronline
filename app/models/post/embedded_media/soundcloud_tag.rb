require 'oembed'
class Post
  class EmbeddedMedia
    class SoundcloudTag < ActionView::Base

      def initialize(_embedded_media, url)
        @html = get_html(url)
      end

      def to_html(float: :right)
        @html
      end

      private
      def get_html(url)
        Rails.cache.fetch("soundcloud:#{url}") do
          OEmbed::Providers::SoundCloud.get(url).html
        end
      end

    end
  end
end
