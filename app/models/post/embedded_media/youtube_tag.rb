class Post
  class EmbeddedMedia
    class YoutubeTag < EmbeddedMedia::Tag
      include ActionView::Helpers

      def initialize(_embedded_media, youtube_id)
        @youtube_id = youtube_id
      end

      def self.parse_url(url)
        return nil unless url =~ %r[^https?://www\.youtube\.com/]
        youtube_id = /v=([a-zA-Z0-9_-]{11})/.match(url)[1]
        self.new(Post::EmbeddedMedia, youtube_id)
      end

      def to_html
        content_tag(
          :iframe,
          nil,
          frameborder: 0,
          allowfullscreen: true,
          width: 606,
          height: 455,
          src: "//www.youtube.com/embed/#{@youtube_id}?rel=0"
        )
      end

      def to_s
        "{{Youtube:#{@youtube_id}}}"
      end
    end
  end
end
