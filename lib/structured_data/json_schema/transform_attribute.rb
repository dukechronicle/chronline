module StructuredData
  class JSONSchema
    class TransformAttribute < JSON::Schema::Attribute

      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        value = current_schema.schema['transform'].transform(data)
        processor.insert(fragments, value)
      end

    end
  end
end
