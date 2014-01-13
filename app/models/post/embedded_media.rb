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
        tag = match_url_to_tag(camayak_tag.attr('data-camayak-embed-url'))
        unless tag.nil?
          camayak_tag.replace(tag.to_s)
        end
      end
      document.to_html
    end

    def self.match_url_to_tag(url)
      Post::EmbeddedMedia::Tag.subclasses.each do |subclass|
        if subclass.respond_to? :parse_url
          tag_obj = subclass.parse_url(url)
          return tag_obj unless tag_obj.nil?
        end
      end
      nil
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
        tag_obj = subclass.parse_tag(tag, self)
        return tag_obj unless tag_obj.nil?
      end
      raise EmbeddedMediaException, "Invalid Tag: #{tag}"
    end
  end
end
