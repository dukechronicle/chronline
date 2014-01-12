module StructuredData
  class JSONSchema
    class TypeAttribute < JSON::Schema::TypeV4Attribute

      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        processor.insert(fragments, data)
        super # (current_schema, data, fragments, processor, validator, options)
      end

    end
  end
end
