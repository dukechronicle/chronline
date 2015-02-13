class Post
  class EmbeddedMedia
    class VineTag < EmbeddedMedia::Tag
      def initialize(_embedded_media, vine_id)
        @id = vine_id
      end

      def self.parse_url(url)
        return nil unless url =~ %r[^https?://vine\.co/]
        vine_id = /v\/([0-9A-Za-z]+)/.match(url)[1]
        self.new(Post::EmbeddedMedia, vine_id)
      end

      def to_html
        content_tag(
          :iframe,
          nil,
          width: 600,
          height: 680,
          frameborder: 0,
          src: "//vine.co/v/#{@id}/embed/simple"
        ) +
        content_tag(
          :script,
          nil,
          src: "//platform.vine.co/static/scripts/embed.js"
        )
      end

      def to_s
        "{{Vine:#{@id}}}"
      end
    end
  end
end
