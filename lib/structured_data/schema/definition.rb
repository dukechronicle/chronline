module StructuredData
  class Schema
    class Definition
      def self.json_schema
        instance = self.new
        instance.schema.merge('transform' => instance)
      end

      def self.schema_name
        self.name.demodulize.underscore
      end
    end
  end
end
