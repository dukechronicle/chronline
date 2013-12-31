class Post
  class EmbeddedMedia
    class InstagramTag < EmbeddedMedia::Tag
      include ActionView::Helpers

      def initialize(_embedded_media, id)
        @instagram_id = id
      end

      def self.convert_camayak(url)
        id = /\/p\/([a-zA-Z0-9]+)/.match(url)[1]
        "{{Instagram:#{id}}}"
      end

      def to_html(float: :right)
        content_tag :div, nil, class: 'embedded-instagram' do
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
      end

      def to_s
        "{{Instagram:#{@instagram_id}}}"
      end
    end
  end
end
