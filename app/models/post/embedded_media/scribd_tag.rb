class Post
  class EmbeddedMedia
    class ScribdTag < EmbeddedMedia::Tag
      def initialize(_embedded_media, id)
        @id = id
      end

      def self.parse_url(url)
        return nil unless url =~ %r[^https?://www.scribd\.com/]
        scribd_id = /doc\/(\d+)\//.match(url)[1]
        self.new(Post::EmbeddedMedia, scribd_id)
      end

      def to_html
        content_tag(
          :iframe,
          nil,
          width: '100%',
          class: 'scribd_iframe_embed',
          height: 600,
          frameborder: 0,
          src: "//www.scribd.com/embeds/#{@id}/content"
        ) +
        javascript_tag(
          "(function() { var scribd = document.createElement(\"script\"); scribd.type = \"text/javascript\"; scribd.async = true; scribd.src = \"//www.scribd.com/javascripts/embed_code/inject.js\"; var s = document.getElementsByTagName(\"script\")[0]; s.parentNode.insertBefore(scribd, s); })()"
        )
      end

      def to_s
        "{{Scribd:#{@id}}}"
      end
    end
  end
end
