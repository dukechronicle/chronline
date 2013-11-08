class Post
  class EmbeddedMedia
    class QuoteTag < ActionView::Base
      include ActionView::Helpers

      def initialize(_embedded_media, *args)
        @text = args.join(',')
      end

      def to_html(float: :right)
        classes = "embedded-quote embedded-#{float}"
        content_tag(:blockquote, @text, class: classes)
      end
    end
  end
end
