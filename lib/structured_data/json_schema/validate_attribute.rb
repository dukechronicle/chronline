module StructuredData
  class JSONSchema
    class ValidateAttribute < JSON::Schema::Attribute

      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        processor.add_validation(fragments, current_schema.schema['validate']) do |message|
          validation_error(
            processor,
            message,
            fragments,
            current_schema,
            self,
            options[:record_errors]
          )
        end
      end

    end
  end
end
