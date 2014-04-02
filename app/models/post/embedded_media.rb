class Post
  class EmbeddedMediaException < StandardError; end
  class EmbeddedMedia
    def initialize(body)
      @body = body
      @queries = {}
    end

    ##
    # Camayak represents media embedded with OEmbed as a div with class "oembed"
    # and the data-camayak-embed-url as the URL of the embedded resource. This
    # removes the Camayak divs and replaces them with valid embedded media tags.
    #
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

    ##
    # Since all embedded media is converted to a block element in the document,
    # it is invalid to have embedded media within a <p> tag. This method scans
    # an HTML document fragment and moves all embedded media tags outside of
    # paragraph tags.
    #
    def self.normalize(body)
      normalized = ""
      document = Nokogiri::HTML::DocumentFragment.parse(body)
      document.children.each do |node|
        if node.name == "p"
          normalized << node.to_html.gsub(Tag::PATTERN) do |tag|
            normalized << tag
            ''
          end
        else
          normalized << node.to_html
        end
      end
      normalized
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

    ##
    # Remove all embedded media tags from HTML document. This is useful when the
    # body is used in a context in which embedded media cannot be displayed
    # (eg. RSS feeds).
    #
    def self.remove(body)
      body.gsub(Tag::PATTERN, '')
    end

    def render
      tags = @body.scan(Tag::PATTERN).map { |tag| match_tag(tag) }

      execute_queries

      float_right = true
      @rendered = @body.gsub(Tag::PATTERN) do |t|
        tag = tags.shift
        float =
          if !tag.full_width?
            (float_right = !float_right) ? :right : :left
          end
        tag.figure_html(float)
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
