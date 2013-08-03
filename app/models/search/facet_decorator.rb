class Search
  class FacetDecorator

    def initialize(row)
      @row = row
    end

    def name
      @row.value.titlecase
    end

    def method_missing(method, *args)
      @row.send method, *args
    end

  end

  class ActiveRecordFacetDecorator < FacetDecorator

    def name
      model.find(@row.value).send method
    end

  end

  class StaffFacetDecorator < ActiveRecordFacetDecorator
    protected
    def model; Staff; end
    def method; :name; end
  end
end
