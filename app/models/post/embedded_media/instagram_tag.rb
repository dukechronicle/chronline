class Post
  class EmbeddedMedia
    class InstagramTag < ActionView::Base
      include ActionView::Helpers

      def initialize(_embedded_media, url)
        @instagram_id = /\/p\/([a-zA-Z0-9]+)/.match(url)[1]
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
    end
  end
end
