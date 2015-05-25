class Post
  class EmbeddedMedia
    class VimeoTag < EmbeddedMedia::Tag

      def initialize(_embedded_media, vimeo_id)
        @vimeo_id = vimeo_id
      end

      def self.parse_url(url)
        return nil unless url =~ %r[^https?://(?:www\.)?vimeo\.com/]
        # https://stackoverflow.com/questions/13286785/get-video-id-from-vimeo-url/13286930#13286930
        vimeo_id = /^.*(?:vimeo.com)\/(?:channels\/|channels\/\w+\/|groups\/[^\/]*\/videos\/|video\/|album\/\d+\/video\/|)(\d+)(?:$|\/|\?)/.match(url)[1]
        self.new(Post::EmbeddedMedia, vimeo_id)
      end

      def to_html
        content_tag(
          :iframe,
          nil,
          frameborder: 0,
          allowfullscreen: true,
          width: 606,
          height: 455,
          src: "//player.vimeo.com/video/#{@vimeo_id}",
          allowfullscreen: ''
        )
      end

      def to_s
        "{{Vimeo:#{@vimeo_id}}}"
      end
    end
  end
end
