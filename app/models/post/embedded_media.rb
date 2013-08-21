class Post
  class EmbeddedMedia

    def initialize(body)
      @body = body
      @queries = {}
    end

    def render
      tag_list = @body.scan(/{{([a-zA-z]*):([\w\,]*)}} ?/)
      tags = tag_list.map do |tag, data|
        case tag
        when 'Image'
          ImageTag.new(self, *data.split(','))
        end
      end

      execute_queries

      float_left = true
      @rendered = @body.gsub(/{{([a-zA-z]*):([\w\,]*)}} ?/) do |t|
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

  end
end
