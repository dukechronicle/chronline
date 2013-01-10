# This is a custom JSON::Validator that is hacked to perform transformations
# on the data through the validate method.

class Layout
  class Validator < JSON::Validator

    def initialize(schema_data, data, options={})
      super
      @validation_options[:apply_transformations] = true
      @validation_options[:data] = @data
    end

    def validate
      super
      @data
    end

  end
end
