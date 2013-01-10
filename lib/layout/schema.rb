class Transformation < JSON::Schema::Attribute

  def self.validate(current_schema, data, fragments, validator, options = {})
    if options[:apply_transformations]
      key = parent.is_a?(Array) ? fragments.last.to_i : fragments.last
      value = current_schema.schema['transformation'].call(data)
      parent = fragments[0..-2].reduce(options[:data]) do |data, property|
        data.is_a?(Array) ? data[property.to_i] : data[property]
      end
      parent[key] = value
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
