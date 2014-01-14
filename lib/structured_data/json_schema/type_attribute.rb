module StructuredData
  class JSONSchema
    class TypeAttribute < JSON::Schema::TypeV4Attribute

      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        super
        if current_schema.schema['type'] == 'object'
          processor.insert(fragments, OpenStruct.new(data))
        end
      end

    end
  end
end
