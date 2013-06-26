module StructuredData
  class Layout

    def initialize(schema, data)
      @schema = schema
      @data = data
    end

    def generate!
      validator = StructuredData::JSONValidator.new(@schema.json_schema, @data)
      @model = validator.struct
    end

    def validate
      validator = StructuredData::JSONValidator.new(
        @schema.json_schema, @data, record_errors: true)
      validator.validate
    end

    def method_missing(method)
      generate! if @model.nil?
      @model.send(method)
    end

  end
end
