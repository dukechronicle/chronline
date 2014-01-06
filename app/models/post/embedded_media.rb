require 'json'
class Post
  class EmbeddedMediaException < StandardError; end
  class EmbeddedMedia

    def initialize(body)
      @body = body
      @queries = {}
    end

    def self.convert_camayak_tags(body)
      document = Nokogiri::HTML::DocumentFragment.parse(body)
      document.css('.oembed').each do |camayak_tag|
        url = camayak_tag.attr('data-camayak-embed-url')
        provider =
          case url
          when %r[^https?://www\.youtube\.com/]
            'Youtube'
          when %r[^https?://twitter\.com/]
            'Twitter'
          when %r[^https?://soundcloud\.com/]
            'Soundcloud'
          when %r[^https?://instagram\.com/]
            'Instagram'
          end
        unless provider.nil?
          camayak_tag.replace(
            "Post::EmbeddedMedia::#{provider}Tag".constantize
              .convert_camayak(url))
        end
      end
      document.to_html
    end

    def self.remove(post_body)
      post_body.gsub(/{{[^\}]*}}/, '')
    end

    def render
      tag_list = @body.scan(/{{[a-zA-Z]*:[^\}]*?}}/)
      tags = tag_list.map { |tag| match_tag(tag) }

      execute_queries

      float_left = true
      @rendered = @body.gsub(/{{([a-zA-Z]*):([^\}]*?)}}/) do |t|
        float_left = !float_left
        tags.shift.to_html(float: float_left ? :left : :right)
      end
    end

    def find(cls, id, options = {})
      @queries[cls] ||= { models: {}, options: {} }
      @queries[cls][:models][id.to_i] = nil
      merge_options(@queries[cls][:options], options)
      promise { @queries[cls][:models][id.to_i] }
    end

    def to_s
      @rendered ||= render
    end

    private
    def execute_queries
      @queries.each do |cls, query|
        models = cls.find(query[:models].keys, query[:options])
        models.each do |model|
          query[:models][model.id] = model
        end
      end
    end

    def merge_options(original, new_options)
      original.merge!(new_options)
    end

    def match_tag(tag)
      Post::EmbeddedMedia::Tag.subclasses.each do |subclass|
        tag_obj = subclass.parse_tag(tag)
        return tag_obj unless tag_obj.nil?
      end
      raise EmbeddedMediaException, "Invalid Tag: #{tag}"
    end
  end
end
