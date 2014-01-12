module StructuredData
  class Layout

    def initialize(schema, data)
      @schema = schema
      @data = data
    end

    def generate!
      validator = StructuredData::JSONValidator.new(
        @schema.json_schema, @data.to_json, json: true)
      validator.validate
      @model = validator.data
    end

    def validate
      validator = StructuredData::JSONValidator.new(
        @schema.json_schema, @data.to_json, json: true, record_errors: true)
      validator.validate
    end

    def method_missing(method, *args)
      generate! if @model.nil?
      @model.send(method, *args)
    end

  end
end
