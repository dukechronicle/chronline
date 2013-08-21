module Searchable

  ##
  # Decorator around Sunspot::Search::FacetRow. Adds a name property to rows
  # so that they can be displayed.
  #
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

  ##
  # FacetDecorator for rows that represent association ids. wrap_rows will fetch
  # all facet associations in one query and row names are a selected property of
  # the models.
  #
  class AssociationFacetDecorator < FacetDecorator
    cattr_accessor :model, :model_method

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
      record.send model_method
    end

    private
    def record
      @record ||= model.select(model_method).find(@row.value)
    end
  end
end
