require 'oembed'
class Post
  class EmbeddedMedia
    class SoundcloudTag < ActionView::Base

      def initialize(_embedded_media, soundcloud_id)
        @html = get_html(soundcloud_id)
      end

      def to_html(float: :right)
        @html
      end

      def self.convert_camayak(url)
        soundcloud_id = /tracks%2F(\d+)&/.match(
          OEmbed::Providers::SoundCloud.get(url).html)[1]
        "{{Soundcloud:#{soundcloud_id}}}"
      end

      private
      def get_html(soundcloud_id)
        content_tag(
          :iframe,
          nil,
          width: '100%',
          height: 166,
          scrolling: false,
          frameborder: false,
          src: "//w.soundcloud.com/player/?url=http://api.soundcloud.com/tracks/#{soundcloud_id}&show_artwork=true"
        )
      end
    end
  end
end
