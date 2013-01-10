class Layout::Schema < JSON::Schema::Validator
  SCHEMA_URI = "http://test.com/test.json"  # TODO: come up with something better

  def initialize
    super
    extend_schema_definition("http://json-schema.org/draft-03/schema#")
    @uri = URI.parse(SCHEMA_URI)
  end

  JSON::Validator.register_validator(self.new)
end
