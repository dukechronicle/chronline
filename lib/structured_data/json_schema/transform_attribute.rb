module StructuredData
  class JSONSchema
    class TransformAttribute < JSON::Schema::Attribute

      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        definition = current_schema.schema['transform']
        value = definition.transform(data)
        processor.insert(fragments, value)
      end

    end
  end
end
