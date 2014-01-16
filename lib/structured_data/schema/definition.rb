module StructuredData
  class Schema
    class Definition
      def self.schema_name
        self.name.demodulize.underscore
      end

      def schema
        {}
      end

      def json_schema
        schema = self.schema.stringify_keys
        schema['transform'] = self if respond_to? :transform
        schema['validate'] = self if respond_to? :validate
        schema
      end
    end
  end
end
