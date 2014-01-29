class Post
  class EmbeddedMedia
    class TwitterTag < EmbeddedMedia::Tag

      def initialize(_embedded_media, url)
        @url = url
      end

      def self.parse_url(url)
        return nil unless url =~ %r[^https?://twitter\.com/]
        self.new(Post::EmbeddedMedia, url)
      end

      def to_html(float: :right)
        content_tag :div, nil, class: 'embedded-tweet' do
          content_tag(:blockquote, nil, class: 'twitter-tweet') do
            content_tag(:a, nil, href: @url)
          end
        end
      end

      def to_s
        "{{Twitter:#{@url}}}"
      end
    end
  end
end
