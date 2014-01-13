module StructuredData
  class Schema
    class Definition
      def self.schema_name
        self.name.demodulize.underscore
      end
    end
  end
end
