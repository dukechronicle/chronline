class Post
  class EmbeddedMedia
    class SoundcloudTag < ActionView::Base
      include ActionView::Helpers

      OEMBED_URL = "http://soundcloud.com/oembed"

      def initialize(embedded_media, url)
        @embed_html = get_embed_html(embedded_media, url)
      end

      def to_html(float: :right)
        @embed_html
      end

      private
      def get_embed_html(embedded_media, url)
        Rails.cache.fetch("soundcloud:#{url}") do
          embedded_media.get_oembed(OEMBED_URL, url: url)['html']
        end
      end
    end

  end
end
