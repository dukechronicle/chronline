class Post
  class EmbeddedMedia
    class YoutubeTag < ActionView::Base
      include ActionView::Helpers

      def initialize(_embedded_media, youtube_id)
        @youtube_id = youtube_id
      end

      def self.convert_camayak(url)
        youtube_id = /v=([a-zA-Z0-9_-]{11})/.match(url)[1]
        "{{Youtube:#{youtube_id}}}"
      end

      def to_html(float: :right)
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
    end
  end
end
