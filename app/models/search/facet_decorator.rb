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
      records = model.select([:id, model_method]).find(ids)
      id_map = Hash[records.map { |record| [record.id, record] }]

      rows.map do |row|
        self.new(row, id_map[row.value])
      end
    end

    def initialize(row, record = nil)
      @row = row
      @record = record
    end

    def name
      record.send self.class.model_method
    end

    private
    def record
      @record ||= self.class.model.select(model_method).find(@row.value)
    end

    def self.model
      @model
    end

    def self.model_method
      @model_method
    end
  end
end
