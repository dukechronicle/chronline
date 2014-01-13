class Post
  class EmbeddedMedia
    class Tag < ActionView::Base
      Dir[File.join(Rails.root, "app", "models", "post", "embedded_media", "**",
                    "*.rb")].each do |file|
        require_dependency file
      end

      def self.parse_tag(tag, embedded_media)
        match = /{{([a-zA-Z]*):([^\}]*?)}}/.match(tag)
        if match.present? and match[1].eql? self.name.demodulize.sub(/Tag$/, '')
          self.new(embedded_media, *match[2].split(','))
        else
          nil
        end
      end
    end
  end
end
