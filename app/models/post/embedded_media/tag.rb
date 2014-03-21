class Post
  class EmbeddedMedia
    class Tag < ActionView::Base
      Dir[File.join(Rails.root, "app", "models", "post", "embedded_media", "**",
                    "*.rb")].each do |file|
        require_dependency file
      end

      def figure_html(float)
        figure_classes = [
          "embedded-#{float || 'full'}",
          "embedded-#{self.class.tag_name.underscore.dasherize}"
        ]
        content_tag :figure, nil, class: figure_classes do
          concat to_html
          concat content_tag(:figcaption, caption) if caption
        end
      end

      def caption
        nil
      end

      def full_width?
        true
      end

      def self.tag_name
        self.name.demodulize.sub(/Tag$/, '')
      end

      def self.parse_tag(tag, embedded_media)
        match = /{{([a-zA-Z]*):([^\}]*?)}}/.match(tag)
        if match.present? and match[1].eql? tag_name
          self.new(embedded_media, *match[2].split(','))
        else
          nil
        end
      end
    end
  end
end
