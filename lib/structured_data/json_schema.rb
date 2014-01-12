module StructuredData
  class JSONSchema < JSON::Schema::Validator
    SCHEMA_URI = "http://test.com/test.json"  # TODO: come up with something better

    def initialize
      super
      extend_schema_definition("http://json-schema.org/draft-04/schema#")
      # @attributes['type'] = TypeAttribute
      @attributes['transform'] = TransformAttribute
      @uri = URI.parse(SCHEMA_URI)
    end

    JSON::Validator.register_validator(self.new)
  end
end
