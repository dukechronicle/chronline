class Post
  class EmbeddedMedia
    class InstagramTag < EmbeddedMedia::Tag
      include ActionView::Helpers

      def initialize(_embedded_media, id)
        @instagram_id = id
      end

      def self.parse_url(url)
        return nil unless url =~ %r[^https?://instagram\.com/]
        id = /\/p\/([\w\-]+)/.match(url)[1]
        self.new(Post::EmbeddedMedia, id)
      end

      def to_html
        content_tag(
          :iframe,
          nil,
          frameborder: 0,
          scrolling: 'no',
          allowtransparency: true,
          width: 400,
          height: 464,
          src: "//instagram.com/p/#{@instagram_id}/embed/"
        )
      end

      def to_s
        "{{Instagram:#{@instagram_id}}}"
      end
    end
  end
end
