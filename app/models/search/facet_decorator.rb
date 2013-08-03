class Search
  class FacetDecorator

    def initialize(row)
      @row = row
    end

    def self.wrap_rows(rows)
      rows.map do |row|
        self.new(row)
      end
    end

    def name
      @row.value.titlecase
    end

    def method_missing(method, *args)
      @row.send method, *args
    end

  end

  class AssociationFacetDecorator < FacetDecorator

    def self.wrap_rows(rows)
      ids = rows.map(&:value)
      models = model_class.find(ids)
      id_map = {}
      models.each { |model| id_map[model.id] = model }

      rows.map do |row|
        self.new(row, id_map[row.value])
      end
    end

    def initialize(row, model = nil)
      @row = row
      @model = model
    end

    def name
      model.send self.class.method
    end

    private
    def model
      @model ||= self.class.model_class.find(@row.value)
    end

    def self.model_class
      @model_class
    end

    def self.method
      @method
    end

  end
end
