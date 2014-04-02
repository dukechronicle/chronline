require 'oembed'
class Post
  class EmbeddedMedia
    class SoundcloudTag < EmbeddedMedia::Tag
      def initialize(_embedded_media, soundcloud_id)
        @id = soundcloud_id
      end

      def to_html
        content_tag(
          :iframe,
          nil,
          width: '100%',
          height: 166,
          scrolling: false,
          frameborder: false,
          src: "//w.soundcloud.com/player/?url=http://api.soundcloud.com/tracks/#{@id}&show_artwork=true"
        )
      end

      def to_s
        "{{Soundcloud:#{@id}}}"
      end

      def self.parse_url(url)
        return nil unless url =~ %r[^https?://soundcloud\.com/]
        soundcloud_id = /tracks%2F(\d+)&/.match(
          OEmbed::Providers::SoundCloud.get(url).html)[1]
        self.new(Post::EmbeddedMedia, soundcloud_id)
      end
    end
  end
end
