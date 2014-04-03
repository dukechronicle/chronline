class Post
  class EmbeddedMedia
    class QuoteTag < EmbeddedMedia::Tag
      include ActionView::Helpers

      def initialize(_embedded_media, *args)
        @text = args.join(',')
      end

      def to_html
        content_tag(:blockquote, @text)
      end

      def full_width?
        false
      end

      def to_s
        "{{Quote:#{@text}}}"
      end
    end
  end
end
