module StructuredData
  class Layout

    def initialize(schema, data)
      @schema = schema
      @data = data
    end

    def generate!
      @model
    end

    def validate
      JSON::Validator.fully_validate(@schema.json_schema, @data)
    end

    def method_missing(method)
      generate! if @model.nil?
      @model.send(method)
    end

  end
end
