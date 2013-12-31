class Post
  class EmbeddedMedia
    class Tag < ActionView::Base
      def self.parse_tag(tag)
        match = /{{([a-zA-Z]*):([^\}]*?)}}/.match(tag)
        if match.present? and match[1].eql? self.name.demodulize.sub(/Tag$/, '')
          self.new(Post::EmbeddedMedia, match[2])
        else
          nil
        end
      end
    end
  end
end
