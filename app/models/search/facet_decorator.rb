class Search
  class FacetDecorator

    def initialize(row)
      @row = row
    end

    def name
      @row.value.to_s.titlecase
    end

    def method_missing(method, *args)
      @row.send method, *args
    end

  end
end
