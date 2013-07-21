class Transformation < JSON::Schema::Attribute

  def self.validate(current_schema, data, fragments, processor, validator, options = {})
    if options[:apply_transformations]
      trans = current_schema.schema[:transformation]
      if not options[:apply_transformations].has_key?(trans)
        options[:apply_transformations][trans] = []
      end
      options[:apply_transformations][trans] << [fragments.clone, data]
    end
  end

end

class Layout::Schema < JSON::Schema::Validator
  SCHEMA_URI = "http://test.com/test.json"  # TODO: come up with something better

  def initialize
    super
    extend_schema_definition("http://json-schema.org/draft-03/schema#")
    @attributes['transformation'] = Transformation
    @uri = URI.parse(SCHEMA_URI)
  end

  JSON::Validator.register_validator(self.new)
end
